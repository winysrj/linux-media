Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZEWIGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 04:06:30 -0400
Date: Sat, 23 May 2009 05:06:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"xlzhang76@gmail.com" <xlzhang76@gmail.com>
Subject: Re: [PATCH 1/5 - part 1] V4L2 patches for Intel Moorestown Camera
 Imaging Drivers
Message-ID: <20090523050620.743fb6e5@pedra.chehab.org>
In-Reply-To: <0A882F4D99BBF6449D58E61AAFD7EDD613810F0D@pdsmsx502.ccr.corp.intel.com>
References: <0A882F4D99BBF6449D58E61AAFD7EDD613810F0D@pdsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Xiaolin,

Due to the big size of this patch series, I'll take some time to be able to review your entire code.

For now, those are my comments for the first patch of your series.

Cheers,
Mauro.


Em Mon, 4 May 2009 17:03:29 +0800
"Zhang, Xiaolin" <xiaolin.zhang@intel.com> escreveu:

> From 0416e9fc1f18d8d7c81eca6f7e2255072094c0ed Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Mon, 4 May 2009 14:34:29 +0800
> Subject: [PATCH] [Part 1] header files - camera imaging ISP driver on Intel Moorestown platform under V4L2
>  driver framework. The ISP block in Moorestown can do HW JPEg encoding and
>  is also capable of sending 4:2:2 and 4:2:0 YUV and RGB full frames.
>  Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> 
> ---
>  drivers/media/video/Kconfig                        |    1 +
>  drivers/media/video/Makefile                       |    1 +
>  drivers/media/video/mrstci/Kconfig                 |   14 +
>  drivers/media/video/mrstci/include/ci_isp_common.h | 1412 ++++++++
>  drivers/media/video/mrstci/include/ci_isp_fmts.h   |   46 +
>  .../video/mrstci/include/ci_isp_fmts_common.h      |  128 +
>  .../media/video/mrstci/include/ci_sensor_common.h  |  733 +++++
>  drivers/media/video/mrstci/include/ci_sensor_isp.h |   38 +
>  drivers/media/video/mrstci/include/ci_va.h         |   43 +
>  drivers/media/video/mrstci/mrstisp/Kconfig         |    9 +
>  drivers/media/video/mrstci/mrstisp/include/debug.h |   73 +
>  drivers/media/video/mrstci/mrstisp/include/def.h   |  120 +
>  .../video/mrstci/mrstisp/include/intel_v4l2.h      |  181 +
>  drivers/media/video/mrstci/mrstisp/include/mrv.h   |  105 +
>  .../media/video/mrstci/mrstisp/include/mrv_jpe.h   |  404 +++
>  .../media/video/mrstci/mrstisp/include/mrv_priv.h  | 3464 ++++++++++++++++++++
>  .../media/video/mrstci/mrstisp/include/mrv_sls.h   |  248 ++
>  .../video/mrstci/mrstisp/include/reg_access.h      |  220 ++
>  .../media/video/mrstci/mrstisp/include/stdinc.h    |  114 +
>  19 files changed, 7354 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstci/Kconfig
>  create mode 100644 drivers/media/video/mrstci/include/ci_isp_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_isp_fmts.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_isp_fmts_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_sensor_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_sensor_isp.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_va.h
>  create mode 100755 drivers/media/video/mrstci/mrstisp/Kconfig
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/debug.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/def.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/intel_v4l2.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrv.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrv_jpe.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrv_priv.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrv_sls.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/reg_access.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/stdinc.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 9d48da2..a358a1b 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -918,4 +918,5 @@ config USB_S2255
>           This driver can be compiled as a module, called s2255drv.
> 
>  endif # V4L_USB_DRIVERS
> +source "drivers/media/video/mrstci/Kconfig"
>  endif # VIDEO_CAPTURE_DRIVERS
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 3f1a035..f06f1cb 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -151,6 +151,7 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)             += tw9910.o
>  obj-$(CONFIG_VIDEO_AU0828) += au0828/
> 
>  obj-$(CONFIG_USB_VIDEO_CLASS)  += uvc/
> +obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
> 
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
> new file mode 100644
> index 0000000..924bb9d
> --- /dev/null
> +++ b/drivers/media/video/mrstci/Kconfig
> @@ -0,0 +1,14 @@
> +menuconfig VIDEO_MRSTCI
> +        bool "Moorestown Langwell Camera Imaging Subsystem support"
> +        depends on VIDEO_V4L2
> +        default y
> +
> +        ---help---
> +       Say Y here to enable selecting the Intel Moorestown Langwell Camera Imaging Subsystem for webcams.
> +
> +if VIDEO_MRSTCI && VIDEO_V4L2
> +
> +source "drivers/media/video/mrstci/mrstisp/Kconfig"
> +
> +endif # VIDEO_MRSTCI
> +
> diff --git a/drivers/media/video/mrstci/include/ci_isp_common.h b/drivers/media/video/mrstci/include/ci_isp_common.h
> new file mode 100644
> index 0000000..090021d
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_isp_common.h
> @@ -0,0 +1,1412 @@
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
> +#ifndef _CI_ISP_COMMON_H
> +#define _CI_ISP_COMMON_H
> +
> +/*
> + * MARVIN VI ID defines -> changed to MARVIN_FEATURE_CHIP_ID and moved to
> + * the other chip features in project_settings.h
> + * JPEG compression ratio defines
> + */
> +
> +#define CI_ISP_JPEG_HIGH_COMPRESSION    1
> +#define CI_ISP_JPEG_LOW_COMPRESSION     2
> +/* Low Compression / High Quality */
> +#define CI_ISP_JPEG_01_PERCENT          3
> +#define CI_ISP_JPEG_20_PERCENT          4
> +#define CI_ISP_JPEG_30_PERCENT          5
> +#define CI_ISP_JPEG_40_PERCENT          6
> +/* Mid Compression / Mid Quality */
> +#define CI_ISP_JPEG_50_PERCENT          7
> +#define CI_ISP_JPEG_60_PERCENT          8
> +#define CI_ISP_JPEG_70_PERCENT          9
> +#define CI_ISP_JPEG_80_PERCENT         10
> +#define CI_ISP_JPEG_90_PERCENT         11
> +/* High Compression / Low Quality */
> +#define CI_ISP_JPEG_99_PERCENT         12
> +
> +/* Size of lens shading data table in 16 Bit words */
> +#define CI_ISP_DATA_TBL_SIZE      289
> +/* Size of lens shading grad table in 16 Bit words */
> +#define CI_ISP_GRAD_TBL_SIZE        8
> +/* Number of lens shading sectors in x or y direction */
> +#define CI_ISP_MAX_LSC_SECTORS     16
> +
> +/*
> + * Value representing 1.0 for fixed-point values
> + * used by marvin drivers
> + */
> +#define CI_ISP_FIXEDPOINT_ONE   (0x1000)
> +/* JPEG encoding */
> +
> +enum ci_isp_jpe_enc_mode {
> +#if (MARVIN_FEATURE_JPE_CFG == MARVIN_FEATURE_JPE_CFG_V2)
> +       /*single snapshot with Scalado encoding*/
> +       CI_ISP_JPE_SCALADO_MODE = 0x08,
> +#endif
> +       /* motion JPEG with header generation */
> +       CI_ISP_JPE_LARGE_CONT_MODE = 0x04,
> +       /* motion JPEG only first frame with header */
> +       CI_ISP_JPE_SHORT_CONT_MODE = 0x02,
> +       /* JPEG with single snapshot */
> +       CI_ISP_JPE_SINGLE_SHOT = 0x01
> +};
> +
> +/* for demosaic mode */
> +enum ci_isp_demosaic_mode {
> +       CI_ISP_DEMOSAIC_STANDARD,
> +       CI_ISP_DEMOSAIC_ENHANCED
> +};
> +
> +struct ci_isp_window{
> +       unsigned short hoffs;
> +       unsigned short voffs;
> +       unsigned short hsize;
> +       unsigned short vsize;
> +};
> +
> +/* scale settings for both self and main resize unit */
> +struct ci_isp_scale {
> +       u32 scale_hy;
> +       u32 scale_hcb;
> +       u32 scale_hcr;
> +       u32 scale_vy;
> +       u32 scale_vc;
> +       u16 phase_hy;
> +       u16 phase_hc;
> +       u16 phase_vy;
> +       u16 phase_vc;
> +};
> +
> +/* A Lookup table for the upscale parameter in the self and main scaler */
> +struct ci_isp_rsz_lut{
> +       u8 rsz_lut[64];
> +};
> +
> +#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
> +/* flag to set in scalefactor values to enable upscaling */
> +#define RSZ_UPSCALE_ENABLE 0x20000
> +#else
> +/* flag to set in scalefactor values to enable upscaling */
> +#define RSZ_UPSCALE_ENABLE 0x8000
> +/* #if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS) */
> +#endif
> +
> +/*
> + * Flag to set in scalefactor values to bypass the scaler block.
> + * Since this define is also used in calculations of scale factors and
> + * coordinates, it needs to reflect the scale factor precision. In other
> + * words:
> + * RSZ_SCALER_BYPASS = max. scalefactor value> + 1
> + */
> +#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_12BITS)
> +#define RSZ_SCALER_BYPASS  0x1000
> +#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_14BITS)
> +#define RSZ_SCALER_BYPASS  0x4000
> +#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
> +#define RSZ_SCALER_BYPASS  0x10000
> +#endif
> +
> +#define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
> +
> +/* color settings */
> +struct ci_isp_color_settings {
> +       u8 contrast;
> +       u8 brightness;
> +       u8 saturation;
> +       u8 hue;
> +       u32 flags;
> +};
> +
> +/* color processing chrominance clipping range */
> +#define CI_ISP_CPROC_C_OUT_RANGE       0x08
> +/* color processing luminance input range (offset processing) */
> +#define CI_ISP_CPROC_Y_IN_RANGE        0x04
> +/* color processing luminance output clipping range */
> +#define CI_ISP_CPROC_Y_OUT_RANGE       0x02
> +/* color processing enable */
> +#define CI_ISP_CPROC_ENABLE            0x01
> +
> +/* black level config */
> +struct ci_isp_blc_config {
> +       int bls_auto;
> +       int henable;
> +       int venable;
> +       u16 hstart;
> +       u16 hstop;
> +       u16 vstart;
> +       u16 vstop;
> +       u8 blc_samples;
> +       u8 ref_a;
> +       u8 ref_b;
> +       u8 ref_c;
> +       u8 ref_d;
> +};
> +
> +/* black level compensation mean values */
> +struct ci_isp_blc_mean {
> +       u8 mean_a;
> +       u8 mean_b;
> +       u8 mean_c;
> +       u8 mean_d;
> +};
> +
> +/* BLS window */
> +struct ci_isp_bls_window {
> +
> +       /* En-/disable the measurement window. */
> +       int enable_window;
> +       /* Horizontal start address. */
> +       u16 start_h;
> +       /* Horizontal stop address. */
> +       u16 stop_h;
> +       /* Vertical start address. */
> +       u16 start_v;
> +       /* Vertical stop address. */
> +       u16 stop_v;
> +};
> +
> +/* BLS mean measured values */
> +struct ci_isp_bls_measured {
> +       /* Mean measured value for Bayer pattern position A. */
> +       u16 meas_a;
> +       /* Mean measured value for Bayer pattern position B. */
> +       u16 meas_b;
> +       /* Mean measured value for Bayer pattern position C. */
> +       u16 meas_c;
> +       /* Mean measured value for Bayer pattern position D. */
> +       u16 meas_d;
> +};
> +
> +/*
> + * BLS fixed subtraction values. The values will be subtracted from the sensor
> + * values.  Therefore a negative value means addition instead of subtraction
> + */
> +struct ci_isp_bls_subtraction {
> +       /* Fixed (signed ) subtraction value for Bayer pattern position A. */
> +       s16 fixed_a;
> +       /* Fixed (signed ) subtraction value for Bayer pattern position B. */
> +       s16 fixed_b;
> +       /* Fixed (signed ) subtraction value for Bayer pattern position C. */
> +       s16 fixed_c;
> +       /* Fixed (signed ) subtraction value for Bayer pattern position D. */
> +       s16 fixed_d;
> +};
> +
> +/* BLS configuration */
> +struct ci_isp_bls_config {
> +       /*
> +        * Automatic mode activated means that the measured values are
> +        * subtracted. Otherwise the fixed subtraction values will be
> +        * subtracted.
> +        */
> +       int enable_automatic;
> +       /* En-/disable horizontal accumulation for mean black value. */
> +       int disable_h;
> +       /*
> +        * BLS module versions 4 or higher imply that it is enabled.
> +        * En-/disable vertical accumulation for mean black value.
> +        */
> +       int disable_v;
> +       /* Measurement window 1. */
> +       struct ci_isp_bls_window isp_bls_window1;
> +       /* Measurement window 2. */
> +       struct ci_isp_bls_window isp_bls_window2;
> +
> +       /*
> +        * BLS module version 3 and lower do not support a second
> +        * measurement window. Therefore the second window has to
> +        * be disabled for these versions.
> +        */
> +
> +       /*
> +        * Set amount of measured pixels for each Bayer position (A, B,
> +        * C and D) to 2^bls_samples.
> +        */
> +       u8 bls_samples;
> +       /* Fixed subtraction values. */
> +       struct ci_isp_bls_subtraction bls_subtraction;
> +};
> +
> +/* white balancing modes for the marvin hardware */
> +enum ci_isp_awb_mode {
> +       CI_ISP_AWB_COMPLETELY_OFF = 0,
> +       CI_ISP_AWB_AUTO,
> +       CI_ISP_AWB_MAN_MEAS,
> +       CI_ISP_AWB_MAN_NOMEAS,
> +       CI_ISP_AWB_MAN_PUSH_AUTO,
> +       CI_ISP_AWB_ONLY_MEAS
> +};
> +
> +/* white balancing modes for the marvin hardware */
> +enum ci_isp_awb_sub_mode {
> +       CI_ISP_AWB_SUB_OFF = 0,
> +       CI_ISP_AWB_MAN_DAYLIGHT,
> +       CI_ISP_AWB_MAN_CLOUDY,
> +       CI_ISP_AWB_MAN_SHADE,
> +       CI_ISP_AWB_MAN_FLUORCNT,
> +       CI_ISP_AWB_MAN_FLUORCNTH,
> +       CI_ISP_AWB_MAN_TUNGSTEN,
> +       CI_ISP_AWB_MAN_TWILIGHT,
> +       CI_ISP_AWB_MAN_SUNSET,
> +       CI_ISP_AWB_MAN_FLASH,
> +       CI_ISP_AWB_MAN_CIE_D65,
> +       CI_ISP_AWB_MAN_CIE_D75,
> +       CI_ISP_AWB_MAN_CIE_F2,
> +       CI_ISP_AWB_MAN_CIE_F11,
> +       CI_ISP_AWB_MAN_CIE_F12,
> +       CI_ISP_AWB_MAN_CIE_A,
> +       CI_ISP_AWB_AUTO_ON
> +};
> +
> +/*
> + * white balancing gains
> + * xiaolin, typedef ci_sensor_component_gain tsMrvWbGains;
> + * white balancing measurement configuration
> + */
> +struct ci_isp_wb_meas_config {
> +       /* white balance measurement window (in pixels) */
> +       struct ci_isp_window awb_window;
> +       /*
> +        * only pixels values  max_y contribute to WB measurement
> +        * (set to 0 to disable this feature)
> +        */
> +       u8 max_y;
> +       /* only pixels values > min_y contribute to WB measurement */
> +       u8 ref_cr_MaxR;
> +       u8 minY_MaxG;
> +       u8 ref_cb_MaxB;
> +       /*
> +        * Chrominance sum maximum value, only consider pixels with Cb+Cr
> +        * smaller than threshold for WB measurements
> +        */
> +       u8 max_csum;
> +
> +       /*
> +        * Chrominance minimum value, only consider pixels with Cb/Cr each
> +        * greater than threshold value for WB measurements
> +        */
> +       u8 min_c;
> +       /*
> +        * number of frames+1 used for mean value calculation (frames=0
> +        * means 1 Frame)
> +        */
> +       u8 frames;
> +       u8 meas_mode;
> +};
> +
> +/* white balancing measurement configuration limits */
> +struct ci_isp_wb_meas_conf_limit {
> +       /* maximum value for MinY */
> +       u8 min_y_max;
> +       /* minimum value for MinY */
> +       u8 min_y_min;
> +       /* maximum value for MinC */
> +       u8 min_c_max;
> +       /* minimum value for MinC */
> +       u8 min_c_min;
> +       /* maximum value for MaxCSum */
> +       u8 max_csum_max;
> +       /* minimum value for MaxCSum */
> +       u8 max_csum_min;
> +       /* maximum value for white pixel percentage */
> +       u8 white_percent_max;
> +       /* minimum value for white pixel percentage */
> +       u8 white_percent_min;
> +       /*
> +        * maximum number of not measured frames until the gain values
> +        * will be set to their initial values
> +        */
> +       u8 error_counter;
> +};
> +
> +/* white balancing HW automatic configuration */
> +struct ci_isp_wb_auto_hw_config {
> +       /* reference C values */
> +       u8 ref_cr;
> +       u8 ref_cb;
> +       /* lock / unlock settings */
> +       u8 unlock_dly;
> +       u8 unlock_rng;
> +       u8 lock_dly;
> +       u8 lock_rng;
> +       /* maximum gain step size */
> +       u8 step;
> +       /* gain limits */
> +       u8 max_gain;
> +       u8 min_gain;
> +};
> +
> +/* white balancing configuration */
> +struct ci_isp_wb_config {
> +       /* mode of operation */
> +       enum ci_isp_awb_mode mrv_wb_mode;
> +       enum ci_isp_awb_sub_mode mrv_wb_sub_mode;
> +       /* measurement configuration */
> +       struct ci_isp_wb_meas_config mrv_wb_meas_conf;
> +       /* HW automatic configuration */
> +       struct ci_isp_wb_auto_hw_config mrv_wb_auto_hw_conf;
> +       /*
> +        * gain values
> +        * xiaolin, tsMrvWbGains   mrv_wb_gains;
> +        * measurement limits
> +        */
> +       struct ci_isp_wb_meas_conf_limit mrv_wb_meas_conf_limit;
> +       /* Pca Damping for awb auto mode */
> +       u8 awb_pca_damping;
> +       /* PriorExp Damping for awb auto mode */
> +       u8 awb_prior_exp_damping;
> +       /* Pca Damping for AWB auto push mode */
> +       u8 awb_pca_push_damping;
> +       /* PriorExp Damping for AWB auto push mode */
> +       u8 awb_prior_exp_push_damping;
> +       /* Max Y in AWB auto mode */
> +       u8 awb_auto_max_y;
> +       /* Max Y in AWB auto push mode */
> +       u8 awb_push_max_y;
> +       /* Max Y in AWB measurement only mode */
> +       u8 awb_measure_max_y;
> +       /* Distance for underexposure detecture */
> +       u16 awb_underexp_det;
> +       /* Distance for underexposure push detecture */
> +       u16 awb_push_underexp_det;
> +
> +};
> +
> +/* possible AEC modes */
> +enum ci_isp_aec_mode {
> +       /* AEC turned off */
> +       CI_ISP_AEC_OFF,
> +       /* AEC measurements based on (almost) the entire picture */
> +       CI_ISP_AEC_INTEGRAL,
> +       /*
> +        * AEC measurements based on a single little square in the center of
> +        * the picture
> +        */
> +       CI_ISP_AEC_SPOT,
> +       /*
> +        * AEC measurements based on 5 little squares spread over the picture
> +        */
> +       CI_ISP_AEC_MFIELD5,
> +       /*
> +        * AEC measurements based on 9 little squares spread over the picture
> +        */
> +       CI_ISP_AEC_MFIELD9
> +};
> +
> +
> +/*
> + * histogram weight 5x5 matrix coefficients
> +* (possible values are 1=0x10,15/16=0x0F,14/16,...,1/16,0)
> +*/
> +struct ci_isp_hist_matrix {
> +       u8 weight_00; u8 weight_10; u8 weight_20; u8 weight_30; u8 weight_40;
> +       u8 weight_01; u8 weight_11; u8 weight_21; u8 weight_31; u8 weight_41;
> +       u8 weight_02; u8 weight_12; u8 weight_22; u8 weight_32; u8 weight_42;
> +       u8 weight_03; u8 weight_13; u8 weight_23; u8 weight_33; u8 weight_43;
> +       u8 weight_04; u8 weight_14; u8 weight_24; u8 weight_34; u8 weight_44;
> +};
> +
> +/* autoexposure config */
> +struct ci_isp_aec_config {
> +       /*
> +        * Size of 1 window of MARVIN's 5x5 mean luminance
> +        * measurement grid and offset of grid
> +        */
> +       struct ci_isp_window isp_aecmean_lumaWindow;
> +       /* Size and offset of histogram window */
> +       struct ci_isp_window isp_aechist_calcWindow;
> +       /* Weight martix of histogram */
> +       struct ci_isp_hist_matrix isp_aechist_calcWeight;
> +       /* possible AEC modes */
> +       enum ci_isp_aec_mode advanced_aec_mode;
> +};
> +
> +/* autoexposure mean values */
> +struct ci_isp_aec_mean {
> +       u8 occ;
> +       u8 mean;
> +       u8 max;
> +       u8 min;
> +};
> +
> +
> +
> +/* histogram weight 5x5 matrix coefficients
> + * (possible values are 1=0x10,15/16=0x0F,14/16,...,1/16,0)
> + */
> +struct tsMrvHistMatrix {
> +       u8 weight_00; u8 weight_10; u8 weight_20; u8 weight_30; u8 weight_40;
> +       u8 weight_01; u8 weight_11; u8 weight_21; u8 weight_31; u8 weight_41;
> +       u8 weight_02; u8 weight_12; u8 weight_22; u8 weight_32; u8 weight_42;
> +       u8 weight_03; u8 weight_13; u8 weight_23; u8 weight_33; u8 weight_43;
> +       u8 weight_04; u8 weight_14; u8 weight_24; u8 weight_34; u8 weight_44;
> +};
> +
> +/*
> + * vi_dpcl path selector, channel mode
> + * Configuration of the Y/C splitter
> + */
> +enum ci_isp_ycs_chn_mode {
> +       /*
> +        * 8bit data/Y only output (depreciated, please use CI_ISP_YCS_MVRaw for
> +        * new implementations)
> +        */
> +       CI_ISP_YCS_Y,
> +       /* separated 8bit Y, C routed to both main and self path */
> +       CI_ISP_YCS_MV_SP,
> +       /*
> +        * separated 8bit Y, C routed to main path only (self path input
> +        * switched off)
> +        */
> +       CI_ISP_YCS_MV,
> +       /*
> +        * separated 8bit Y, C routed to self path only (main path input
> +        * switched off)
> +        */
> +       CI_ISP_YCS_SP,
> +       /*
> +        * raw camera data routed to main path (8 or 16 bits, depends on
> +        * marvin drivative)
> +        */
> +       CI_ISP_YCS_MVRaw,
> +       /* both main and self path input switched off */
> +       CI_ISP_YCS_OFF
> +};
> +
> +/* vi_dpcl path selector, main path cross-switch */
> +enum ci_isp_dp_switch {
> +       /* raw data mode */
> +       CI_ISP_DP_RAW,
> +       /* JPEG encoding mode */
> +       CI_ISP_DP_JPEG,
> +       /* main video path only */
> +       CI_ISP_DP_MV
> +};
> +
> +/* DMA-read mode selector */
> +enum ci_isp_dma_read_mode {
> +       /* DMA-read feature deactivated */
> +       CI_ISP_DMA_RD_OFF = 0,
> +       /* data from the DMA-read block feeds the self path */
> +       CI_ISP_DMA_RD_SELF_PATH = 1,
> +       /* data from the DMA-read block feeds the Superimpose block */
> +       CI_ISP_DMA_RD_SUPERIMPOSE = 2,
> +       /* data from the DMA-read block feeds the Image effects path */
> +       CI_ISP_DMA_RD_IE_PATH = 3,
> +       /* data from the DMA-read block feeds the JPEG encoder directly */
> +       CI_ISP_DMA_RD_JPG_ENC = 4
> +};
> +
> +/* ISP path selector */
> +enum ci_isp_path {
> +       /* Isp path is unknown or invalid */
> +       CI_ISP_PATH_UNKNOWN = 0,
> +       /* Raw data bypass */
> +       CI_ISP_PATH_RAW = 1,
> +       /* YCbCr path */
> +       CI_ISP_PATH_YCBCR = 2,
> +       /* Bayer RGB path */
> +       CI_ISP_PATH_BAYER = 3
> +};
> +
> +/* possible autofocus measurement modes */
> +enum ci_isp_afm_mode {
> +       /* no autofocus measurement */
> +       CI_ISP_AFM_OFF,
> +       /* use AF hardware to measure sharpness */
> +       CI_ISP_AFM_HW,
> +       /* use "Tenengrad" algorithm implemented in software */
> +       CI_ISP_AFM_SW_TENENGRAD,
> +       /*
> +        * use "Threshold Squared Gradient" algorithm implemented in software
> +        */
> +       CI_ISP_AFM_SW_TRESH_SQRT_GRAD,
> +       /*
> +        * use "Frequency selective weighted median" algorithm implemented in
> +        * software
> +        */
> +       CI_ISP_AFM_SW_FSWMEDIAN,
> +       /* use AF hardware and normalize with mean luminance */
> +       CI_ISP_AFM_HW_norm,
> +       /* use "Tenengrad" algorithm and normalize with mean luminance */
> +       CI_ISP_AFM_SW_TENENGRAD_norm,
> +       /*
> +        * use "Frequency selective weighted median" algorithm and normalize
> +        * with mean luminance
> +        */
> +       CI_ISP_AFM_SW_FSWMEDIAN_norm
> +};
> +
> +/* possible autofocus search strategy modes */
> +enum ci_isp_afss_mode {
> +       /* no focus searching */
> +       CI_ISP_AFSS_OFF,
> +       /* scan the full focus range to find the point of best focus */
> +       CI_ISP_AFSS_FULL_RANGE,
> +       /* use hillclimbing search */
> +       CI_ISP_AFSS_HILLCLIMBING,
> +       /*
> +        * similar to full range search, but with multiple subsequent scans
> +        * with
> +        */
> +       CI_ISP_AFSS_ADAPTIVE_RANGE,
> +       /*
> +        * decreasing range and step size will be performed.  search strategy
> +        * suggested by OneLimited for their Helimorph actuator
> +        */
> +       CI_ISP_AFSS_HELIMORPH_OPT,
> +       /*
> +        * search strategy optimized for omnivision 2630 module equipped with
> +        */
> +       CI_ISP_AFSS_OV2630_LPD4_OPT
> +       /*
> +        * autofocus lend driven through a LPD4 stepper motor produced by
> +        * Nidec Copal USA Corp. of Torrance, CA.
> +        */
> +};
> +
> +/* possible bad pixel correction type */
> +enum ci_isp_bp_corr_type {
> +       /* correction of bad pixel from the table */
> +       CI_ISP_BP_CORR_TABLE,
> +       /* direct detection and correction */
> +       CI_ISP_BP_CORR_DIRECT
> +};
> +
> +/* possible bad pixel replace approach */
> +enum ci_isp_bp_corr_rep {
> +       /* nearest neighbour approach */
> +       CI_ISP_BP_CORR_REP_NB,
> +       /* simple bilinear interpolation approach */
> +       CI_ISP_BP_CORR_REP_LIN
> +};
> +
> +/* possible bad pixel correction mode */
> +enum ci_isp_bp_corr_mode {
> +       /* hot pixel correction */
> +       CI_ISP_BP_CORR_HOT_EN,
> +       /* dead pixel correction */
> +       CI_ISP_BP_CORR_DEAD_EN,
> +       /* hot and dead pixel correction */
> +       CI_ISP_BP_CORR_HOT_DEAD_EN
> +};
> +
> +/* Gamma out curve (independent from the sensor characteristic). */
> +#define CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE (17)
> +
> +struct ci_isp_gamma_out_curve {
> +       u16 isp_gamma_y[CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE];
> +       u8 gamma_segmentation;
> +};
> +
> +/* configuration of autofocus measurement block */
> +struct ci_isp_af_config {
> +       /* position and size of measurement window A */
> +       struct ci_isp_window wnd_pos_a;
> +       /* position and size of measurement window B */
> +       struct ci_isp_window wnd_pos_b;
> +       /* position and size of measurement window C */
> +       struct ci_isp_window wnd_pos_c;
> +       /* AF measurment threshold */
> +       u32 threshold;
> +       /* measurement variable shift (before sum operation) */
> +       u32 var_shift;
> +};
> +
> +/* measurement results of autofocus measurement block */
> +struct ci_isp_af_meas {
> +       /* sharpness value of window A */
> +       u32 afm_sum_a;
> +       /* sharpness value of window B */
> +       u32 afm_sum_b;
> +       /* sharpness value of window C */
> +       u32 afm_sum_c;
> +       /* luminance value of window A */
> +       u32 afm_lum_a;
> +       /* luminance value of window B */
> +       u32 afm_lum_b;
> +       /* luminance value of window C */
> +       u32 afm_lum_c;
> +};
> +
> +/* configuration for correction of bad pixel block */
> +struct ci_isp_bp_corr_config {
> +       /* bad pixel correction type */
> +       enum ci_isp_bp_corr_type bp_corr_type;
> +       /* replace approach */
> +       enum ci_isp_bp_corr_rep bp_corr_rep;
> +       /* bad pixel correction mode */
> +       enum ci_isp_bp_corr_mode bp_corr_mode;
> +       /* Absolute hot pixel threshold */
> +       u16 bp_abs_hot_thres;
> +       /* Absolute dead pixel threshold */
> +       u16 bp_abs_dead_thres;
> +       /* Hot Pixel deviation Threshold */
> +       u16 bp_dev_hot_thres;
> +       /* Dead Pixel deviation Threshold */
> +       u16 bp_dev_dead_thres;
> +};
> +
> +/* configuration for correction of lens shading */
> +struct ci_isp_ls_corr_config {
> +       /* correction values of R color part */
> +       u16 ls_rdata_tbl[CI_ISP_DATA_TBL_SIZE];
> +       /* correction values of G color part */
> +       u16 ls_gdata_tbl[CI_ISP_DATA_TBL_SIZE];
> +       /* correction values of B color part */
> +       u16 ls_bdata_tbl[CI_ISP_DATA_TBL_SIZE];
> +       /* multiplication factors of x direction */
> +       u16 ls_xgrad_tbl[CI_ISP_GRAD_TBL_SIZE];
> +       /* multiplication factors of y direction */
> +       u16 ls_ygrad_tbl[CI_ISP_GRAD_TBL_SIZE];
> +       /* sector sizes of x direction */
> +       u16 ls_xsize_tbl[CI_ISP_GRAD_TBL_SIZE];
> +       /* sector sizes of y direction */
> +       u16 ls_ysize_tbl[CI_ISP_GRAD_TBL_SIZE];
> +
> +};
> +
> +/* configuration for detection of bad pixel block */
> +struct ci_isp_bp_det_config {
> +       /* abs_dead_thres       Absolute dead pixel threshold */
> +       u32 bp_dead_thres;
> +};
> +
> +/* new table element */
> +struct ci_isp_bp_new_table_elem {
> +       /* Bad Pixel vertical address */
> +       u16 bp_ver_addr;
> +       /* Bad Pixel horizontal address */
> +       u16 bp_hor_addr;
> +       /* MSB value of fixed pixel (deceide if dead or hot) */
> +       u8 bp_msb_value;
> +};
> +
> +/* new Bad Pixel table */
> +struct ci_isp_bp_new_table {
> +       /* Number of possible new detected bad pixel */
> +       u32 bp_number;
> +       /* Array of Table element */
> +       struct ci_isp_bp_new_table_elem bp_new_table_elem[8];
> +};
> +
> +/* image effect modes */
> +enum ci_isp_ie_mode {
> +       /* no image effect (bypass) */
> +       CI_ISP_IE_MODE_OFF,
> +       /* Set a fixed chrominance of 128 (neutral grey) */
> +       CI_ISP_IE_MODE_GRAYSCALE,
> +       /* Luminance and chrominance data is being inverted */
> +       CI_ISP_IE_MODE_NEGATIVE,
> +       /*
> +        * Chrominance is changed to produce a historical like brownish image
> +        * color
> +        */
> +       CI_ISP_IE_MODE_SEPIA,
> +       /*
> +        * Converting picture to grayscale while maintaining one color
> +        * component.
> +        */
> +       CI_ISP_IE_MODE_COLOR_SEL,
> +       /* Edge detection, will look like an relief made of metal */
> +       CI_ISP_IE_MODE_EMBOSS,
> +       /* Edge detection, will look like a pencil drawing */
> +       CI_ISP_IE_MODE_SKETCH
> +};
> +
> +/* image effect color selection */
> +enum ci_isp_ie_color_sel {
> +       /* in CI_ISP_IE_MODE_COLOR_SEL mode, maintain the red color */
> +       CI_ISP_IE_MAINTAIN_RED = 0x04,
> +       /* in CI_ISP_IE_MODE_COLOR_SEL mode, maintain the green color */
> +       CI_ISP_IE_MAINTAIN_GREEN = 0x02,
> +       /* in CI_ISP_IE_MODE_COLOR_SEL mode, maintain the blue color */
> +       CI_ISP_IE_MAINTAIN_BLUE = 0x01
> +};
> +
> +/*
> + * image effect 3x3 matrix coefficients (possible values are -8, -4, -2, -1,
> + * 0, 1, 2, 4, 8)
> + */
> +struct ci_isp_ie_matrix {
> +       s8 coeff_11;
> +       s8 coeff_12;
> +       s8 coeff_13;
> +       s8 coeff_21;
> +       s8 coeff_22;
> +       s8 coeff_23;
> +       s8 coeff_31;
> +       s8 coeff_32;
> +       s8 coeff_33;
> +};
> +
> +/* image effect configuration struct */
> +struct ci_isp_ie_config {
> +       /* image effect mode */
> +       enum ci_isp_ie_mode mode;
> +       u8 color_sel;
> +       /* threshold for color selection */
> +       u8 color_thres;
> +       /* Cb chroma component of 'tint' color for sepia effect */
> +       u8 tint_cb;
> +       /* Cr chroma component of 'tint' color for sepia effect */
> +       u8 tint_cr;
> +       /* coefficient maxrix for emboss effect */
> +       struct ci_isp_ie_matrix mat_emboss;
> +       /* coefficient maxrix for sketch effect */
> +       struct ci_isp_ie_matrix mat_sketch;
> +};
> +
> +/* super impose transparency modes */
> +enum ci_isp_si_trans_mode {
> +       /* SI transparency mode is unknown (module is switched off) */
> +       CI_ISP_SI_TRANS_UNKNOWN = 0,
> +       /* SI transparency mode enabled */
> +       CI_ISP_SI_TRANS_ENABLE = 1,
> +       /* SI transparency mode disabled */
> +       CI_ISP_SI_TRANS_DISABLE = 2
> +};
> +
> +/* super impose reference image */
> +enum ci_isp_si_ref_image {
> +       /* SI reference image is unknown (module is switched off) */
> +       CI_ISP_SI_REF_IMG_UNKNOWN = 0,
> +       /* SI reference image from sensor */
> +       CI_ISP_SI_REF_IMG_SENSOR = 1,
> +       /* SI reference image from memory */
> +       CI_ISP_SI_REF_IMG_MEMORY = 2
> +};
> +
> +/* super impose configuration struct */
> +struct ci_isp_si_config {
> +       /* transparency mode on/off */
> +       enum ci_isp_si_trans_mode trans_mode;
> +       /* reference image from sensor/memory */
> +       enum ci_isp_si_ref_image ref_image;
> +       /* x offset (coordinate system of the reference image) */
> +       u16 offs_x;
> +       /* y offset (coordinate system of the reference image) */
> +       u16 offs_y;
> +       /* Y component of transparent key color */
> +       u8 trans_comp_y;
> +       /* Cb component of transparent key color */
> +       u8 trans_comp_cb;
> +       /* Cr component of transparent key color */
> +       u8 trans_comp_cr;
> +};
> +
> +/* image stabilisation modes */
> +enum ci_isp_is_mode {
> +       /* IS  mode is unknown (module is switched off) */
> +       CI_ISP_IS_MODE_UNKNOWN = 0,
> +       /* IS  mode enabled */
> +       CI_ISP_IS_MODE_ON = 1,
> +       /* IS  mode disabled */
> +       CI_ISP_IS_MODE_OFF = 2
> +};
> +
> +/* image stabilisation configuration struct */
> +struct ci_isp_is_config {
> +       /* position and size of image stabilisation window */
> +       struct ci_isp_window mrv_is_window;
> +       /* maximal margin distance for X */
> +       u16 max_dx;
> +       /* maximal margin distance for Y */
> +       u16 max_dy;
> +};
> +
> +/* image stabilisation control struct */
> +struct ci_isp_is_ctrl {
> +       /* image stabilisation mode on/off */
> +       enum ci_isp_is_mode is_mode;
> +       /* recenter every frame by ((cur_v_offsxV_OFFS)/(2^RECENTER)) */
> +       u8 recenter;
> +};
> +
> +/* for data path switching */
> +enum ci_isp_data_path {
> +       CI_ISP_PATH_RAW816,
> +       CI_ISP_PATH_RAW8,
> +       CI_ISP_PATH_JPE,
> +       CI_ISP_PATH_OFF,
> +       CI_ISP_PATH_ON
> +};
> +
> +/* buffer for memory interface */
> +struct ci_isp_bufferOld {
> +       u8 *pucbuffer;
> +       u32 size;
> +       u32 offs;
> +       /* not used for Cb and Cr buffers, IRQ offset for */
> +       u32 irq_offs_llength;
> +       /* stores the malloc pointer address */
> +       u8 *pucmalloc_start;
> +       /* main buffer and line length for self buffer */
> +};
> +
> +/* buffer for DMA memory interface */
> +struct ci_isp_dma_buffer {
> +       /*
> +        * start of the buffer memory. Note that panning in an larger picture
> +        * memory is possible by altering the buffer start address (and
> +        * choosing pic_width  llength)
> +        */
> +       u8 *pucbuffer;
> +       /* size of the entire picture in bytes */
> +       u32 pic_size;
> +       /*
> +        * width of the picture area of interest (not necessaryly the entire
> +        * picture)
> +        */
> +       u32 pic_width;
> +       /* inter-line-increment. This is the amount of bytes between */
> +       u32 llength;
> +       /* pixels in the same column but on different lines. */
> +
> +};
> +
> +/* color format for self picture input/output and DMA input */
> +enum ci_isp_mif_col_format {
> +       /* YCbCr 4:2:2 format */
> +       CI_ISP_MIF_COL_FORMAT_YCBCR_422 = 0,
> +       /* YCbCr 4:4:4 format */
> +       CI_ISP_MIF_COL_FORMAT_YCBCR_444 = 1,
> +       /* YCbCr 4:2:0 format */
> +       CI_ISP_MIF_COL_FORMAT_YCBCR_420 = 2,
> +       /* YCbCr 4:0:0 format */
> +       CI_ISP_MIF_COL_FORMAT_YCBCR_400 = 3,
> +       /* RGB   565   format */
> +       CI_ISP_MIF_COL_FORMAT_RGB_565 = 4,
> +       /* RGB   666   format */
> +       CI_ISP_MIF_COL_FORMAT_RGB_666 = 5,
> +       /* RGB   888   format */
> +       CI_ISP_MIF_COL_FORMAT_RGB_888 = 6
> +};
> +
> +/* color range for self picture input of RGB m*/
> +enum teMrvMifColRange {
> +    mrv_mif_col_Range_Std  = 0,
> +    mrv_mif_col_Range_Full = 1
> +};
> +
> +/* color phase for self picture input of RGB */
> +enum teMrvMifColPhase {
> +    mrv_mif_col_Phase_Cosited     = 0,
> +    mrv_mif_col_Phase_Non_Cosited = 1
> +};
> +
> +/*
> + * picture write/read format
> + * The following examples apply to YCbCr 4:2:2 images, as all modes
> + */
> + enum ci_isp_mif_pic_form {
> +       /* planar     : separated buffers for Y, Cb and Cr */
> +       CI_ISP_MIF_PIC_FORM_PLANAR = 0,
> +       /* semi-planar: one buffer for Y and a combined buffer for Cb and Cr */
> +       CI_ISP_MIF_PIC_FORM_SEMI_PLANAR = 1,
> +       /* interleaved: one buffer for all  */
> +       CI_ISP_MIF_PIC_FORM_INTERLEAVED = 2
> +};
> +
> +/* self picture operating modes */
> +enum ci_isp_mif_sp_mode {
> +       /* no rotation, no horizontal or vertical flipping */
> +       CI_ISP_MIF_SP_ORIGINAL = 0,
> +       /* vertical   flipping (no additional rotation) */
> +       CI_ISP_MIF_SP_VERTICAL_FLIP = 1,
> +       /* horizontal flipping (no additional rotation) */
> +       CI_ISP_MIF_SP_HORIZONTAL_FLIP = 2,
> +       /* rotation  90 degrees ccw (no additional flipping) */
> +       CI_ISP_MIF_SP_ROTATION_090_DEG = 3,
> +       /*
> +        * rotation 180 degrees ccw (equal to horizontal plus vertical
> +        * flipping)
> +        */
> +       CI_ISP_MIF_SP_ROTATION_180_DEG = 4,
> +       /* rotation 270 degrees ccw (no additional flipping) */
> +       CI_ISP_MIF_SP_ROTATION_270_DEG = 5,
> +       /* rotation  90 degrees ccw plus vertical flipping */
> +       CI_ISP_MIF_SP_ROT_090_V_FLIP = 6,
> +       /* rotation 270 degrees ccw plus vertical flipping */
> +       CI_ISP_MIF_SP_ROT_270_V_FLIP = 7
> +};
> +
> +/* MI burst length settings */
> +enum ci_isp_mif_burst_length {
> +       /* burst length = 4 */
> +       CI_ISP_MIF_BURST_LENGTH_4 = 0,
> +       /* burst length = 8 */
> +       CI_ISP_MIF_BURST_LENGTH_8 = 1,
> +       /* burst length = 16 */
> +       CI_ISP_MIF_BURST_LENGTH_16 = 2
> +};
> +
> +
> +/* MI apply initial values settings */
> +enum ci_isp_mif_init_vals {
> +       /* do not set initial values */
> +       CI_ISP_MIF_NO_INIT_VALS = 0,
> +       /* set initial values for offset registers */
> +       CI_ISP_MIF_INIT_OFFS = 1,
> +       /* set initial values for base address registers */
> +       CI_ISP_MIF_INIT_BASE = 2,
> +       /* set initial values for offset and base address registers */
> +       CI_ISP_MIF_INIT_OFFSAndBase = 3
> +};
> +
> +/* MI when to update configuration */
> +enum ci_isp_conf_update_time {
> +       CI_ISP_CFG_UPDATE_FRAME_SYNC = 0,
> +       CI_ISP_CFG_UPDATE_IMMEDIATE = 1,
> +       CI_ISP_CFG_UPDATE_LATER = 2
> +};
> +
> +/* control register of the MI */
> +struct ci_isp_mi_ctrl {
> +       /* self picture path output format */
> +       enum ci_isp_mif_col_format mrv_mif_sp_out_form;
> +       /* self picture path input format */
> +       enum ci_isp_mif_col_format mrv_mif_sp_in_form;
> +       enum teMrvMifColRange mrv_mif_spInRange;
> +       enum teMrvMifColPhase mrv_mif_spInPhase;
> +       /* self picture path write format */
> +       enum ci_isp_mif_pic_form mrv_mif_sp_pic_form;
> +       /* main picture path write format */
> +       enum ci_isp_mif_pic_form mrv_mif_mp_pic_form;
> +       /* burst length for chrominance for write port */
> +       enum ci_isp_mif_burst_length burst_length_chrom;
> +       /* burst length for luminance for write port */
> +       enum ci_isp_mif_burst_length burst_length_lum;
> +       /* enable updating of the shadow registers */
> +       enum ci_isp_mif_init_vals init_vals;
> +       /*
> +        * for main and self picture to their init      values
> +        */
> +       /* enable change of byte order for write port */
> +       int byte_swap_enable;
> +       /* enable the last pixel signalization */
> +       int last_pixel_enable;
> +       /* self picture path operating mode */
> +       enum ci_isp_mif_sp_mode mrv_mif_sp_mode;
> +       /* enable path */
> +       enum ci_isp_data_path main_path;
> +       /* enable path */
> +       enum ci_isp_data_path self_path;
> +       /*
> +        * offset counter interrupt generation for fill_mp_y (counted in
> +        * bytes)
> +        */
> +       u32 irq_offs_init;
> +
> +};
> +
> +/* buffer for memory interface */
> +struct ci_isp_buffer {
> +       /* buffer start address */
> +       u8 *pucbuffer;
> +       /* buffer size (counted in bytes) */
> +       u32 size;
> +       /* buffer offset count (counted in bytes) */
> +       u32 offs;
> +};
> +
> +/* main or self picture path, or DMA configuration */
> +struct ci_isp_mi_path_conf {
> +       /* Y  picture width  (counted in pixels) */
> +       u32 ypic_width;
> +       /* Y  picture height (counted in pixels) */
> +       u32 ypic_height;
> +       /*
> +        * line length means the distance from one pixel to the vertically
> +        * next
> +        */
> +       u32 llength;
> +       /*
> +        * pixel below including the not-used blanking area, etc.
> +        * (counted in pixels)
> +        */
> +       /* Y  buffer structure */
> +       struct ci_isp_buffer ybuffer;
> +       /* Cb buffer structure */
> +       struct ci_isp_buffer cb_buffer;
> +       /* Cr buffer structure */
> +       struct ci_isp_buffer cr_buffer;
> +};
> +
> +/* DMA configuration */
> +struct ci_isp_mi_dma_conf {
> +       /* start DMA immediately after configuration */
> +       int start_dma;
> +       /* suppress v_end so that no frame end can be */
> +       int frame_end_disable;
> +       /*
> +        * detected by the following instances
> +        * enable change of byte order for read port
> +        */
> +       int byte_swap_enable;
> +       /*
> +        * Enables continuous mode. If set the same frame is read back
> +        * over and over. A start pulse on dma_start is need only for the
> +        * first time. To stop continuous mode reset this bit (takes
> +        * effect after the next frame end) or execute a soft reset.
> +        */
> +       int continuous_enable;
> +       /* DMA input color format */
> +       enum ci_isp_mif_col_format mrv_mif_col_format;
> +       /* DMA read buffer format */
> +       enum ci_isp_mif_pic_form mrv_mif_pic_form;
> +       /* burst length for chrominance for read port */
> +       enum ci_isp_mif_burst_length burst_length_chrom;
> +       /* burst length for luminance for read port */
> +       enum ci_isp_mif_burst_length burst_length_lum;
> +       /*
> +        * Set this to TRUE if the DMA-read data is routed through
> +        * the path that is normally used for the live camera
> +        * data (e.g. through the image effects module).
> +        */
> +       int via_cam_path;
> +};
> +
> +/* Public CAC Defines and Typedefs */
> +
> +/*
> + * configuration of chromatic aberration correction block (given to the
> + * CAC driver)
> + */
> +struct ci_isp_cac_config {
> +       /* size of the input image in pixels */
> +       u16 hsize;
> +       u16 vsize;
> +       /* offset between image center and optical */
> +       s16 hcenter_offset;
> +       /* center of the input image in pixels */
> +       s16 vcenter_offset;
> +       /* maximum red/blue pixel shift in horizontal */
> +       u8 hclip_mode;
> +       /* and vertival direction, range 0..2 */
> +       u8 vclip_mode;
> +       /* parameters for radial shift calculation, */
> +       u16 ablue;
> +       /* 9 bit twos complement with 4 fractional */
> +       u16 ared;
> +       /* digits, valid range -16..15.9375 */
> +       u16 bblue;
> +       u16 bred;
> +       u16 cblue;
> +       u16 cred;
> +       /* 0 = square pixel sensor, all other = aspect */
> +       float aspect_ratio;
> +       /* ratio of non-square pixel sensor */
> +
> +};
> +
> +/*
> + * register values of chromatic aberration correction block (delivered by
> + * the CAC driver)
> + */
> +struct ci_isp_cac_reg_values {
> +       /* maximum red/blue pixel shift in horizontal */
> +       u8 hclip_mode;
> +       /* and vertival direction, range 0..2 */
> +       u8 vclip_mode;
> +       /* TRUE=enabled, FALSE=disabled */
> +       int cac_enabled;
> +       /*
> +        * preload value of the horizontal CAC pixel
> +        * counter, range 1..4095
> +        */
> +       u16 hcount_start;
> +       /*
> +        * preload value of the vertical CAC pixel
> +        * counter, range 1..4095
> +        */
> +       u16 vcount_start;
> +       /* parameters for radial shift calculation, */
> +       u16 ablue;
> +       /* 9 bit twos complement with 4 fractional */
> +       u16 ared;
> +       /* digits, valid range -16..15.9375 */
> +       u16 bblue;
> +       u16 bred;
> +       u16 cblue;
> +       u16 cred;
> +       /* horizontal normalization shift, range 0..7 */
> +       u8 xnorm_shift;
> +       /* horizontal normalization factor, range 16..31 */
> +       u8 xnorm_factor;
> +       /* vertical normalization shift, range 0..7 */
> +       u8 ynorm_shift;
> +       /* vertical normalization factor, range 16..31 */
> +       u8 ynorm_factor;
> +};
> +
> +struct ci_snapshot_config {
> +       /*  snapshot flags */
> +       u32 flags;
> +       /*  user zoom factor to use ( Zoomfactor = 1 + (<value>*1024) ) */
> +       int user_zoom;
> +       /*  user width (in pixel) */
> +       int user_w;
> +       /*  user height (in pixel) */
> +       int user_h;
> +       /*  compression ratio for JPEG snapshots */
> +       u8 compression_ratio;
> +};
> +
> +struct ci_isp_view_finder_config {
> +       /*  how to display the viewfinder */
> +       u32 flags;
> +       /*  zoom factor to use ( Zoomfactor = 1 + (<value>*1024) ) */
> +       int zoom;
> +       /*  contrast setting for LCD */
> +       int lcd_contrast;
> +       /*  following settings are only used in VFFLAG_MODE_USER mode */
> +
> +       /*  start pixel of upper left corner on LCD */
> +       int x;
> +       /*  start pixel of upper left corner on LCD */
> +       int y;
> +       /*  width (in pixel) */
> +       int w;
> +       /*  height (in pixel) */
> +       int h;
> +       /*  keeps the aspect ratio by cropping the input to match the output
> +        * aspect ratio. */
> +       int keep_aspect;
> +};
> +
> +/* ! Number of supported DIP-Switches */
> +#define FF_DIPSWITCH_COUNT    10
> +
> +
> +#define CI_ISP_HIST_DATA_BIN_ARR_SIZE 16
> +
> +struct ci_isp_hist_data_bin {
> +       u8 hist_bin[CI_ISP_HIST_DATA_BIN_ARR_SIZE];
> +};
> +
> +#define MRV_MEAN_LUMA_ARR_SIZE_COL 5
> +#define MRV_MEAN_LUMA_ARR_SIZE_ROW 5
> +#define MRV_MEAN_LUMA_ARR_SIZE     \
> +       (MRV_MEAN_LUMA_ARR_SIZE_COL*MRV_MEAN_LUMA_ARR_SIZE_ROW)
> +
> +/* Structure contains a 2-dim 5x5 array
> + * for mean luminance values from 5x5 MARVIN measurement grid.
> + */
> +struct ci_isp_mean_luma {
> +    u8 mean_luma_block[MRV_MEAN_LUMA_ARR_SIZE_COL][MRV_MEAN_LUMA_ARR_SIZE_ROW];
> +};
> +
> +/* Structure contains bits autostop and exp_meas_mode of isp_exp_ctrl */
> +struct ci_isp_exp_ctrl {
> +    int auto_stop;
> +    int exp_meas_mode;
> +    int exp_start;
> +} ;
> +
> +
> +struct ci_isp_cfg_flags {
> +       /*
> +        * following flag tripels controls the behaviour of the associated
> +        * marvin control loops.
> +        * For feature XXX, the 3 flags are totally independant and
> +        * have the following meaning:
> +        * fXXX:
> +        * If set, there is any kind of software interaction during runtime
> +        * thatmay lead to a modification of the feature-dependant settings.
> +        * For each frame, a feature specific loop control routine is called
> +        * may perform other actions based on feature specific configuration.
> +        * If not set, only base settings will be applied during setup, or the
> +        * reset values are left unchanged. No control routine will be called
> +        * inside the processing loop.
> +        * fXXXprint:
> +        * If set, some status informations will be printed out inside
> +        * the processing loop.  Status printing is independant of the
> +        * other flags regarding this feature.
> +        * fXXX_dis:
> +        * If set, the feature dependant submodule of the marvin is
> +        * disabled or is turned into bypass mode. Note that it is
> +        * still possible to set one or more of the other flags too,
> +        * but this wouldn't make much sense...
> +        * lens shading correction
> +        */
> +
> +       unsigned int lsc:1;
> +       unsigned int lscprint:1;
> +       unsigned int lsc_dis:1;
> +
> +       /*  bad pixel correction */
> +
> +       unsigned int bpc:1;
> +       unsigned int bpcprint:1;
> +       unsigned int bpc_dis:1;
> +
> +       /*  black level correction */
> +
> +       unsigned int bls:1;
> +       /*  only fixed values */
> +       unsigned int bls_man:1;
> +       /*  fixed value read from smia interface */
> +       unsigned int bls_smia:1;
> +       unsigned int blsprint:1;
> +       unsigned int bls_dis:1;
> +
> +       /*  (automatic) white balancing
> +        * (if automatic or manual can be configured elsewhere) */
> +
> +       unsigned int awb:1;
> +       unsigned int awbprint:1;
> +       unsigned int awbprint2:1;
> +       unsigned int awb_dis:1;
> +
> +       /*  automatic exposure (and gain) control */
> +
> +       unsigned int aec:1;
> +       unsigned int aecprint:1;
> +       unsigned int aec_dis:1;
> +       unsigned int aec_sceval:1;
> +
> +       /*  auto focus */
> +
> +       unsigned int af:1;
> +       unsigned int afprint:1;
> +       unsigned int af_dis:1;
> +
> +       /*  enable flags for various other components of the marvin */
> +
> +       /*  color processing (brightness, contrast, saturation, hue) */
> +       unsigned int cp:1;
> +       /*  input gamma block */
> +       unsigned int gamma:1;
> +       /*  color conversion matrix */
> +       unsigned int cconv:1;
> +       /*  demosaicing */
> +       unsigned int demosaic:1;
> +       /*  output gamma block */
> +       unsigned int gamma2:1;
> +       /*  Isp de-noise and sharpenize filters */
> +       unsigned int isp_filters:1;
> +       /*  Isp CAC */
> +       unsigned int cac:1;
> +
> +       /*  demo stuff */
> +
> +       /*  demo: saturation loop enable */
> +       unsigned int cp_sat_loop:1;
> +       /*  demo: contrast loop enable */
> +       unsigned int cp_contr_loop:1;
> +       /*  demo: brightness loop enable */
> +       unsigned int cp_bright_loop:1;
> +       /*  demo: scaler loop enable */
> +       unsigned int scaler_loop:1;
> +       /*  demo: use standard color conversion matrix */
> +       unsigned int cconv_basic:1;
> +
> +       /*  demo: use joystick to cycle through the image effect modes */
> +       unsigned int cycle_ie_mode:1;
> +
> +       /*  others */
> +
> +       /*  enable continous autofocus */
> +       unsigned int continous_af:1;
> +
> +       unsigned int bad_pixel_generation:1;
> +       /* enable YCbCr full range */
> +       unsigned int fYCbCrFullRange:1;
> +       /* enable YCbCr color phase non cosited */
> +       unsigned int fYCbCrNonCosited:1;
> +
> +};
> +
> +struct ci_isp_config {
> +       struct ci_isp_cfg_flags flags;
> +       struct ci_sensor_ls_corr_config lsc_cfg;
> +       struct ci_isp_bp_corr_config bpc_cfg;
> +       struct ci_isp_bp_det_config bpd_cfg;
> +       struct ci_isp_wb_config wb_config;
> +       struct ci_isp_cac_config cac_config;
> +       struct ci_isp_aec_config aec_cfg;
> +       struct ci_isp_window aec_v2_wnd;
> +       struct ci_isp_bls_config bls_cfg;
> +       struct ci_isp_af_config af_cfg;
> +       struct ci_isp_color_settings color;
> +       struct ci_isp_ie_config img_eff_cfg;
> +       enum ci_isp_demosaic_mode demosaic_mode;
> +       u8 demosaic_th;
> +       u8 exposure;
> +       enum ci_isp_aec_mode advanced_aec_mode;
> +       /*  what to include in reports; */
> +       u32 report_details;
> +       /*  an or'ed combination of the FF_REPORT_xxx defines */
> +       struct ci_isp_view_finder_config view_finder;
> +       /*  primary snapshot */
> +       struct ci_snapshot_config snapshot_a;
> +       /*  secondary snapshot */
> +       struct ci_snapshot_config snapshot_b;
> +       /*  auto focus measurement mode */
> +       enum ci_isp_afm_mode afm_mode;
> +       /*  auto focus search strategy mode */
> +       enum ci_isp_afss_mode afss_mode;
> +       int wb_get_gains_from_sensor_driver;
> +       u8 filter_level_noise_reduc;
> +       u8 filter_level_sharp;
> +       u8 jpeg_enc_ratio;
> +};
> +
> +struct ci_pl_system_config {
> +       struct ci_sensor_config *isi_config;
> +       struct ci_sensor_caps *isi_caps;
> +       struct ci_sensor_awb_profile *sensor_awb_profile;
> +       struct ci_isp_config *isp_cfg;
> +       u32 focus_max;
> +       unsigned int isp_hal_enable;
> +};
> +
> +/* intel private ioctl code for ci isp hal interface */
> +#define BASE BASE_VIDIOC_PRIVATE
> +
> +#define VIDIOC_SET_SYS_CFG _IOWR('V', BASE + 1, struct ci_pl_system_config)
> +#define VIDIOC_SET_JPG_ENC_RATIO _IOWR('V', BASE + 2, int)
> +
> +#include "ci_va.h"
> +
> +/* support camera flash on CDK */
> +struct ci_isp_flash_cmd {
> +       int preflash_on;
> +       int flash_on;
> +       int prelight_on;
> +};
> +
> +struct ci_isp_flash_config {
> +       int prelight_off_at_end_of_flash;
> +       int vsync_edge_positive;
> +       int output_polarity_low_active;
> +       int use_external_trigger;
> +       u8 capture_delay;
> +};
> +
> +#endif

Even without reading the other patches, I'm risking to say that it seems that
you're reinventing the wheel, creating another abstraction layer.

In the past, we had several different solutions for it. We're now integrating
everything into v4l2 dev/subdev interface. Please convert your driver to use
it, instead of creating yet another KABI interface.

> diff --git a/drivers/media/video/mrstci/include/ci_isp_fmts.h b/drivers/media/video/mrstci/include/ci_isp_fmts.h
> new file mode 100644
> index 0000000..a789b57
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_isp_fmts.h
> @@ -0,0 +1,46 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
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
> +#ifndef _CI_ISP_FMTS_H
> +#define _CI_ISP_FMTS_H
> +
> +#include "videodev2.h"
> +#include "ci_isp_fmts_common.h"
> +
> +/* 16 RGB-5-6-5 */
> +#define INTEL_PIX_FMT_RGB565 intel_fourcc('R', 'G', 'B', 'P')
> +/* 24 RGB-8-8-8 */
> +#define INTEL_PIX_FMT_BGR32 intel_fourcc('B', 'G', 'R', '4')
> +/* 16 YUV 4:2:2 */
> +#define INTEL_PIX_FMT_YUYV intel_fourcc('Y', 'U', 'Y', 'V')
> +/* 16  YVU422 planar */
> +#define INTEL_PIX_FMT_YUV422P intel_fourcc('4', '2', '2', 'P')
> +/* 12 YUV/YVU 4:2:0 */
> +#define INTEL_PIX_FMT_YUV420 intel_fourcc('Y', 'U', '1', '2')
> +#define INTEL_PIX_FMT_YVU420 intel_fourcc('Y', 'V', '1', '2')
> +/* 12 Y/CbCr 4:2:0 */
> +#define INTEL_PIX_FMT_NV12 intel_fourcc('N', 'V', '1', '2')
> +/* JFIF JPEG */
> +#define INTEL_PIX_FMT_JPEG intel_fourcc('J', 'P', 'E', 'G')
> +
> +#endif

If you need some new types, please add it at videodev2.h, and patch v4l2 api to
add the newer formats.

The api is at our mercurial tree. So, it is better to base your patch against
it, and send your first patch with just the public API changes.

Also, we already have defined several of the above fourcc codes. Why we need to
add other formats? If they're different, then you'll need to use a different
fourcc code.

I suspect, however, that maybe you're just creating a new alias. Or do you
really have, for example, an Intel's proprietary Jpeg format that it is
different from the standard one?


> diff --git a/drivers/media/video/mrstci/include/ci_isp_fmts_common.h b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
> new file mode 100644
> index 0000000..47794c0
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
> @@ -0,0 +1,128 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
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
> +#ifndef _ISP_FMTS_COMMON_H
> +#define _ISP_FMTS_COMMON_H
> +
> +#define intel_fourcc(d, c, b, a) \
> +       (((__u32)(d)<<0)|((__u32)(c)<<8)|((__u32)(b)<<16)|((__u32)(a)<<24))
> +
> +/* more bayer pattern formats support by ISP */
> +
> +/* RAW 8-bit */
> +#define INTEL_PIX_FMT_RAW08  intel_fourcc('R', 'W', '0', '8')
> +/* RAW 10-bit */
> +#define INTEL_PIX_FMT_RAW10 intel_fourcc('R', 'W', '1', '0')
> +/* RAW 12-bit */
> +#define INTEL_PIX_FMT_RAW12  intel_fourcc('R', 'W', '1', '2')

The same comments apply here: if you need to add a new format, please add it at
videodev2.h. and at V4L2 API. Also, use an unique fourcc code.

> +
> +
> +/*
> + * various config and info structs concentrated into one struct
> + * for simplification
> + */
> +#define FORMAT_FLAGS_DITHER       0x01
> +#define FORMAT_FLAGS_PACKED       0x02
> +#define FORMAT_FLAGS_PLANAR       0x04
> +#define FORMAT_FLAGS_RAW          0x08
> +#define FORMAT_FLAGS_CrCb         0x10
> +
> +struct intel_fmt {
> +       char *name;
> +       unsigned long fourcc;           /* v4l2 format id */
> +       int depth;
> +       int flags;
> +};
> +
> +static struct intel_fmt fmts[] = {
> +       {
> +       .name = "565 bpp RGB",
> +       .fourcc = V4L2_PIX_FMT_RGB565,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PACKED,
> +       },
> +       {
> +       .name = "888 bpp BGR",
> +       .fourcc = V4L2_PIX_FMT_BGR32,
> +       .depth = 32,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:2, packed, YUYV",
> +       .fourcc = V4L2_PIX_FMT_YUYV,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PACKED,
> +       },
> +       {
> +       .name = "4:2:2 planar, YUV422P",
> +       .fourcc = V4L2_PIX_FMT_YUV422P,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 planar, YUV420",
> +       .fourcc = V4L2_PIX_FMT_YUV420,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 planar, YVU420",
> +       .fourcc = V4L2_PIX_FMT_YVU420,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 semi planar, NV12",
> +       .fourcc = V4L2_PIX_FMT_NV12,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "Compressed format, JPEG",
> +       .fourcc = V4L2_PIX_FMT_JPEG,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW08,
> +       .depth = 8,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW10,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW12,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },
> +};
> +
> +static int NUM_FORMATS = sizeof(fmts) / sizeof(struct intel_fmt);
> +#endif /* _ISP_FMTS_H */
> +
> diff --git a/drivers/media/video/mrstci/include/ci_sensor_common.h b/drivers/media/video/mrstci/include/ci_sensor_common.h
> new file mode 100644
> index 0000000..61ec4b7
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_sensor_common.h
> @@ -0,0 +1,733 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
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
> +#include <linux/videodev2.h>
> +#ifndef _SENSOR_COMMON_H
> +#define _SENSOR_COMMON_H
> +
> +#define AEC_ALGO_V1    1
> +#define AEC_ALGO_V2    2
> +#define AEC_ALGO_V3    3
> +#define AEC_ALGO_V4    4
> +
> +#ifndef AEC_ALGO
> +#define AEC_ALGO       AEC_ALGO_V3 /*AEC_ALGO_V2*/
> +#endif
> +/*
> + * interface version
> + * please increment the version if you add something new to the interface.
> + * This helps upper layer software to deal with different interface versions.
> + */
> +#define SENSOR_INTERFACE_VERSION 4
> +#define SENSOR_TYPE_SOC        0
> +#define SENSOR_TYPE_RAW        1
> +/* Just for current use case */
> +#define SENSOR_TYPE_2M 0
> +#define SENSOR_TYPE_5M 1
> +
> +/*
> + * capabilities / configuration
> + */
> +
> +/* ulBusWidth; */
> +/*
> + * to expand to a (possibly higher) resolution in marvin, the LSBs will be set
> + * to zero
> + */
> +#define SENSOR_BUSWIDTH_8BIT_ZZ    0x00000001
> +/*
> + * to expand to a (possibly higher) resolution in marvin, the LSBs will be
> + * copied from the MSBs
> + */
> +#define SENSOR_BUSWIDTH_8BIT_EX    0x00000002
> +/*
> + * formerly known as SENSOR_BUSWIDTH_10BIT (at times no marvin derivative was
> + * able to process more than 10 bit)
> + */
> +#define SENSOR_BUSWIDTH_10BIT_EX   0x00000004
> +#define SENSOR_BUSWIDTH_10BIT_ZZ   0x00000008
> +#define SENSOR_BUSWIDTH_12BIT      0x00000010
> +
> +#define SENSOR_BUSWIDTH_10BIT      SENSOR_BUSWIDTH_10BIT_EX
> +
> +/*
> + * ulMode, operating mode of the image sensor in termns of output data format
> + * and
> + */
> +
> +/* timing data transmission */
> +
> +/* YUV-Data with separate h/v sync lines (ITU-R BT.601) */
> +#define SENSOR_MODE_BT601            0x00000001
> +/* YUV-Data with sync words inside the datastream (ITU-R BT.656) */
> +#define SENSOR_MODE_BT656            0x00000002
> +/* Bayer data with separate h/v sync lines */
> +#define SENSOR_MODE_BAYER            0x00000004
> +/*
> + * Any binary data without line/column-structure, (e.g. already JPEG encoded)
> + * h/v sync lines act as data valid signals
> + */
> +#define SENSOR_MODE_DATA             0x00000008
> +/* RAW picture data with separate h/v sync lines */
> +#define SENSOR_MODE_PICT             0x00000010
> +/* RGB565 data with separate h/v sync lines */
> +#define SENSOR_MODE_RGB565           0x00000020
> +/* SMIA conform data stream (see ulSmiaMode for details) */
> +#define SENSOR_MODE_SMIA             0x00000040
> +/* MIPI conform data stream (see ulMipiMode for details) */
> +#define SENSOR_MODE_MIPI             0x00000080
> +/*
> + * Bayer data with sync words inside the datastream (similar to ITU-R BT.656)
> + */
> +#define SENSOR_MODE_BAY_BT656        0x00000100
> +/*
> + * Raw picture data with sync words inside the datastream (similar to ITU-R
> + * BT.656)
> + */
> +#define SENSOR_MODE_RAW_BT656        0x00000200
> +
> +/* ulSmiaMode */
> +
> +/* compression mode */
> +#define SENSOR_SMIA_MODE_COMPRESSED           0x00000001
> +/* 8bit to 10 bit decompression */
> +#define SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP   0x00000002
> +/* 12 bit RAW Bayer Data */
> +#define SENSOR_SMIA_MODE_RAW_12               0x00000004
> +/* 10 bit RAW Bayer Data */
> +#define SENSOR_SMIA_MODE_RAW_10               0x00000008
> +/* 8 bit RAW Bayer Data */
> +#define SENSOR_SMIA_MODE_RAW_8                0x00000010
> +/* 7 bit RAW Bayer Data */
> +#define SENSOR_SMIA_MODE_RAW_7                0x00000020
> +/* 6 bit RAW Bayer Data */
> +#define SENSOR_SMIA_MODE_RAW_6                0x00000040
> +/* RGB 888 Display ready Data */
> +#define SENSOR_SMIA_MODE_RGB_888              0x00000080
> +/* RGB 565 Display ready Data */
> +#define SENSOR_SMIA_MODE_RGB_565              0x00000100
> +/* RGB 444 Display ready Data */
> +#define SENSOR_SMIA_MODE_RGB_444              0x00000200
> +/* YUV420 Data */
> +#define SENSOR_SMIA_MODE_YUV_420              0x00000400
> +/* YUV422 Data */
> +#define SENSOR_SMIA_MODE_YUV_422              0x00000800
> +/* SMIA is disabled */
> +#define SENSOR_SMIA_OFF                       0x80000000
> +
> +/* ulMipiMode */
> +
> +/* YUV 420  8-bit */
> +#define SENSOR_MIPI_MODE_YUV420_8             0x00000001
> +/* YUV 420 10-bit */
> +#define SENSOR_MIPI_MODE_YUV420_10            0x00000002
> +/* Legacy YUV 420 8-bit */
> +#define SENSOR_MIPI_MODE_LEGACY_YUV420_8      0x00000004
> +/* YUV 420 8-bit (CSPS) */
> +#define SENSOR_MIPI_MODE_YUV420_CSPS_8        0x00000008
> +/* YUV 420 10-bit (CSPS) */
> +#define SENSOR_MIPI_MODE_YUV420_CSPS_10       0x00000010
> +/* YUV 422 8-bit */
> +#define SENSOR_MIPI_MODE_YUV422_8             0x00000020
> +/* YUV 422 10-bit */
> +#define SENSOR_MIPI_MODE_YUV422_10            0x00000040
> +/* RGB 444 */
> +#define SENSOR_MIPI_MODE_RGB444               0x00000080
> +/* RGB 555 */
> +#define SENSOR_MIPI_MODE_RGB555               0x00000100
> +/* RGB 565 */
> +#define SENSOR_MIPI_MODE_RGB565               0x00000200
> +/* RGB 666 */
> +#define SENSOR_MIPI_MODE_RGB666               0x00000400
> +/* RGB 888 */
> +#define SENSOR_MIPI_MODE_RGB888               0x00000800
> +/* RAW_6 */
> +#define SENSOR_MIPI_MODE_RAW_6                0x00001000
> +/* RAW_7 */
> +#define SENSOR_MIPI_MODE_RAW_7                0x00002000
> +/* RAW_8 */
> +#define SENSOR_MIPI_MODE_RAW_8                0x00004000
> +/* RAW_10 */
> +#define SENSOR_MIPI_MODE_RAW_10               0x00008000
> +/* RAW_12 */
> +#define SENSOR_MIPI_MODE_RAW_12               0x00010000
> +/* MIPI is disabled */
> +#define SENSOR_MIPI_OFF                       0x80000000
> +
> +/* ulFieldInv; */
> +
> +#define SENSOR_FIELDINV_NOSWAP     0x00000001
> +#define SENSOR_FIELDINV_SWAP       0x00000002
> +
> +/* ulFieldSel; */
> +#define SENSOR_FIELDSEL_BOTH       0x00000001
> +#define SENSOR_FIELDSEL_EVEN       0x00000002
> +#define SENSOR_FIELDSEL_ODD        0x00000004
> +
> +/* ulYCSeq; */
> +#define SENSOR_YCSEQ_YCBYCR        0x00000001
> +#define SENSOR_YCSEQ_YCRYCB        0x00000002
> +#define SENSOR_YCSEQ_CBYCRY        0x00000004
> +#define SENSOR_YCSEQ_CRYCBY        0x00000008
> +
> +/* ulConv422; */
> +#define SENSOR_CONV422_COSITED     0x00000001
> +#define SENSOR_CONV422_INTER       0x00000002
> +#define SENSOR_CONV422_NOCOSITED   0x00000004
> +
> +/* ulBPat; */
> +
> +#define SENSOR_BPAT_RGRGGBGB       0x00000001
> +#define SENSOR_BPAT_GRGRBGBG       0x00000002
> +#define SENSOR_BPAT_GBGBRGRG       0x00000004
> +#define SENSOR_BPAT_BGBGGRGR       0x00000008
> +
> +/* ulHPol; */
> +
> +/* sync signal pulses high between lines */
> +#define SENSOR_HPOL_SYNCPOS        0x00000001
> +/* sync signal pulses low between lines */
> +#define SENSOR_HPOL_SYNCNEG        0x00000002
> +/* reference signal is high as long as sensor puts out line data */
> +#define SENSOR_HPOL_REFPOS         0x00000004
> +/* reference signal is low as long as sensor puts out line data */
> +#define SENSOR_HPOL_REFNEG         0x00000008
> +
> +/* ulVPol; */
> +#define SENSOR_VPOL_POS            0x00000001
> +#define SENSOR_VPOL_NEG            0x00000002
> +
> +/* ulEdge; */
> +#define SENSOR_EDGE_RISING         0x00000001
> +#define SENSOR_EDGE_FALLING        0x00000002
> +
> +/* ulBls; */
> +/* turns on/off additional black lines at frame start */
> +#define SENSOR_BLS_OFF             0x00000001
> +#define SENSOR_BLS_TWO_LINES       0x00000002
> +/* two lines top and two lines bottom */
> +#define SENSOR_BLS_FOUR_LINES      0x00000004
> +
> +/* ulGamma; */
> +/* turns on/off gamma correction in the sensor ISP */
> +#define SENSOR_GAMMA_ON            0x00000001
> +#define SENSOR_GAMMA_OFF           0x00000002
> +
> +/* ulCConv; */
> +/* turns on/off color conversion matrix in the sensor ISP */
> +#define SENSOR_CCONV_ON            0x00000001
> +#define SENSOR_CCONV_OFF           0x00000002
> +
> +/* ulRes; */
> +/* 88x72 */
> +#define SENSOR_RES_QQCIF           0x00000001
> +/* 160x120 */
> +#define SENSOR_RES_QQVGA           0x00000002
> +/* 176x144 */
> +#define SENSOR_RES_QCIF            0x00000004
> +/* 320x240 */
> +#define SENSOR_RES_QVGA            0x00000008
> +/* 352x288 */
> +#define SENSOR_RES_CIF             0x00000010
> +/* 640x480 */
> +#define SENSOR_RES_VGA             0x00000020
> +/* 800x600 */
> +#define SENSOR_RES_SVGA            0x00000040
> +/* 1024x768 */
> +#define SENSOR_RES_XGA             0x00000080
> +/* 1280x960 max. resolution of OV9640 (QuadVGA) */
> +#define SENSOR_RES_XGA_PLUS        0x00000100
> +/* 1280x1024 */
> +#define SENSOR_RES_SXGA            0x00000200
> +/* 1600x1200 */
> +#define SENSOR_RES_UXGA            0x00000400
> +/* 2048x1536 */
> +#define SENSOR_RES_QXGA            0x00000800
> +#define SENSOR_RES_QXGA_PLUS       0x00001000
> +#define SENSOR_RES_RAWMAX          0x00002000
> +/* 4080x1024 */
> +#define SENSOR_RES_YUV_HMAX        0x00004000
> +/* 1024x4080 */
> +#define SENSOR_RES_YUV_VMAX        0x00008000
> +/* 720x480 */
> +#define SENSOR_RES_L_AFM           0x00020000
> +/* 128x96 */
> +#define SENSOR_RES_M_AFM           0x00040000
> +/* 64x32 */
> +#define SENSOR_RES_S_AFM           0x00080000
> +/* 352x240 */
> +#define SENSOR_RES_BP1             0x00100000
> +/* 2586x2048, quadruple SXGA, 5,3 Mpix */
> +#define SENSOR_RES_QSXGA           0x00200000
> +/* 2600x2048, max. resolution of M5, 5,32 Mpix */
> +#define SENSOR_RES_QSXGA_PLUS      0x00400000
> +/* 2600x1950 */
> +#define SENSOR_RES_QSXGA_PLUS2     0x00800000
> +/* 2686x2048,  5.30M */
> +#define SENSOR_RES_QSXGA_PLUS3     0x01000000
> +/* 3200x2048,  6.56M */
> +#define SENSOR_RES_WQSXGA          0x02000000
> +/* 3200x2400,  7.68M */
> +#define SENSOR_RES_QUXGA           0x04000000
> +/* 3840x2400,  9.22M */
> +#define SENSOR_RES_WQUXGA          0x08000000
> +/* 4096x3072, 12.59M */
> +#define SENSOR_RES_HXGA            0x10000000
> +
> +/* 2592x1044 replace with SENSOR_RES_QXGA_PLUS */
> +/*#define SENSOR_RES_QSXGA_PLUS4       0x10000000*/
> +/* 1920x1080 */
> +#define SENSOR_RES_1080P       0x20000000
> +/* 1280x720 */
> +#define SENSOR_RES_720P        0x40000000
> +#define QSXGA_PLUS4_SIZE_H     (2592)
> +#define QSXGA_PLUS4_SIZE_V     (1944)
> +#define RES_1080P_SIZE_H       (1920)
> +#define RES_1080P_SIZE_V       (1080)
> +#define RES_720P_SIZE_H        (1280)
> +#define RES_720P_SIZE_V        (720)
> +#define QQCIF_SIZE_H              (88)
> +#define QQCIF_SIZE_V              (72)
> +#define QQVGA_SIZE_H             (160)
> +#define QQVGA_SIZE_V             (120)
> +#define QCIF_SIZE_H              (176)
> +#define QCIF_SIZE_V              (144)
> +#define QVGA_SIZE_H              (320)
> +#define QVGA_SIZE_V              (240)
> +#define CIF_SIZE_H               (352)
> +#define CIF_SIZE_V               (288)
> +#define VGA_SIZE_H               (640)
> +#define VGA_SIZE_V               (480)
> +#define SVGA_SIZE_H              (800)
> +#define SVGA_SIZE_V              (600)
> +#define XGA_SIZE_H              (1024)
> +#define XGA_SIZE_V               (768)
> +#define XGA_PLUS_SIZE_H         (1280)
> +#define XGA_PLUS_SIZE_V          (960)
> +#define SXGA_SIZE_H             (1280)
> +#define SXGA_SIZE_V             (1024)
> +/* will be removed soon */
> +#define QSVGA_SIZE_H            (1600)
> +/* will be removed soon */
> +#define QSVGA_SIZE_V            (1200)
> +#define UXGA_SIZE_H             (1600)
> +#define UXGA_SIZE_V             (1200)
> +#define QXGA_SIZE_H             (2048)
> +#define QXGA_SIZE_V             (1536)
> +#define QXGA_PLUS_SIZE_H        (2592)
> +#define QXGA_PLUS_SIZE_V        (1944)
> +#define RAWMAX_SIZE_H           (4096)
> +#define RAWMAX_SIZE_V           (2048)
> +#define YUV_HMAX_SIZE_H         (4080)
> +#define YUV_HMAX_SIZE_V         (1024)
> +#define YUV_VMAX_SIZE_H         (1024)
> +#define YUV_VMAX_SIZE_V         (4080)
> +#define BP1_SIZE_H               (352)
> +#define BP1_SIZE_V               (240)
> +#define L_AFM_SIZE_H             (720)
> +#define L_AFM_SIZE_V             (480)
> +#define M_AFM_SIZE_H             (128)
> +#define M_AFM_SIZE_V              (96)
> +#define S_AFM_SIZE_H              (64)
> +#define S_AFM_SIZE_V              (32)
> +#define QSXGA_SIZE_H            (2560)
> +#define QSXGA_SIZE_V            (2048)
> +#define QSXGA_MINUS_SIZE_V      (1920)
> +#define QSXGA_PLUS_SIZE_H       (2600)
> +#define QSXGA_PLUS_SIZE_V       (2048)
> +#define QSXGA_PLUS2_SIZE_H      (2600)
> +#define QSXGA_PLUS2_SIZE_V      (1950)
> +#define QUXGA_SIZE_H            (3200)
> +#define QUXGA_SIZE_V            (2400)
> +#define SIZE_H_2500             (2500)
> +#define QSXGA_PLUS3_SIZE_H      (2686)
> +#define QSXGA_PLUS3_SIZE_V      (2048)
> +#define QSXGA_PLUS4_SIZE_V      (1944)
> +#define WQSXGA_SIZE_H           (3200)
> +#define WQSXGA_SIZE_V           (2048)
> +#define WQUXGA_SIZE_H           (3200)
> +#define WQUXGA_SIZE_V           (2400)
> +#define HXGA_SIZE_H             (4096)
> +#define HXGA_SIZE_V             (3072)
> +
> +/* ulBLC; */
> +#define SENSOR_DWNSZ_SUBSMPL       0x00000001
> +#define SENSOR_DWNSZ_SCAL_BAY      0x00000002
> +#define SENSOR_DWNSZ_SCAL_COS      0x00000004
> +
> +/* Camera BlackLevelCorrection on */
> +#define SENSOR_BLC_AUTO            0x00000001
> +/* Camera BlackLevelCorrection off */
> +#define SENSOR_BLC_OFF             0x00000002
> +
> +/* ulAGC; */
> +
> +/* Camera AutoGainControl on */
> +#define SENSOR_AGC_AUTO            0x00000001
> +/* Camera AutoGainControl off */
> +#define SENSOR_AGC_OFF             0x00000002
> +
> +/* ulAWB; */
> +
> +/* Camera AutoWhiteBalance on */
> +#define SENSOR_AWB_AUTO            0x00000001
> +/* Camera AutoWhiteBalance off */
> +#define SENSOR_AWB_OFF             0x00000002
> +
> +/* ulAEC; */
> +
> +/* Camera AutoExposureControl on */
> +#define SENSOR_AEC_AUTO            0x00000001
> +/* Camera AutoExposureControl off */
> +#define SENSOR_AEC_OFF             0x00000002
> +
> +/* ulCieProfile; */
> +#define ISI_AEC_MODE_STAND      0x00000001
> +#define ISI_AEC_MODE_SLOW       0x00000002
> +#define ISI_AEC_MODE_FAST       0x00000004
> +#define ISI_AEC_MODE_NORMAL     0x00000008
> +#define SENSOR_CIEPROF_A           0x00000001
> +#define SENSOR_CIEPROF_B           0x00000002
> +#define SENSOR_CIEPROF_C           0x00000004
> +#define SENSOR_CIEPROF_D50         0x00000008
> +#define SENSOR_CIEPROF_D55         0x00000010
> +#define SENSOR_CIEPROF_D65         0x00000020
> +#define SENSOR_CIEPROF_D75         0x00000040
> +#define SENSOR_CIEPROF_E           0x00000080
> +#define SENSOR_CIEPROF_F1          0x00010000
> +#define SENSOR_CIEPROF_F2          0x00020000
> +#define SENSOR_CIEPROF_F3          0x00040000
> +#define SENSOR_CIEPROF_F4          0x00080000
> +#define SENSOR_CIEPROF_F5          0x00100000
> +#define SENSOR_CIEPROF_F6          0x00200000
> +#define SENSOR_CIEPROF_F7          0x00400000
> +#define SENSOR_CIEPROF_F8          0x00800000
> +#define SENSOR_CIEPROF_F9          0x01000000
> +#define SENSOR_CIEPROF_F10         0x02000000
> +#define SENSOR_CIEPROF_F11         0x04000000
> +#define SENSOR_CIEPROF_F12         0x08000000
> +#define SENSOR_CIEPROF_OLDISS      0x80000000
> +#define SENSOR_CIEPROF_DEFAULT     0x00000000
> +
> +/* ulFlickerFreq */
> +
> +/* no compensation for flickering environmental illumination */
> +#define SENSOR_FLICKER_OFF         0x00000001
> +/* compensation for 100Hz flicker frequency (at 50Hz mains frequency) */
> +#define SENSOR_FLICKER_100         0x00000002
> +/* compensation for 120Hz flicker frequency (at 60Hz mains frequency) */
> +#define SENSOR_FLICKER_120         0x00000004
> +
> +/*
> + * sensor capabilities struct: a struct member may have 0, 1 or several bits
> + * set according to the capabilities of the sensor. All struct members must be
> + * unsigned int and no padding is allowed. Thus, access to the fields is also
> + * possible by means of a field of unsigned int values. Indicees for the
> + * field-like access are given below.
> + */
> +struct ci_sensor_caps{
> +       unsigned int bus_width;
> +       unsigned int mode;
> +       unsigned int field_inv;
> +       unsigned int field_sel;
> +       unsigned int ycseq;
> +       unsigned int conv422;
> +       unsigned int bpat;
> +       unsigned int hpol;
> +       unsigned int vpol;
> +       unsigned int edge;
> +       unsigned int bls;
> +       unsigned int gamma;
> +       unsigned int cconv;
> +       unsigned int res;
> +       unsigned int dwn_sz;
> +       unsigned int blc;
> +       unsigned int agc;
> +       unsigned int awb;
> +       unsigned int aec;
> +       /* extention SENSOR version 2 */
> +       unsigned int cie_profile;
> +       /* extention SENSOR version 3 */
> +       unsigned int flicker_freq;
> +
> +       /* extension SENSOR version 4 */
> +       unsigned int smia_mode;
> +       unsigned int mipi_mode;
> +       /* Add name here to load shared library */
> +       unsigned int type;
> +       char name[32];
> +};
> +
> +#define SENSOR_CAP_BUSWIDTH         0
> +#define SENSOR_CAP_MODE             1
> +#define SENSOR_CAP_FIELDINV         2
> +#define SENSOR_CAP_FIELDSEL         3
> +#define SENSOR_CAP_YCSEQ            4
> +#define SENSOR_CAP_CONV422          5
> +#define SENSOR_CAP_BPAT             6
> +#define SENSOR_CAP_HPOL             7
> +#define SENSOR_CAP_VPOL             8
> +#define SENSOR_CAP_EDGE             9
> +#define SENSOR_CAP_BLS             10
> +#define SENSOR_CAP_GAMMA           11
> +#define SENSOR_CAP_CCONF           12
> +#define SENSOR_CAP_RES             13
> +#define SENSOR_CAP_DWNSZ           14
> +#define SENSOR_CAP_BLC             15
> +#define SENSOR_CAP_AGC             16
> +#define SENSOR_CAP_AWB             17
> +#define SENSOR_CAP_AEC             18
> +#define SENSOR_CAP_CIEPROFILE      19
> +#define SENSOR_CAP_FLICKERFREQ     20
> +#define SENSOR_CAP_SMIAMODE        21
> +#define SENSOR_CAP_MIPIMODE        22
> +#define SENSOR_CAP_AECMODE         23
> +
> +
> +/* size of capabilities array (in number of unsigned int fields) */
> +#define SENSOR_CAP_COUNT           24
> +
> +/*
> + * Sensor configuration struct: same layout as the capabilities struct, but to
> + * configure the sensor all struct members which are supported by the sensor
> + * must have only 1 bit set. Members which are not supported by the sensor
> + * must not have any bits set.
> + */
> +#define ci_sensor_config       ci_sensor_caps
> +
> +/* single parameter support */
> +
> +/* exposure time */
> +#define SENSOR_PARM_EXPOSURE      0
> +/* index in the AE control table */
> +#define SENSOR_PARM_EXPTBL_INDEX  1
> +
> +/* gain */
> +/* overall gain (all components) */
> +#define SENSOR_PARM_GAIN          2
> +/* component gain of the red pixels */
> +#define SENSOR_PARM_CGAIN_R       3
> +/* component gain of the green pixels */
> +#define SENSOR_PARM_CGAIN_G       4
> +/* component gain of the blue pixels */
> +#define SENSOR_PARM_CGAIN_B       5
> +/*
> + * component gain of the green pixels sharing a bayer line with the red ones
> + */
> +#define SENSOR_PARM_CGAINB_GR     6
> +/*
> + * component gain of the green pixels sharing a bayer line with the blue ones
> + */
> +#define SENSOR_PARM_CGAINB_GB     7
> +
> +/* blacklevel */
> +
> +/* black-level adjustment (all components) */
> +#define SENSOR_PARM_BLKL          8
> +/* component black-level of the red pixels */
> +#define SENSOR_PARM_CBLKL_R       9
> +/* component black-level of the green pixels */
> +#define SENSOR_PARM_CBLKL_G      10
> +/* component black-level of the blue pixels */
> +#define SENSOR_PARM_CBLKL_B      11
> +/*
> + * component black-level of the green pixels sharing a bayer line with the red
> + * ones
> + */
> +#define SENSOR_PARM_CBLKLB_GR    12
> +/*
> + * component black-level of the green pixels sharing a bayer line with the
> + * blue ones
> + */
> +#define SENSOR_PARM_CBLKLB_GB    13
> +
> +/* resolution & cropping */
> +
> +/* base resolution in pixel (X) */
> +#define SENSOR_PARM_BASERES_X    14
> +/* base resolution in pixel (Y) */
> +#define SENSOR_PARM_BASERES_Y    15
> +/* window top-left pixel (X) */
> +#define SENSOR_PARM_WINDOW_X     16
> +/* window top-left pixel (Y) */
> +#define SENSOR_PARM_WINDOW_Y     17
> +/* window width in pixel */
> +#define SENSOR_PARM_WINDOW_W     18
> +/* window height in pixel */
> +#define SENSOR_PARM_WINDOW_H     19
> +
> +/* frame rate / clock */
> +
> +/*
> + * frame rate in frames per second, fixed point format, 16 bit fractional part
> + */
> +#define SENSOR_PARM_FRAMERATE_FPS    20
> +/* frame rate fine adjustment */
> +#define SENSOR_PARM_FRAMERATE_PITCH  21
> +/* clock divider setting */
> +#define SENSOR_PARM_CLK_DIVIDER      22
> +/* input clock in Hz. */
> +#define SENSOR_PARM_CLK_INPUT        23
> +/*
> + * output (pixel-) clock in Hz. Note that for e.g. YUV422-formats, 2 pixel
> + * clock cycles are needed per pixel
> + */
> +#define SENSOR_PARM_CLK_PIXEL        24
> +
> +/* number of parameter IDs */
> +
> +#define SENSOR_PARM__COUNT       25
> +
> +/* bit description of the result of the IsiParmInfo routine */
> +
> +/* parameter can be retrieved from the sensor */
> +#define SENSOR_PARMINFO_GET       0x00000001
> +/* parameter can be set into the sensor */
> +#define SENSOR_PARMINFO_SET       0x00000002
> +/* parameter can change at any time during operation */
> +#define SENSOR_PARMINFO_VOLATILE  0x00000004
> +/* range information available for the parameter in question */
> +#define SENSOR_PARMINFO_RANGE     0x00000008
> +/* range of possible values is not continous. */
> +#define SENSOR_PARMINFO_DISCRETE  0x00000010
> +/* parameter may change after a configuration update. */
> +#define SENSOR_PARMINFO_CONFIG    0x00000020
> +/* range information may change after a configuration update. */
> +#define SENSOR_PARMINFO_RCONFIG   0x00000040
> +
> +/* multi-camera support */
> +#define SENSOR_UNKNOWN_SENSOR_ID       (0)
> +
> +/* structure / type definitions */
> +/*
> + * Input gamma correction curve for R, G or B of the sensor.  Since this gamma
> + * curve is sensor specific, it will be deliveres by the sensors specific code.
> + * This curve will be programmed into Marvin registers.
> + */
> +#define SENSOR_GAMMA_CURVE_ARR_SIZE (17)
> +
> +struct ci_sensor_gamma_curve{
> +       unsigned short isp_gamma_y[SENSOR_GAMMA_CURVE_ARR_SIZE];
> +
> +       /* if three curves are given separately for RGB */
> +       unsigned int gamma_dx0;
> +
> +       /* only the struct for R holds valid DX values */
> +       unsigned int gamma_dx1;
> +};
> +
> +struct ci_sensor_blc_mean{
> +       unsigned char mean_a;
> +       unsigned char mean_b;
> +       unsigned char mean_c;
> +       unsigned char mean_d;
> +};
> +
> +/* autowhitebalance mean values */
> +
> +struct ci_sensor_awb_mean{
> +       unsigned int white;
> +       unsigned char mean_Y__G;
> +       unsigned char mean_cb__B;
> +       unsigned char mean_cr__R;
> +};
> +struct ci_sensor_aec_mean{
> +       unsigned char occ;
> +       unsigned char mean;
> +       unsigned char max;
> +       unsigned char min;
> +};
> +/* bad pixel element attribute */
> +
> +enum ci_sensor_bp_corr_attr{
> +
> +       /* hot pixel */
> +       SENSOR_BP_HOT,
> +
> +       /* dead pixel */
> +       SENSOR_BP_DEAD
> +};
> +
> +/* table element */
> +
> +struct ci_sensor_bp_table_elem{
> +
> +       /* Bad Pixel vertical address */
> +       unsigned short bp_ver_addr;
> +
> +       /* Bad Pixel horizontal address */
> +       unsigned short bp_hor_addr;
> +
> +       /* Bad pixel type (dead or hot) */
> +       enum ci_sensor_bp_corr_attr bp_type;
> +};
> +
> +/* Bad Pixel table */
> +struct ci_sensor_bp_table{
> +
> +       /* Number of detected bad pixel */
> +       unsigned int bp_number;
> +
> +       /* Pointer to BP Table */
> +       struct ci_sensor_bp_table_elem *bp_table_elem;
> +
> +       /* Number of Table elements */
> +       unsigned int bp_table_elem_num;
> +};
> +
> +struct ci_sensor_parm{
> +       unsigned int index;
> +       int value;
> +       int max;
> +       int min;
> +       int info;
> +       int type;
> +       char name[32];
> +       int step;
> +       int def_value;
> +       int flags;
> +};
> +
> +#define MRV_GRAD_TBL_SIZE      8
> +#define MRV_DATA_TBL_SIZE      289
> +struct ci_sensor_ls_corr_config{
> +       /*  correction values of R color part */
> +       unsigned short ls_rdata_tbl[MRV_DATA_TBL_SIZE];
> +       /*  correction values of G color part */
> +       unsigned short ls_gdata_tbl[MRV_DATA_TBL_SIZE];
> +       /*  correction values of B color part */
> +       unsigned short ls_bdata_tbl[MRV_DATA_TBL_SIZE];
> +       /*  multiplication factors of x direction */
> +       unsigned short ls_xgrad_tbl[MRV_GRAD_TBL_SIZE];
> +       /*  multiplication factors of y direction */
> +       unsigned short ls_ygrad_tbl[MRV_GRAD_TBL_SIZE];
> +       /* sector sizes of x direction */
> +       unsigned short ls_xsize_tbl[MRV_GRAD_TBL_SIZE];
> +       /*  sector sizes of y direction */
> +       unsigned short ls_ysize_tbl[MRV_GRAD_TBL_SIZE];
> +};
> +
> +struct ci_sensor_reg{
> +       unsigned int addr;
> +       unsigned int value;
> +};
> +#endif
> diff --git a/drivers/media/video/mrstci/include/ci_sensor_isp.h b/drivers/media/video/mrstci/include/ci_sensor_isp.h
> new file mode 100644
> index 0000000..ee0c2b8
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_sensor_isp.h
> @@ -0,0 +1,38 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
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
> +#include "ci_sensor_common.h"
> +
> +extern int ci_sensor_queryctrl(struct v4l2_queryctrl *);
> +extern int ci_sensor_get_ctrl(struct v4l2_control *);
> +extern int ci_sensor_set_ctrl(struct v4l2_control *);
> +extern int ci_sensor_try_mode(int *, int *);
> +extern int ci_sensor_set_mode(const int, const int);
> +extern int ci_sensor_get_config(struct ci_sensor_config *);
> +extern int ci_sensor_get_caps(struct ci_sensor_caps *);
> +extern int ci_sensor_res2size(u32, u16 *, u16 *);
> +extern int ci_sensor_get_ls_corr_config(struct ci_sensor_ls_corr_config *);
> +extern int ci_sensor_start(void);
> +extern int ci_sensor_stop(void);
> +extern int ci_sensor_suspend(void);
> +extern int ci_sensor_resume(void);
> diff --git a/drivers/media/video/mrstci/include/ci_va.h b/drivers/media/video/mrstci/include/ci_va.h
> new file mode 100644
> index 0000000..54bf9ff
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_va.h
> @@ -0,0 +1,43 @@
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
> +/* for buffer sharing between CI and VA */
> +#ifndef _CI_VA_H
> +#define _CI_VA_H
> +
> +struct ci_frame_info
> +{
> +       unsigned long frame_id; /* in */
> +       unsigned int width; /* out */
> +       unsigned int height; /* out */
> +       unsigned int stride; /* out */
> +       unsigned int fourcc; /* out */
> +       unsigned int offset; /* out */
> +};
> +
> +#define ISP_IOCTL_GET_FRAME_INFO _IOWR('V', 192 + 5, struct ci_frame_info)
> +
> +#endif
> +

Again, it seems that you're reinventing the wheel instead of using v4l2 dev/subdev.


> diff --git a/drivers/media/video/mrstci/mrstisp/Kconfig b/drivers/media/video/mrstci/mrstisp/Kconfig
> new file mode 100755
> index 0000000..c705524
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/Kconfig
> @@ -0,0 +1,9 @@
> +config VIDEO_MRST_ISP
> +       tristate "Moorstown Marvin - ISP Driver"
> +       depends on VIDEO_V4L2
> +       default y
> +       ---help---
> +         Say Y here if you want support for cameras based on the Intel Moorestown platform.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called mrstisp.ko.
> diff --git a/drivers/media/video/mrstci/mrstisp/include/debug.h b/drivers/media/video/mrstci/mrstisp/include/debug.h
> new file mode 100644
> index 0000000..99b7df6
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/debug.h
> @@ -0,0 +1,73 @@
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
> +#ifndef _DBG_H
> +#define _DBG_H
> +
> +extern int km_debug;
> +
> +/*
> + * macro for debug-specific output which is not needed for the release
> + * version
> + */
> +extern void intel_dbg_dd_out(u32 category, const char *pszFormat, ...);
> +/* release version: no code */
> +#define DBG_OUT(x) intel_dbg_dd_out x
> +
> +#ifdef DEBUG
> +/* assertion macro */
> +#define ASSERT(x) \
> +       if (!(x)) { \
> +               DBG_OUT("ASSERT(%s) failed! %s line %d\n", \
> +               #x, __FILE__, __LINE__); \
> +               while (1) \
> +                       ; \
> +       }
> +/* pre-condition macro */
> +#define PRE_CONDITION(condition) \
> +       if (!(condition)) { \
> +               DBG_OUT("PRE_CONDITION FAILURE:" #condition "%s line %d\n", \
> +               __FILE__, __LINE__);  \
> +               while (1) \
> +                       ; \
> +       }
> +/* post-condition macro */
> +#define POST_CONDITION(condition) \
> +       if (!(condition)) {\
> +               DBG_OUT("POST_CONDITION FAILURE:" #condition "%s line %d\n", \
> +               __FILE__, __LINE__); \
> +               while (1) \
> +                       ; \
> +       }
> +#else
> +/* assertion macro */
> +#define ASSERT(x)
> +/* pre-condition macro */
> +#define PRE_CONDITION(condition)
> +/* post-condition macro */
> +#define POST_CONDITION(condition)
> +#endif
> +
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/def.h b/drivers/media/video/mrstci/mrstisp/include/def.h
> new file mode 100644
> index 0000000..3479574
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/def.h
> @@ -0,0 +1,120 @@
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
> +#ifndef _DEF_H
> +#define _DEF_H
> +
> +#include <linux/stddef.h>
> +
> +#ifndef ON
> +/* all bits to '1' but prevent "shift overflow" warning */
> +#define ON   -1
> +#endif
> +#ifndef OFF
> +#define OFF  0
> +#endif
> +
> +#ifndef ENABLE
> +/* all bits to '1' but prevent "shift overflow" warning */
> +#define ENABLE   -1
> +#endif
> +#ifndef DISABLE
> +#define DISABLE  0
> +#endif
> +
> +
> +/* this has to be 0, if clauses rely on it */
> +#define CI_STATUS_SUCCESS         0
> +/* general failure */
> +#define CI_STATUS_FAILURE         1
> +/* feature not supported */
> +#define CI_STATUS_NOTSUPP         2
> +/* there's already something going on... */
> +#define CI_STATUS_BUSY            3
> +/* operation canceled */
> +#define CI_STATUS_CANCELED        4
> +/* out of memory */
> +#define CI_STATUS_OUTOFMEM        5
> +/* parameter/value out of range */
> +#define CI_STATUS_OUTOFRANGE      6
> +/* feature/subsystem is in idle state */
> +#define CI_STATUS_IDLE            7
> +/* handle is wrong */
> +#define CI_STATUS_WRONG_HANDLE    8
> +/* the/one/all parameter(s) is a(are) NULL pointer(s) */
> +#define CI_STATUS_NULL_POINTER    9
> +/* profile not available */
> +#define CI_STATUS_NOTAVAILABLE    10
> +
> +#ifndef UNUSED_PARAM
> +#define UNUSED_PARAM(x)   ((x) = (x))
> +#endif
> +
> +/* to avoid Lint warnings, use it within const context */
> +
> +#ifndef UNUSED_PARAM1
> +#define UNUSED_PARAM1(x)
> +#endif
> +
> +/*
> + * documentation keywords for pointer arguments, to tell the direction of the
> + * passing
> + */
> +
> +#ifndef OUT
> +/* pointer content is expected to be filled by called function */
> +#define OUT
> +#endif
> +#ifndef IN
> +/* pointer content contains parameters from the caller */
> +#define IN
> +#endif
> +#ifndef INOUT
> +/* content is expected to be read and changed */
> +#define INOUT
> +#endif
> +
> +/* some useful macros */
> +
> +#ifndef MIN
> +#define MIN(x, y)            ((x) < (y) ? (x) : (y))
> +#endif
> +
> +#ifndef MAX
> +#define MAX(x, y)            ((x) > (y) ? (x) : (y))
> +#endif
> +
> +#ifndef ABS
> +#define ABS(val)            ((val) < 0 ? -(val) : (val))
> +#endif
> +
> +/*
> + * converts a term to a string (two macros are required, never use _VAL2STR()
> + * directly)
> + */
> +#define _VAL2STR(x) #x
> +#define VAL2STR(x) _VAL2STR(x)
> +
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/intel_v4l2.h b/drivers/media/video/mrstci/mrstisp/include/intel_v4l2.h
> new file mode 100644
> index 0000000..9ddb4e8
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/intel_v4l2.h
> @@ -0,0 +1,181 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
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
> +
> +#ifndef INTEL_V4L2_H
> +#define INTEL_V4L2_H
> +
> +#define INTEL_MAJ_VER   0
> +#define INTEL_MIN_VER   5
> +#define INTEL_PATCH_VER  0
> +#define DRIVER_NAME "intel isp"
> +#define VID_HARDWARE_INTEL     100
> +#define INTEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
> +#define MRST_ISP_REG_MEMORY_MAP 0xFF0E0000
> +
> +
> +/* self path maximum width/height, VGA */
> +#define INTEL_MAX_WIDTH  640
> +#define INTEL_MAX_HEIGHT 480
> +
> +#define INTEL_MIN_WIDTH  32
> +#define INTEL_MIN_HEIGHT 16
> +
> +/* main path maximum widh/height, 5M */
> +#define INTEL_MAX_WIDTH_MP 2600
> +#define INTEL_MAX_HEIGHT_MP 2048
> +
> +/* image size returned by the driver */
> +#define INTEL_IMAGE_WIDTH  640
> +#define INTEL_IMAGE_HEIGHT 480
> +
> +/* Default capture queue buffers. */
> +#define INTEL_CAPTURE_BUFFERS 3
> +
> +/* Default capture buffer size.  */
> +#define INTEL_CAPTURE_BUFSIZE PAGE_ALIGN(INTEL_MAX_WIDTH * INTEL_MAX_HEIGHT * 2)
> +#define INTEL_IMAGE_BUFSIEZE (INTEL_IMAGE_WIDTH * INTEL_IMAGE_HEIGHT * 2)
> +
> +#define MAX_KMALLOC_MEM (4*1024*1024)
> +
> +#define MEM_SNAPSHOT_MAX_SIZE (1*1024*1024)
> +
> +enum frame_state {
> +       S_UNUSED = 0,   /* unused */
> +       S_QUEUED,       /* ready to capture */
> +       S_GRABBING,     /* in the process of being captured */
> +       S_DONE, /* finished grabbing, but not been synced yet */
> +       S_ERROR,        /* something bad happened while capturing */
> +};
> +
> +struct frame_info {
> +       enum frame_state state;
> +       u32 flags;
> +};
> +
> +struct fifo {
> +       int front;
> +       int back;
> +       int data[INTEL_CAPTURE_BUFFERS + 1];
> +       struct frame_info info[INTEL_CAPTURE_BUFFERS + 1];
> +};
> +
> +enum intel_state {
> +       S_NOTREADY,     /* Not yet initialized */
> +       S_IDLE,         /* Just hanging around */
> +       S_FLAKED,       /* Some sort of problem */
> +       S_STREAMING     /* Streaming data */
> +};
> +
> +struct ci_isp_rect {
> +       /* zero based x coordinate of the upper left edge of the
> +        * rectangle (in pixels)
> +        */
> +       int x;
> +       /* zero based y coordinate of the upper left edge of the
> +        * rectangle (in pixels)
> +        */
> +       int y;
> +       /* width of the rectangle in pixels */
> +       int w;
> +       /* height of the rectangle in pixels */
> +       int h;
> +};
> +
> +struct intel_isp_device {
> +       /* v4l2 device handler */
> +       struct video_device *vdev;
> +       /* locks this structure */
> +       struct semaphore sem;
> +       /* if the port is open or not */
> +       int open;
> +       /* pci information */
> +       struct pci_dev *pci_dev;
> +       unsigned long mb0;
> +       unsigned long mb0_size;
> +       unsigned char *regs;
> +       unsigned long mb1;
> +       unsigned long mb1_size;
> +       unsigned char *mb1_va;
> +       unsigned short vendorID;
> +       unsigned short deviceID;
> +       unsigned char revision;
> +
> +       /* interrupt */
> +       unsigned char int_enable;
> +       unsigned long int_flag;
> +       unsigned long interrupt_count;
> +
> +       /* frame management */
> +
> +       /* allocated memory for km_mmap */
> +       char *fbuffer;
> +       /* virtual address of cap buf */
> +       char *capbuf;
> +       /* physcial address of cap buf */
> +       u32 capbuf_pa;
> +       struct fifo frame_queue;
> +       /* current capture frame number */
> +       int cap_frame;
> +       /* total frames */
> +       int num_frames;
> +
> +       u32 field_count;
> +       u32 pixelformat;
> +       u16 depth;
> +       u32 bufwidth;
> +       u32 bufheight;
> +       u32 frame_size;
> +       u32 frame_size_used;
> +       enum intel_state state;
> +       /* active mappings*/
> +       int vmas;
> +       /* isp system configuration */
> +       struct ci_pl_system_config sys_conf;
> +
> +};
> +
> +/* hardware RGB conversion */
> +#define VFFLAG_HWRGB                0x00000010
> +/* horizontal mirror */
> +#define VFFLAG_MIRROR               0x00000020
> +/* use the main path for viewfinding too. */
> +#define VFFLAG_USE_MAINPATH         0x00000040
> +/* vertical flipping (mirror) (MARVIN_FEATURE_MI_V3) */
> +#define VFFLAG_V_FLIP               0x00000100
> +/* rotation 90 degree counterclockwise (left) (MARVIN_FEATURE_MI_V3) */
> +#define VFFLAG_ROT90_CCW            0x00000200
> +
> +/* abbreviations for local debug control ( level | module ) */
> +#define DBG_INFO        0x00000001
> +#define DBG_WARN        0x00000002
> +#define DBG_ERR         0x00000004
> +
> +#define DBG_MRV         0x00001000
> +#define DBG_MIPI        0x00040000
> +
> +#define DERR  (DBG_ERR  | DBG_MRV)
> +#define DWARN (DBG_WARN | DBG_MRV)
> +#define DINFO (DBG_INFO | DBG_MRV)
> +
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrv.h b/drivers/media/video/mrstci/mrstisp/include/mrv.h
> new file mode 100644
> index 0000000..3a492e4
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrv.h
> @@ -0,0 +1,105 @@
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
> +
> +#ifndef _MRV_H
> +#define _MRV_H
> +
> +/* move structure definination to ci_isp_common.h */
> +#include "ci_isp_common.h"
> +#define MARVIN_FEATURE_CHIP_ID         0x20453010
> +
> +enum ci_isp_path ci_isp_select_path(
> +       const struct ci_sensor_config *isi_cfg,
> +       u8 *words_per_pixel);
> +int ci_isp_set_input_aquisition(
> +       const struct ci_sensor_config *isi_cfg);
> +int ci_isp_set_bp_correction(
> +       const struct ci_isp_bp_corr_config *bp_corr_config);
> +int ci_isp_set_bp_detection(
> +       const struct ci_isp_bp_det_config *bp_det_config);
> +
> +int ci_isp_clear_bp_int(void);
> +int ci_isp_wait_for_frame_end(void);
> +void ci_isp_set_output_formatter(
> +       const struct ci_isp_window *window,
> +       enum ci_isp_conf_update_time update_time);
> +int ci_isp_is_set_config(const struct ci_isp_is_config *is_config);
> +int ci_isp_set_data_path(
> +       enum ci_isp_ycs_chn_mode ycs_chn_mode,
> +       enum ci_isp_dp_switch dp_switch);
> +void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
> +       enum ci_isp_conf_update_time update_time,
> +       const struct ci_isp_rsz_lut *rsz_lut);
> +void ci_isp_res_get_main_resize(struct ci_isp_scale *scale);
> +void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
> +       enum ci_isp_conf_update_time update_time,
> +       const struct ci_isp_rsz_lut *rsz_lut);
> +int ci_isp_mif__set_main_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
> +       enum ci_isp_conf_update_time update_time);
> +int ci_isp_mif__set_self_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
> +       enum ci_isp_conf_update_time update_time);
> +int ci_isp_mif__set_dma_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf);
> +int ci_isp_mif__set_path_and_orientation(
> +       const struct ci_isp_mi_ctrl *mrv_mi_ctrl);
> +void ci_isp_set_ext_ycmode(void);
> +int ci_isp_set_mipi_smia(u32 mode);
> +void ci_isp_set_dma_read_mode(
> +       enum ci_isp_dma_read_mode mode,
> +       enum ci_isp_conf_update_time update_time);
> +u32 ci_isp_mif_get_byte_cnt(void);
> +void ci_isp_start(
> +       u16 number_of_frames,
> +       enum ci_isp_conf_update_time update_time
> +);
> +int ci_isp_jpe_init_ex(
> +       u16 hsize,
> +       u16 vsize,
> +       u8 compression_ratio,
> +       u8 jpe_scale);
> +void ci_isp_reset_interrupt_status(void);
> +int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config);
> +void ci_isp_col_set_color_processing(
> +       const struct ci_isp_color_settings *col);
> +int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config);
> +int ci_isp_set_ls_correction(
> +       struct ci_sensor_ls_corr_config *ls_corr_config);
> +int ci_isp_ls_correction_on_off(int ls_corr_on_off);
> +int ci_isp_activate_filter(int activate_filter);
> +int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level);
> +int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config);
> +void ci_isp_init(void);
> +void ci_isp_off(void);
> +void ci_isp_stop(enum ci_isp_conf_update_time update_time);
> +void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time);
> +void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma);
> +void ci_isp_set_demosaic(
> +       enum ci_isp_demosaic_mode demosaic_mode,
> +       u8 demosaic_th
> +);
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrv_jpe.h b/drivers/media/video/mrstci/mrstisp/include/mrv_jpe.h
> new file mode 100644
> index 0000000..d46f4d7
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrv_jpe.h
> @@ -0,0 +1,404 @@
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
> +/* DC luma table according to ISO/IEC 10918-1 annex K */
> +static const u8 ci_isp_dc_luma_table_annex_k[] = {
> +       0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +       0x08, 0x09, 0x0a, 0x0b
> +};
> +
> +/* DC chroma table according to ISO/IEC 10918-1 annex K */
> +static const u8 ci_isp_dc_chroma_table_annex_k[] = {
> +       0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +       0x08, 0x09, 0x0a, 0x0b
> +};
> +
> +/* AC luma table according to ISO/IEC 10918-1 annex K */
> +static const u8 ci_isp_ac_luma_table_annex_k[] = {
> +       0x00, 0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03,
> +       0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7d,
> +       0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
> +       0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
> +       0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
> +       0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
> +       0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
> +       0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
> +       0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
> +       0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
> +       0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
> +       0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
> +       0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
> +       0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
> +       0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
> +       0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
> +       0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
> +       0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
> +       0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
> +       0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
> +       0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
> +       0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
> +       0xf9, 0xfa
> +};
> +
> +/* AC Chroma table according to ISO/IEC 10918-1 annex K */
> +static const u8 ci_isp_ac_chroma_table_annex_k[] = {
> +       0x00, 0x02, 0x01, 0x02, 0x04, 0x04, 0x03, 0x04,
> +       0x07, 0x05, 0x04, 0x04, 0x00, 0x01, 0x02, 0x77,
> +       0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
> +       0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
> +       0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
> +       0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
> +       0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
> +       0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
> +       0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
> +       0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
> +       0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
> +       0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
> +       0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
> +       0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> +       0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
> +       0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
> +       0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
> +       0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
> +       0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
> +       0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
> +       0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
> +       0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
> +       0xf9, 0xfa
> +};
> +
> +/* luma quantization table 75% quality setting */
> +static const u8 ci_isp_yq_table75_per_cent[] = {
> +       0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
> +       0x07, 0x07, 0x09, 0x09, 0x08, 0x0a, 0x0c, 0x14,
> +       0x0d, 0x0c, 0x0b, 0x0b, 0x0c, 0x19, 0x12, 0x13,
> +       0x0f, 0x14, 0x1d, 0x1a, 0x1f, 0x1e, 0x1d, 0x1a,
> +       0x1c, 0x1c, 0x20, 0x24, 0x2e, 0x27, 0x20, 0x22,
> +       0x2c, 0x23, 0x1c, 0x1c, 0x28, 0x37, 0x29, 0x2c,
> +       0x30, 0x31, 0x34, 0x34, 0x34, 0x1f, 0x27, 0x39,
> +       0x3d, 0x38, 0x32, 0x3c, 0x2e, 0x33, 0x34, 0x32
> +};
> +
> +/* chroma quantization table 75% quality setting */
> +static const u8 ci_isp_uv_qtable75_per_cent[] = {
> +       0x09, 0x09, 0x09, 0x0c, 0x0b, 0x0c, 0x18, 0x0d,
> +       0x0d, 0x18, 0x32, 0x21, 0x1c, 0x21, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
> +       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32
> +};
> +
> +/*
> + * luma quantization table very low compression(about factor 2)
> + */
> +static const u8 ci_isp_yq_table_low_comp1[] = {
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
> +};
> +
> +/*
> + * chroma quantization table very low compression
> + * (about factor 2)
> + */
> +static const u8 ci_isp_uv_qtable_low_comp1[] = {
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
> +};
> +
> +/*
> + * The jpg Quantization Tables were parsed by jpeg_parser from
> + * jpg images generated by Jasc PaintShopPro.
> + *
> + */
> +
> +/* 01% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table01_per_cent[] = {
> +       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x01, 0x01, 0x02, 0x02, 0x01, 0x01,
> +       0x02, 0x01, 0x01, 0x01, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable01_per_cent[] = {
> +       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +       0x01, 0x01, 0x02, 0x01, 0x01, 0x01, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
> +};
> +
> +/* 20% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table20_per_cent[] = {
> +       0x06, 0x04, 0x05, 0x06, 0x05, 0x04, 0x06, 0x06,
> +       0x05, 0x06, 0x07, 0x07, 0x06, 0x08, 0x0a, 0x10,
> +       0x0a, 0x0a, 0x09, 0x09, 0x0a, 0x14, 0x0e, 0x0f,
> +       0x0c, 0x10, 0x17, 0x14, 0x18, 0x18, 0x17, 0x14,
> +       0x16, 0x16, 0x1a, 0x1d, 0x25, 0x1f, 0x1a, 0x1b,
> +       0x23, 0x1c, 0x16, 0x16, 0x20, 0x2c, 0x20, 0x23,
> +       0x26, 0x27, 0x29, 0x2a, 0x29, 0x19, 0x1f, 0x2d,
> +       0x30, 0x2d, 0x28, 0x30, 0x25, 0x28, 0x29, 0x28
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable20_per_cent[] = {
> +       0x07, 0x07, 0x07, 0x0a, 0x08, 0x0a, 0x13, 0x0a,
> +       0x0a, 0x13, 0x28, 0x1a, 0x16, 0x1a, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> +       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28
> +};
> +
> +/* 30% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table30_per_cent[] = {
> +       0x0a, 0x07, 0x07, 0x08, 0x07, 0x06, 0x0a, 0x08,
> +       0x08, 0x08, 0x0b, 0x0a, 0x0a, 0x0b, 0x0e, 0x18,
> +       0x10, 0x0e, 0x0d, 0x0d, 0x0e, 0x1d, 0x15, 0x16,
> +       0x11, 0x18, 0x23, 0x1f, 0x25, 0x24, 0x22, 0x1f,
> +       0x22, 0x21, 0x26, 0x2b, 0x37, 0x2f, 0x26, 0x29,
> +       0x34, 0x29, 0x21, 0x22, 0x30, 0x41, 0x31, 0x34,
> +       0x39, 0x3b, 0x3e, 0x3e, 0x3e, 0x25, 0x2e, 0x44,
> +       0x49, 0x43, 0x3c, 0x48, 0x37, 0x3d, 0x3e, 0x3b
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable30_per_cent[] = {
> +       0x0a, 0x0b, 0x0b, 0x0e, 0x0d, 0x0e, 0x1c, 0x10,
> +       0x10, 0x1c, 0x3b, 0x28, 0x22, 0x28, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
> +       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b
> +};
> +
> +
> +/* 40% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table40_per_cent[] = {
> +       0x0d, 0x09, 0x0a, 0x0b, 0x0a, 0x08, 0x0d, 0x0b,
> +       0x0a, 0x0b, 0x0e, 0x0e, 0x0d, 0x0f, 0x13, 0x20,
> +       0x15, 0x13, 0x12, 0x12, 0x13, 0x27, 0x1c, 0x1e,
> +       0x17, 0x20, 0x2e, 0x29, 0x31, 0x30, 0x2e, 0x29,
> +       0x2d, 0x2c, 0x33, 0x3a, 0x4a, 0x3e, 0x33, 0x36,
> +       0x46, 0x37, 0x2c, 0x2d, 0x40, 0x57, 0x41, 0x46,
> +       0x4c, 0x4e, 0x52, 0x53, 0x52, 0x32, 0x3e, 0x5a,
> +       0x61, 0x5a, 0x50, 0x60, 0x4a, 0x51, 0x52, 0x4f
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable40_per_cent[] = {
> +       0x0e, 0x0e, 0x0e, 0x13, 0x11, 0x13, 0x26, 0x15,
> +       0x15, 0x26, 0x4f, 0x35, 0x2d, 0x35, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
> +       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f
> +};
> +
> +/* 50% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table50_per_cent[] = {
> +       0x10, 0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e,
> +       0x0d, 0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28,
> +       0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
> +       0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
> +       0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
> +       0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
> +       0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
> +       0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable50_per_cent[] = {
> +       0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
> +       0x1a, 0x2f, 0x63, 0x42, 0x38, 0x42, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> +       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63
> +};
> +
> +/* 60% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table60_per_cent[] = {
> +       0x14, 0x0e, 0x0f, 0x12, 0x0f, 0x0d, 0x14, 0x12,
> +       0x10, 0x12, 0x17, 0x15, 0x14, 0x18, 0x1e, 0x32,
> +       0x21, 0x1e, 0x1c, 0x1c, 0x1e, 0x3d, 0x2c, 0x2e,
> +       0x24, 0x32, 0x49, 0x40, 0x4c, 0x4b, 0x47, 0x40,
> +       0x46, 0x45, 0x50, 0x5a, 0x73, 0x62, 0x50, 0x55,
> +       0x6d, 0x56, 0x45, 0x46, 0x64, 0x88, 0x65, 0x6d,
> +       0x77, 0x7b, 0x81, 0x82, 0x81, 0x4e, 0x60, 0x8d,
> +       0x97, 0x8c, 0x7d, 0x96, 0x73, 0x7e, 0x81, 0x7c
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable60_per_cent[] = {
> +       0x15, 0x17, 0x17, 0x1e, 0x1a, 0x1e, 0x3b, 0x21,
> +       0x21, 0x3b, 0x7c, 0x53, 0x46, 0x53, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
> +       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c
> +};
> +
> +/* 70% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table70_per_cent[] = {
> +       0x1b, 0x12, 0x14, 0x17, 0x14, 0x11, 0x1b, 0x17,
> +       0x16, 0x17, 0x1e, 0x1c, 0x1b, 0x20, 0x28, 0x42,
> +       0x2b, 0x28, 0x25, 0x25, 0x28, 0x51, 0x3a, 0x3d,
> +       0x30, 0x42, 0x60, 0x55, 0x65, 0x64, 0x5f, 0x55,
> +       0x5d, 0x5b, 0x6a, 0x78, 0x99, 0x81, 0x6a, 0x71,
> +       0x90, 0x73, 0x5b, 0x5d, 0x85, 0xb5, 0x86, 0x90,
> +       0x9e, 0xa3, 0xab, 0xad, 0xab, 0x67, 0x80, 0xbc,
> +       0xc9, 0xba, 0xa6, 0xc7, 0x99, 0xa8, 0xab, 0xa4
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable70_per_cent[] = {
> +       0x1c, 0x1e, 0x1e, 0x28, 0x23, 0x28, 0x4e, 0x2b,
> +       0x2b, 0x4e, 0xa4, 0x6e, 0x5d, 0x6e, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
> +       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4
> +};
> +
> +/* 80% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table80_per_cent[] = {
> +       0x28, 0x1c, 0x1e, 0x23, 0x1e, 0x19, 0x28, 0x23,
> +       0x21, 0x23, 0x2d, 0x2b, 0x28, 0x30, 0x3c, 0x64,
> +       0x41, 0x3c, 0x37, 0x37, 0x3c, 0x7b, 0x58, 0x5d,
> +       0x49, 0x64, 0x91, 0x80, 0x99, 0x96, 0x8f, 0x80,
> +       0x8c, 0x8a, 0xa0, 0xb4, 0xe6, 0xc3, 0xa0, 0xaa,
> +       0xda, 0xad, 0x8a, 0x8c, 0xc8, 0xff, 0xcb, 0xda,
> +       0xee, 0xf5, 0xff, 0xff, 0xff, 0x9b, 0xc1, 0xff,
> +       0xff, 0xff, 0xfa, 0xff, 0xe6, 0xfd, 0xff, 0xf8
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable80_per_cent[] = {
> +       0x2b, 0x2d, 0x2d, 0x3c, 0x35, 0x3c, 0x76, 0x41,
> +       0x41, 0x76, 0xf8, 0xa5, 0x8c, 0xa5, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
> +       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8
> +};
> +
> +/* 90% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table90_per_cent[] = {
> +       0x50, 0x37, 0x3c, 0x46, 0x3c, 0x32, 0x50, 0x46,
> +       0x41, 0x46, 0x5a, 0x55, 0x50, 0x5f, 0x78, 0xc8,
> +       0x82, 0x78, 0x6e, 0x6e, 0x78, 0xf5, 0xaf, 0xb9,
> +       0x91, 0xc8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable90_per_cent[] = {
> +       0x55, 0x5a, 0x5a, 0x78, 0x69, 0x78, 0xeb, 0x82,
> +       0x82, 0xeb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +};
> +
> +/* 99% */
> +/* luma quantization table */
> +static const u8 ci_isp_yq_table99_per_cent[] = {
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +};
> +
> +/* chroma quantization table */
> +static const u8 ci_isp_uv_qtable99_per_cent[] = {
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +};
> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrv_priv.h b/drivers/media/video/mrstci/mrstisp/include/mrv_priv.h
> new file mode 100644
> index 0000000..442aaa7
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrv_priv.h
> @@ -0,0 +1,3464 @@
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
> +#ifndef _MRV_PRIV_H
> +#define _MRV_PRIV_H
> +
> +#define MRV_ISP_GAMMA_R_Y_ARR_SIZE 17
> +#define MRV_ISP_GAMMA_G_Y_ARR_SIZE 17
> +#define MRV_ISP_GAMMA_B_Y_ARR_SIZE 17
> +#define MRV_ISP_CT_COEFF_ARR_SIZE 9
> +#define MRV_ISP_GAMMA_OUT_Y_ARR_SIZE 17
> +#define MRV_ISP_BP_NEW_TABLE_ARR_SIZE 8
> +#define MRV_ISP_HIST_BIN_ARR_SIZE 16
> +
> +struct isp_register {
> +       u32 vi_ccl;
> +       u32 vi_custom_reg1;
> +       u32 vi_id;
> +       u32 vi_custom_reg2;
> +       u32 vi_iccl;
> +       u32 vi_ircl;
> +       u32 vi_dpcl;
> +
> +       u32 notused_mrvbase1;
> +       u32 notused_mrvbase2[(0x200 - 0x20) / 4];
> +
> +       u32 img_eff_ctrl;
> +       u32 img_eff_color_sel;
> +       u32 img_eff_mat_1;
> +       u32 img_eff_mat_2;
> +       u32 img_eff_mat_3;
> +       u32 img_eff_mat_4;
> +       u32 img_eff_mat_5;
> +       u32 img_eff_tint;
> +       u32 img_eff_ctrl_shd;
> +       u32 notused_imgeff[(0x300 - 0x224) / 4];
> +
> +       u32 super_imp_ctrl;
> +       u32 super_imp_offset_x;
> +       u32 super_imp_offset_y;
> +       u32 super_imp_color_y;
> +       u32 super_imp_color_cb;
> +       u32 super_imp_color_cr;
> +       u32 notused_simp[(0x400 - 0x318) / 4];
> +
> +       u32 isp_ctrl;
> +       u32 isp_acq_prop;
> +       u32 isp_acq_h_offs;
> +       u32 isp_acq_v_offs;
> +       u32 isp_acq_h_size;
> +       u32 isp_acq_v_size;
> +       u32 isp_acq_nr_frames;
> +       u32 isp_gamma_dx_lo;
> +       u32 isp_gamma_dx_hi;
> +       u32 isp_gamma_r_y[MRV_ISP_GAMMA_R_Y_ARR_SIZE];
> +       u32 isp_gamma_g_y[MRV_ISP_GAMMA_G_Y_ARR_SIZE];
> +       u32 isp_gamma_b_y[MRV_ISP_GAMMA_B_Y_ARR_SIZE];
> +
> +       u32 notused_ispbls1[(0x510 - 0x4F0) / 4];
> +
> +       u32 isp_awb_prop;
> +       u32 isp_awb_h_offs;
> +       u32 isp_awb_v_offs;
> +       u32 isp_awb_h_size;
> +       u32 isp_awb_v_size;
> +       u32 isp_awb_frames;
> +       u32 isp_awb_ref;
> +       u32 isp_awb_thresh;
> +
> +       u32 notused_ispawb2[(0x538-0x530)/4];
> +
> +       u32 isp_awb_gain_g;
> +       u32 isp_awb_gain_rb;
> +
> +       u32 isp_awb_white_cnt;
> +       u32 isp_awb_mean;
> +
> +       u32 notused_ispae[(0x570 - 0x548) / 4];
> +       u32 isp_cc_coeff_0;
> +       u32 isp_cc_coeff_1;
> +       u32 isp_cc_coeff_2;
> +       u32 isp_cc_coeff_3;
> +       u32 isp_cc_coeff_4;
> +       u32 isp_cc_coeff_5;
> +       u32 isp_cc_coeff_6;
> +       u32 isp_cc_coeff_7;
> +       u32 isp_cc_coeff_8;
> +
> +       u32 isp_out_h_offs;
> +       u32 isp_out_v_offs;
> +       u32 isp_out_h_size;
> +       u32 isp_out_v_size;
> +
> +       u32 isp_demosaic;
> +       u32 isp_flags_shd;
> +
> +       u32 isp_out_h_offs_shd;
> +       u32 isp_out_v_offs_shd;
> +       u32 isp_out_h_size_shd;
> +       u32 isp_out_v_size_shd;
> +
> +       u32 isp_imsc;
> +       u32 isp_ris;
> +       u32 isp_mis;
> +       u32 isp_icr;
> +       u32 isp_isr;
> +
> +       u32 isp_ct_coeff[MRV_ISP_CT_COEFF_ARR_SIZE];
> +       u32 isp_gamma_out_mode;
> +       u32 isp_gamma_out_y[MRV_ISP_GAMMA_OUT_Y_ARR_SIZE];
> +
> +       u32 isp_err;
> +       u32 isp_err_clr;
> +
> +       u32 isp_frame_count;
> +
> +       u32 isp_ct_offset_r;
> +       u32 isp_ct_offset_g;
> +       u32 isp_ct_offset_b;
> +       u32 notused_ispctoffs[(0x660 - 0x654) / 4];
> +
> +       u32 isp_flash_cmd;
> +       u32 isp_flash_config;
> +       u32 isp_flash_prediv;
> +       u32 isp_flash_delay;
> +       u32 isp_flash_time;
> +       u32 isp_flash_maxp;
> +       u32 notused_ispflash[(0x680 - 0x678) / 4];
> +
> +       u32 isp_sh_ctrl;
> +       u32 isp_sh_prediv;
> +       u32 isp_sh_delay;
> +       u32 isp_sh_time;
> +       u32 notused_ispsh[(0x800 - 0x690) / 4];
> +
> +       u32 c_proc_ctrl;
> +       u32 c_proc_contrast;
> +       u32 c_proc_brightness;
> +       u32 c_proc_saturation;
> +       u32 c_proc_hue;
> +       u32 notused_cproc[(0xC00 - 0x814) / 4];
> +
> +       u32 mrsz_ctrl;
> +       u32 mrsz_scale_hy;
> +       u32 mrsz_scale_hcb;
> +       u32 mrsz_scale_hcr;
> +       u32 mrsz_scale_vy;
> +       u32 mrsz_scale_vc;
> +       u32 mrsz_phase_hy;
> +       u32 mrsz_phase_hc;
> +       u32 mrsz_phase_vy;
> +       u32 mrsz_phase_vc;
> +       u32 mrsz_scale_lut_addr;
> +       u32 mrsz_scale_lut;
> +       u32 mrsz_ctrl_shd;
> +       u32 mrsz_scale_hy_shd;
> +       u32 mrsz_scale_hcb_shd;
> +       u32 mrsz_scale_hcr_shd;
> +       u32 mrsz_scale_vy_shd;
> +       u32 mrsz_scale_vc_shd;
> +       u32 mrsz_phase_hy_shd;
> +       u32 mrsz_phase_hc_shd;
> +       u32 mrsz_phase_vy_shd;
> +       u32 mrsz_phase_vc_shd;
> +       u32 notused_mrsz[(0x1000 - 0x0C58) / 4];
> +
> +       u32 srsz_ctrl;
> +       u32 srsz_scale_hy;
> +       u32 srsz_scale_hcb;
> +       u32 srsz_scale_hcr;
> +       u32 srsz_scale_vy;
> +       u32 srsz_scale_vc;
> +       u32 srsz_phase_hy;
> +       u32 srsz_phase_hc;
> +       u32 srsz_phase_vy;
> +       u32 srsz_phase_vc;
> +       u32 srsz_scale_lut_addr;
> +       u32 srsz_scale_lut;
> +       u32 srsz_ctrl_shd;
> +       u32 srsz_scale_hy_shd;
> +       u32 srsz_scale_hcb_shd;
> +       u32 srsz_scale_hcr_shd;
> +       u32 srsz_scale_vy_shd;
> +       u32 srsz_scale_vc_shd;
> +       u32 srsz_phase_hy_shd;
> +       u32 srsz_phase_hc_shd;
> +       u32 srsz_phase_vy_shd;
> +       u32 srsz_phase_vc_shd;
> +       u32 notused_srsz[(0x1400 - 0x1058) / 4];
> +
> +       u32 mi_ctrl;
> +       u32 mi_init;
> +       u32 mi_mp_y_base_ad_init;
> +       u32 mi_mp_y_size_init;
> +       u32 mi_mp_y_offs_cnt_init;
> +       u32 mi_mp_y_offs_cnt_start;
> +       u32 mi_mp_y_irq_offs_init;
> +       u32 mi_mp_cb_base_ad_init;
> +       u32 mi_mp_cb_size_init;
> +       u32 mi_mp_cb_offs_cnt_init;
> +       u32 mi_mp_cb_offs_cnt_start;
> +       u32 mi_mp_cr_base_ad_init;
> +       u32 mi_mp_cr_size_init;
> +       u32 mi_mp_cr_offs_cnt_init;
> +       u32 mi_mp_cr_offs_cnt_start;
> +       u32 mi_sp_y_base_ad_init;
> +       u32 mi_sp_y_size_init;
> +       u32 mi_sp_y_offs_cnt_init;
> +       u32 mi_sp_y_offs_cnt_start;
> +       u32 mi_sp_y_llength;
> +       u32 mi_sp_cb_base_ad_init;
> +       u32 mi_sp_cb_size_init;
> +       u32 mi_sp_cb_offs_cnt_init;
> +       u32 mi_sp_cb_offs_cnt_start;
> +       u32 mi_sp_cr_base_ad_init;
> +       u32 mi_sp_cr_size_init;
> +       u32 mi_sp_cr_offs_cnt_init;
> +       u32 mi_sp_cr_offs_cnt_start;
> +       u32 mi_byte_cnt;
> +       u32 mi_ctrl_shd;
> +       u32 mi_mp_y_base_ad_shd;
> +       u32 mi_mp_y_size_shd;
> +       u32 mi_mp_y_offs_cnt_shd;
> +       u32 mi_mp_y_irq_offs_shd;
> +       u32 mi_mp_cb_base_ad_shd;
> +       u32 mi_mp_cb_size_shd;
> +       u32 mi_mp_cb_offs_cnt_shd;
> +       u32 mi_mp_cr_base_ad_shd;
> +       u32 mi_mp_cr_size_shd;
> +       u32 mi_mp_cr_offs_cnt_shd;
> +       u32 mi_sp_y_base_ad_shd;
> +       u32 mi_sp_y_size_shd;
> +       u32 mi_sp_y_offs_cnt_shd;
> +
> +       u32 notused_mi1;
> +
> +       u32 mi_sp_cb_base_ad_shd;
> +       u32 mi_sp_cb_size_shd;
> +       u32 mi_sp_cb_offs_cnt_shd;
> +       u32 mi_sp_cr_base_ad_shd;
> +       u32 mi_sp_cr_size_shd;
> +       u32 mi_sp_cr_offs_cnt_shd;
> +       u32 mi_dma_y_pic_start_ad;
> +       u32 mi_dma_y_pic_width;
> +       u32 mi_dma_y_llength;
> +       u32 mi_dma_y_pic_size;
> +       u32 mi_dma_cb_pic_start_ad;
> +       u32 notused_mi2[(0x14E8 - 0x14DC) / 4];
> +       u32 mi_dma_cr_pic_start_ad;
> +       u32 notused_mi3[(0x14F8 - 0x14EC) / 4];
> +       u32 mi_imsc;
> +       u32 mi_ris;
> +       u32 mi_mis;
> +       u32 mi_icr;
> +       u32 mi_isr;
> +       u32 mi_status;
> +       u32 mi_status_clr;
> +       u32 mi_sp_y_pic_width;
> +       u32 mi_sp_y_pic_height;
> +       u32 mi_sp_y_pic_size;
> +       u32 mi_dma_ctrl;
> +       u32 mi_dma_start;
> +       u32 mi_dma_status;
> +       u32 notused_mi6[(0x1800 - 0x152C) / 4];
> +       u32 jpe_gen_header;
> +       u32 jpe_encode;
> +
> +       u32 jpe_init;
> +
> +       u32 jpe_y_scale_en;
> +       u32 jpe_cbcr_scale_en;
> +       u32 jpe_table_flush;
> +       u32 jpe_enc_hsize;
> +       u32 jpe_enc_vsize;
> +       u32 jpe_pic_format;
> +       u32 jpe_restart_interval;
> +       u32 jpe_tq_y_select;
> +       u32 jpe_tq_u_select;
> +       u32 jpe_tq_v_select;
> +       u32 jpe_dc_table_select;
> +       u32 jpe_ac_table_select;
> +       u32 jpe_table_data;
> +       u32 jpe_table_id;
> +       u32 jpe_tac0_len;
> +       u32 jpe_tdc0_len;
> +       u32 jpe_tac1_len;
> +       u32 jpe_tdc1_len;
> +       u32 notused_jpe2;
> +       u32 jpe_encoder_busy;
> +       u32 jpe_header_mode;
> +       u32 jpe_encode_mode;
> +       u32 jpe_debug;
> +       u32 jpe_error_imr;
> +       u32 jpe_error_ris;
> +       u32 jpe_error_mis;
> +       u32 jpe_error_icr;
> +       u32 jpe_error_isr;
> +       u32 jpe_status_imr;
> +       u32 jpe_status_ris;
> +       u32 jpe_status_mis;
> +       u32 jpe_status_icr;
> +       u32 jpe_status_isr;
> +       u32 notused_jpe3[(0x1A00 - 0x1890) / 4];
> +
> +       u32 smia_ctrl;
> +       u32 smia_status;
> +       u32 smia_imsc;
> +       u32 smia_ris;
> +       u32 smia_mis;
> +       u32 smia_icr;
> +       u32 smia_isr;
> +       u32 smia_data_format_sel;
> +       u32 smia_sof_emb_data_lines;
> +
> +       u32 smia_emb_hstart;
> +       u32 smia_emb_hsize;
> +       u32 smia_emb_vstart;
> +
> +       u32 smia_num_lines;
> +       u32 smia_emb_data_fifo;
> +
> +       u32 smia_fifo_fill_level;
> +       u32 notused_smia2[(0x1A40 - 0x1A3C) / 4];
> +
> +       u32 notused_smia3[(0x1A60 - 0x1A40) / 4];
> +       u32 notused_smia4[(0x1C00 - 0x1A60) / 4];
> +
> +       u32 mipi_ctrl;
> +       u32 mipi_status;
> +       u32 mipi_imsc;
> +       u32 mipi_ris;
> +       u32 mipi_mis;
> +       u32 mipi_icr;
> +       u32 mipi_isr;
> +       u32 mipi_cur_data_id;
> +       u32 mipi_img_data_sel;
> +       u32 mipi_add_data_sel_1;
> +       u32 mipi_add_data_sel_2;
> +       u32 mipi_add_data_sel_3;
> +       u32 mipi_add_data_sel_4;
> +       u32 mipi_add_data_fifo;
> +       u32 mipi_add_data_fill_level;
> +       u32 notused_mipi[(0x2000 - 0x1C3C) / 4];
> +
> +       u32 isp_afm_ctrl;
> +       u32 isp_afm_lt_a;
> +       u32 isp_afm_rb_a;
> +       u32 isp_afm_lt_b;
> +       u32 isp_afm_rb_b;
> +       u32 isp_afm_lt_c;
> +       u32 isp_afm_rb_c;
> +       u32 isp_afm_thres;
> +       u32 isp_afm_var_shift;
> +       u32 isp_afm_sum_a;
> +       u32 isp_afm_sum_b;
> +       u32 isp_afm_sum_c;
> +       u32 isp_afm_lum_a;
> +       u32 isp_afm_lum_b;
> +       u32 isp_afm_lum_c;
> +       u32 notused_ispafm[(0x2100 - 0x203C) / 4];
> +
> +       u32 isp_bp_ctrl;
> +       u32 isp_bp_cfg1;
> +       u32 isp_bp_cfg2;
> +       u32 isp_bp_number;
> +       u32 isp_bp_table_addr;
> +       u32 isp_bp_table_data;
> +       u32 isp_bp_new_number;
> +       u32 isp_bp_new_table[MRV_ISP_BP_NEW_TABLE_ARR_SIZE];
> +
> +       u32 notused_ispbp[(0x2200 - 0x213C) / 4];
> +
> +       u32 isp_lsc_ctrl;
> +       u32 isp_lsc_r_table_addr;
> +       u32 isp_lsc_g_table_addr;
> +       u32 isp_lsc_b_table_addr;
> +       u32 isp_lsc_r_table_data;
> +       u32 isp_lsc_g_table_data;
> +       u32 isp_lsc_b_table_data;
> +       u32 notused_isplsc1;
> +       u32 isp_lsc_xgrad_01;
> +       u32 isp_lsc_xgrad_23;
> +       u32 isp_lsc_xgrad_45;
> +       u32 isp_lsc_xgrad_67;
> +       u32 isp_lsc_ygrad_01;
> +       u32 isp_lsc_ygrad_23;
> +       u32 isp_lsc_ygrad_45;
> +       u32 isp_lsc_ygrad_67;
> +       u32 isp_lsc_xsize_01;
> +       u32 isp_lsc_xsize_23;
> +       u32 isp_lsc_xsize_45;
> +       u32 isp_lsc_xsize_67;
> +       u32 isp_lsc_ysize_01;
> +       u32 isp_lsc_ysize_23;
> +       u32 isp_lsc_ysize_45;
> +       u32 isp_lsc_ysize_67;
> +       u32 notused_isplsc2[(0x2300 - 0x2260) / 4];
> +
> +       u32 isp_is_ctrl;
> +       u32 isp_is_recenter;
> +
> +       u32 isp_is_h_offs;
> +       u32 isp_is_v_offs;
> +       u32 isp_is_h_size;
> +       u32 isp_is_v_size;
> +
> +       u32 isp_is_max_dx;
> +       u32 isp_is_max_dy;
> +       u32 isp_is_displace;
> +
> +       u32 isp_is_h_offs_shd;
> +       u32 isp_is_v_offs_shd;
> +       u32 isp_is_h_size_shd;
> +       u32 isp_is_v_size_shd;
> +       u32 notused_ispis4[(0x2400 - 0x2334) / 4];
> +
> +       u32 isp_hist_prop;
> +       u32 isp_hist_h_offs;
> +       u32 isp_hist_v_offs;
> +       u32 isp_hist_h_size;
> +       u32 isp_hist_v_size;
> +       u32 isp_hist_bin[MRV_ISP_HIST_BIN_ARR_SIZE];
> +       u32 notused_isphist[(0x2500-0x2454)/4];
> +
> +       u32 isp_filt_mode;
> +       u32 _notused_28[(0x2528 - 0x2504) / 4];
> +       u32 isp_filt_thresh_bl0;
> +       u32 isp_filt_thresh_bl1;
> +       u32 isp_filt_thresh_sh0;
> +       u32 isp_filt_thresh_sh1;
> +       u32 isp_filt_lum_weight;
> +       u32 isp_filt_fac_sh1;
> +       u32 isp_filt_fac_sh0;
> +       u32 isp_filt_fac_mid;
> +       u32 isp_filt_fac_bl0;
> +       u32 isp_filt_fac_bl1;
> +       u32 notused_ispfilt[(0x2580 - 0x2550) / 4];
> +
> +       u32 notused_ispcac[(0x2600 - 0x2580) / 4];
> +
> +       u32 isp_exp_ctrl;
> +       u32 isp_exp_h_offset;
> +       u32 isp_exp_v_offset;
> +       u32 isp_exp_h_size;
> +       u32 isp_exp_v_size;
> +       u32 isp_exp_mean_00;
> +       u32 isp_exp_mean_10;
> +       u32 isp_exp_mean_20;
> +       u32 isp_exp_mean_30;
> +       u32 isp_exp_mean_40;
> +       u32 isp_exp_mean_01;
> +       u32 isp_exp_mean_11;
> +       u32 isp_exp_mean_21;
> +       u32 isp_exp_mean_31;
> +       u32 isp_exp_mean_41;
> +       u32 isp_exp_mean_02;
> +       u32 isp_exp_mean_12;
> +       u32 isp_exp_mean_22;
> +       u32 isp_exp_mean_32;
> +       u32 isp_exp_mean_42;
> +       u32 isp_exp_mean_03;
> +       u32 isp_exp_mean_13;
> +       u32 isp_exp_mean_23;
> +       u32 isp_exp_mean_33;
> +       u32 isp_exp_mean_43;
> +       u32 isp_exp_mean_04;
> +       u32 isp_exp_mean_14;
> +       u32 isp_exp_mean_24;
> +       u32 isp_exp_mean_34;
> +       u32 isp_exp_mean_44;
> +       u32 notused_ispexp[(0x2700 - 0x2678) / 4];
> +
> +       u32 isp_bls_ctrl;
> +       u32 isp_bls_samples;
> +       u32 isp_bls_h1_start;
> +       u32 isp_bls_h1_stop;
> +       u32 isp_bls_v1_start;
> +       u32 isp_bls_v1_stop;
> +       u32 isp_bls_h2_start;
> +       u32 isp_bls_h2_stop;
> +       u32 isp_bls_v2_start;
> +       u32 isp_bls_v2_stop;
> +       u32 isp_bls_a_fixed;
> +       u32 isp_bls_b_fixed;
> +       u32 isp_bls_c_fixed;
> +       u32 isp_bls_d_fixed;
> +       u32 isp_bls_a_measured;
> +       u32 isp_bls_b_measured;
> +       u32 isp_bls_c_measured;
> +       u32 isp_bls_d_measured;
> +       u32 notused_ispbls2[(0x2800 - 0x2748) / 4];
> +};

Wow! What a big struct! Are you sure you need all of this to be confined into
the same struct? Also, please be nice with people that are reviewing your code
and better comment your code.
How do you expect us to understand something as obfuscated as:

	u32 notused_isphist[(0x2500-0x2454)/4];

And what kind of magic is "(0x2500-0x2454)/4" ?

> +
> +#define MRV_VI_CCLFDIS
> +#define MRV_VI_CCLFDIS_MASK 0x00000004
> +#define MRV_VI_CCLFDIS_SHIFT 2
> +#define MRV_VI_CCLFDIS_ENABLE  0
> +#define MRV_VI_CCLFDIS_DISABLE 1
> +
> +#define MRV_VI_CCLDISS
> +#define MRV_VI_CCLDISS_MASK 0x00000002
> +#define MRV_VI_CCLDISS_SHIFT 1
> +
> +#define MRV_REV_ID
> +#define MRV_REV_ID_MASK 0xFFFFFFFF
> +#define MRV_REV_ID_SHIFT 0
> +
> +#define MRV_VI_MIPI_CLK_ENABLE
> +#define MRV_VI_MIPI_CLK_ENABLE_MASK 0x00000800
> +#define MRV_VI_MIPI_CLK_ENABLE_SHIFT 11
> +
> +
> +#define MRV_VI_SMIA_CLK_ENABLE
> +#define MRV_VI_SMIA_CLK_ENABLE_MASK 0x00000400
> +#define MRV_VI_SMIA_CLK_ENABLE_SHIFT 10
> +#define MRV_VI_SIMP_CLK_ENABLE
> +#define MRV_VI_SIMP_CLK_ENABLE_MASK 0x00000200
> +#define MRV_VI_SIMP_CLK_ENABLE_SHIFT 9
> +
> +#define MRV_VI_IE_CLK_ENABLE
> +#define MRV_VI_IE_CLK_ENABLE_MASK 0x00000100
> +#define MRV_VI_IE_CLK_ENABLE_SHIFT 8
> +
> +#define MRV_VI_EMP_CLK_ENABLE_MASK 0
> +#define MRV_VI_MI_CLK_ENABLE
> +#define MRV_VI_MI_CLK_ENABLE_MASK 0x00000040
> +#define MRV_VI_MI_CLK_ENABLE_SHIFT 6
> +
> +#define MRV_VI_JPEG_CLK_ENABLE
> +#define MRV_VI_JPEG_CLK_ENABLE_MASK 0x00000020
> +#define MRV_VI_JPEG_CLK_ENABLE_SHIFT 5
> +#define MRV_VI_SRSZ_CLK_ENABLE
> +#define MRV_VI_SRSZ_CLK_ENABLE_MASK 0x00000010
> +#define MRV_VI_SRSZ_CLK_ENABLE_SHIFT 4
> +
> +#define MRV_VI_MRSZ_CLK_ENABLE
> +#define MRV_VI_MRSZ_CLK_ENABLE_MASK 0x00000008
> +#define MRV_VI_MRSZ_CLK_ENABLE_SHIFT 3
> +#define MRV_VI_CP_CLK_ENABLE
> +#define MRV_VI_CP_CLK_ENABLE_MASK 0x00000002
> +#define MRV_VI_CP_CLK_ENABLE_SHIFT 1
> +#define MRV_VI_ISP_CLK_ENABLE
> +#define MRV_VI_ISP_CLK_ENABLE_MASK 0x00000001
> +#define MRV_VI_ISP_CLK_ENABLE_SHIFT 0
> +
> +#define MRV_VI_ALL_CLK_ENABLE
> +#define MRV_VI_ALL_CLK_ENABLE_MASK \
> +(0 \
> +| MRV_VI_MIPI_CLK_ENABLE_MASK \
> +| MRV_VI_SMIA_CLK_ENABLE_MASK \
> +| MRV_VI_SIMP_CLK_ENABLE_MASK \
> +| MRV_VI_IE_CLK_ENABLE_MASK \
> +| MRV_VI_EMP_CLK_ENABLE_MASK \
> +| MRV_VI_MI_CLK_ENABLE_MASK \
> +| MRV_VI_JPEG_CLK_ENABLE_MASK \
> +| MRV_VI_SRSZ_CLK_ENABLE_MASK \
> +| MRV_VI_MRSZ_CLK_ENABLE_MASK \
> +| MRV_VI_CP_CLK_ENABLE_MASK \
> +| MRV_VI_ISP_CLK_ENABLE_MASK \
> +)
> +#define MRV_VI_ALL_CLK_ENABLE_SHIFT 0
> +
> +#define MRV_VI_MIPI_SOFT_RST
> +#define MRV_VI_MIPI_SOFT_RST_MASK 0x00000800
> +#define MRV_VI_MIPI_SOFT_RST_SHIFT 11
> +
> +#define MRV_VI_SMIA_SOFT_RST
> +#define MRV_VI_SMIA_SOFT_RST_MASK 0x00000400
> +#define MRV_VI_SMIA_SOFT_RST_SHIFT 10
> +#define MRV_VI_SIMP_SOFT_RST
> +#define MRV_VI_SIMP_SOFT_RST_MASK 0x00000200
> +#define MRV_VI_SIMP_SOFT_RST_SHIFT 9
> +
> +#define MRV_VI_IE_SOFT_RST
> +#define MRV_VI_IE_SOFT_RST_MASK 0x00000100
> +#define MRV_VI_IE_SOFT_RST_SHIFT 8
> +#define MRV_VI_MARVIN_RST
> +#define MRV_VI_MARVIN_RST_MASK 0x00000080
> +#define MRV_VI_MARVIN_RST_SHIFT 7
> +
> +#define MRV_VI_EMP_SOFT_RST_MASK 0
> +#define MRV_VI_MI_SOFT_RST
> +#define MRV_VI_MI_SOFT_RST_MASK 0x00000040
> +#define MRV_VI_MI_SOFT_RST_SHIFT 6
> +
> +#define MRV_VI_JPEG_SOFT_RST
> +#define MRV_VI_JPEG_SOFT_RST_MASK 0x00000020
> +#define MRV_VI_JPEG_SOFT_RST_SHIFT 5
> +#define MRV_VI_SRSZ_SOFT_RST
> +#define MRV_VI_SRSZ_SOFT_RST_MASK 0x00000010
> +#define MRV_VI_SRSZ_SOFT_RST_SHIFT 4
> +
> +#define MRV_VI_MRSZ_SOFT_RST
> +#define MRV_VI_MRSZ_SOFT_RST_MASK 0x00000008
> +#define MRV_VI_MRSZ_SOFT_RST_SHIFT 3
> +#define MRV_VI_YCS_SOFT_RST
> +#define MRV_VI_YCS_SOFT_RST_MASK 0x00000004
> +#define MRV_VI_YCS_SOFT_RST_SHIFT 2
> +#define MRV_VI_CP_SOFT_RST
> +#define MRV_VI_CP_SOFT_RST_MASK 0x00000002
> +#define MRV_VI_CP_SOFT_RST_SHIFT 1
> +#define MRV_VI_ISP_SOFT_RST
> +#define MRV_VI_ISP_SOFT_RST_MASK 0x00000001
> +#define MRV_VI_ISP_SOFT_RST_SHIFT 0
> +
> +#define MRV_VI_ALL_SOFT_RST
> +#define MRV_VI_ALL_SOFT_RST_MASK \
> +(0 \
> +| MRV_VI_MIPI_SOFT_RST_MASK \
> +| MRV_VI_SMIA_SOFT_RST_MASK \
> +| MRV_VI_SIMP_SOFT_RST_MASK \
> +| MRV_VI_IE_SOFT_RST_MASK \
> +| MRV_VI_EMP_SOFT_RST_MASK \
> +| MRV_VI_MI_SOFT_RST_MASK \
> +| MRV_VI_JPEG_SOFT_RST_MASK \
> +| MRV_VI_SRSZ_SOFT_RST_MASK \
> +| MRV_VI_MRSZ_SOFT_RST_MASK \
> +| MRV_VI_YCS_SOFT_RST_MASK \
> +| MRV_VI_CP_SOFT_RST_MASK \
> +| MRV_VI_ISP_SOFT_RST_MASK \
> +)
> +#define MRV_VI_ALL_SOFT_RST_SHIFT 0
> +
> +
> +#define MRV_VI_DMA_SPMUX
> +#define MRV_VI_DMA_SPMUX_MASK 0x00000800
> +#define MRV_VI_DMA_SPMUX_SHIFT 11
> +#define MRV_VI_DMA_SPMUX_CAM    0
> +#define MRV_VI_DMA_SPMUX_DMA    1
> +#define MRV_VI_DMA_IEMUX
> +#define MRV_VI_DMA_IEMUX_MASK 0x00000400
> +#define MRV_VI_DMA_IEMUX_SHIFT 10
> +#define MRV_VI_DMA_IEMUX_CAM    0
> +#define MRV_VI_DMA_IEMUX_DMA    1
> +#define MRV_IF_SELECT
> +#define MRV_IF_SELECT_MASK 0x00000300
> +#define MRV_IF_SELECT_SHIFT 8
> +#define MRV_IF_SELECT_PAR   0
> +#define MRV_IF_SELECT_SMIA  1
> +#define MRV_IF_SELECT_MIPI  2
> +#define MRV_VI_DMA_SWITCH
> +#define MRV_VI_DMA_SWITCH_MASK 0x00000070
> +#define MRV_VI_DMA_SWITCH_SHIFT 4
> +#define MRV_VI_DMA_SWITCH_SELF  0
> +#define MRV_VI_DMA_SWITCH_SI    1
> +#define MRV_VI_DMA_SWITCH_IE    2
> +#define MRV_VI_DMA_SWITCH_JPG   3
> +#define MRV_VI_CHAN_MODE
> +#define MRV_VI_CHAN_MODE_MASK 0x0000000C
> +#define MRV_VI_CHAN_MODE_SHIFT 2
> +
> +#define MRV_VI_CHAN_MODE_OFF     0x00
> +#define MRV_VI_CHAN_MODE_Y       0xFF
> +#define MRV_VI_CHAN_MODE_MP_RAW  0x01
> +#define MRV_VI_CHAN_MODE_MP      0x01
> +#define MRV_VI_CHAN_MODE_SP      0x02
> +#define MRV_VI_CHAN_MODE_MP_SP   0x03
> +
> +#define MRV_VI_MP_MUX
> +#define MRV_VI_MP_MUX_MASK 0x00000003
> +#define MRV_VI_MP_MUX_SHIFT 0
> +
> +#define MRV_VI_MP_MUX_JPGDIRECT  0x00
> +#define MRV_VI_MP_MUX_MP         0x01
> +#define MRV_VI_MP_MUX_RAW        0x01
> +#define MRV_VI_MP_MUX_JPEG       0x02
> +
> +#define MRV_IMGEFF_CFG_UPD
> +#define MRV_IMGEFF_CFG_UPD_MASK 0x00000010
> +#define MRV_IMGEFF_CFG_UPD_SHIFT 4
> +#define MRV_IMGEFF_EFFECT_MODE
> +#define MRV_IMGEFF_EFFECT_MODE_MASK 0x0000000E
> +#define MRV_IMGEFF_EFFECT_MODE_SHIFT 1
> +#define MRV_IMGEFF_EFFECT_MODE_GRAY      0
> +#define MRV_IMGEFF_EFFECT_MODE_NEGATIVE  1
> +#define MRV_IMGEFF_EFFECT_MODE_SEPIA     2
> +#define MRV_IMGEFF_EFFECT_MODE_COLOR_SEL 3
> +#define MRV_IMGEFF_EFFECT_MODE_EMBOSS    4
> +#define MRV_IMGEFF_EFFECT_MODE_SKETCH    5
> +#define MRV_IMGEFF_BYPASS_MODE
> +#define MRV_IMGEFF_BYPASS_MODE_MASK 0x00000001
> +#define MRV_IMGEFF_BYPASS_MODE_SHIFT 0
> +#define MRV_IMGEFF_BYPASS_MODE_PROCESS  1
> +#define MRV_IMGEFF_BYPASS_MODE_BYPASS   0
> +
> +#define MRV_IMGEFF_COLOR_THRESHOLD
> +#define MRV_IMGEFF_COLOR_THRESHOLD_MASK 0x0000FF00
> +#define MRV_IMGEFF_COLOR_THRESHOLD_SHIFT 8
> +#define MRV_IMGEFF_COLOR_SELECTION
> +#define MRV_IMGEFF_COLOR_SELECTION_MASK 0x00000007
> +#define MRV_IMGEFF_COLOR_SELECTION_SHIFT 0
> +#define MRV_IMGEFF_COLOR_SELECTION_RGB  0
> +#define MRV_IMGEFF_COLOR_SELECTION_B    1
> +#define MRV_IMGEFF_COLOR_SELECTION_G    2
> +#define MRV_IMGEFF_COLOR_SELECTION_BG   3
> +#define MRV_IMGEFF_COLOR_SELECTION_R    4
> +#define MRV_IMGEFF_COLOR_SELECTION_BR   5
> +#define MRV_IMGEFF_COLOR_SELECTION_GR   6
> +#define MRV_IMGEFF_COLOR_SELECTION_BGR  7
> +
> +#define MRV_IMGEFF_EMB_COEF_21_EN
> +#define MRV_IMGEFF_EMB_COEF_21_EN_MASK 0x00008000
> +#define MRV_IMGEFF_EMB_COEF_21_EN_SHIFT 15
> +#define MRV_IMGEFF_EMB_COEF_21
> +#define MRV_IMGEFF_EMB_COEF_21_MASK 0x00007000
> +#define MRV_IMGEFF_EMB_COEF_21_SHIFT 12
> +
> +#define MRV_IMGEFF_EMB_COEF_21_4
> +#define MRV_IMGEFF_EMB_COEF_21_4_MASK 0x0000F000
> +#define MRV_IMGEFF_EMB_COEF_21_4_SHIFT 12
> +#define MRV_IMGEFF_EMB_COEF_13_EN
> +#define MRV_IMGEFF_EMB_COEF_13_EN_MASK 0x00000800
> +#define MRV_IMGEFF_EMB_COEF_13_EN_SHIFT 11
> +#define MRV_IMGEFF_EMB_COEF_13
> +#define MRV_IMGEFF_EMB_COEF_13_MASK 0x00000700
> +#define MRV_IMGEFF_EMB_COEF_13_SHIFT 8
> +
> +#define MRV_IMGEFF_EMB_COEF_13_4
> +#define MRV_IMGEFF_EMB_COEF_13_4_MASK 0x00000F00
> +#define MRV_IMGEFF_EMB_COEF_13_4_SHIFT 8
> +#define MRV_IMGEFF_EMB_COEF_12_EN
> +#define MRV_IMGEFF_EMB_COEF_12_EN_MASK 0x00000080
> +#define MRV_IMGEFF_EMB_COEF_12_EN_SHIFT 7
> +#define MRV_IMGEFF_EMB_COEF_12
> +#define MRV_IMGEFF_EMB_COEF_12_MASK 0x00000070
> +#define MRV_IMGEFF_EMB_COEF_12_SHIFT 4
> +
> +#define MRV_IMGEFF_EMB_COEF_12_4
> +#define MRV_IMGEFF_EMB_COEF_12_4_MASK 0x000000F0
> +#define MRV_IMGEFF_EMB_COEF_12_4_SHIFT 4
> +#define MRV_IMGEFF_EMB_COEF_11_EN
> +#define MRV_IMGEFF_EMB_COEF_11_EN_MASK 0x00000008
> +#define MRV_IMGEFF_EMB_COEF_11_EN_SHIFT 3
> +#define MRV_IMGEFF_EMB_COEF_11
> +#define MRV_IMGEFF_EMB_COEF_11_MASK 0x00000007
> +#define MRV_IMGEFF_EMB_COEF_11_SHIFT 0
> +
> +#define MRV_IMGEFF_EMB_COEF_11_4
> +#define MRV_IMGEFF_EMB_COEF_11_4_MASK 0x0000000F
> +#define MRV_IMGEFF_EMB_COEF_11_4_SHIFT 0
> +
> +#define MRV_IMGEFF_EMB_COEF_32_EN
> +#define MRV_IMGEFF_EMB_COEF_32_EN_MASK 0x00008000
> +#define MRV_IMGEFF_EMB_COEF_32_EN_SHIFT 15
> +#define MRV_IMGEFF_EMB_COEF_32
> +#define MRV_IMGEFF_EMB_COEF_32_MASK 0x00007000
> +#define MRV_IMGEFF_EMB_COEF_32_SHIFT 12
> +
> +#define MRV_IMGEFF_EMB_COEF_32_4
> +#define MRV_IMGEFF_EMB_COEF_32_4_MASK 0x0000F000
> +#define MRV_IMGEFF_EMB_COEF_32_4_SHIFT 12
> +#define MRV_IMGEFF_EMB_COEF_31_EN
> +#define MRV_IMGEFF_EMB_COEF_31_EN_MASK 0x00000800
> +#define MRV_IMGEFF_EMB_COEF_31_EN_SHIFT 11
> +#define MRV_IMGEFF_EMB_COEF_31
> +#define MRV_IMGEFF_EMB_COEF_31_MASK 0x00000700
> +#define MRV_IMGEFF_EMB_COEF_31_SHIFT 8
> +
> +#define MRV_IMGEFF_EMB_COEF_31_4
> +#define MRV_IMGEFF_EMB_COEF_31_4_MASK 0x00000F00
> +#define MRV_IMGEFF_EMB_COEF_31_4_SHIFT 8
> +#define MRV_IMGEFF_EMB_COEF_23_EN
> +#define MRV_IMGEFF_EMB_COEF_23_EN_MASK 0x00000080
> +#define MRV_IMGEFF_EMB_COEF_23_EN_SHIFT 7
> +#define MRV_IMGEFF_EMB_COEF_23
> +#define MRV_IMGEFF_EMB_COEF_23_MASK 0x00000070
> +#define MRV_IMGEFF_EMB_COEF_23_SHIFT 4
> +
> +#define MRV_IMGEFF_EMB_COEF_23_4
> +#define MRV_IMGEFF_EMB_COEF_23_4_MASK 0x000000F0
> +#define MRV_IMGEFF_EMB_COEF_23_4_SHIFT 4
> +
> +#define MRV_IMGEFF_EMB_COEF_22_EN
> +#define MRV_IMGEFF_EMB_COEF_22_EN_MASK 0x00000008
> +#define MRV_IMGEFF_EMB_COEF_22_EN_SHIFT 3
> +#define MRV_IMGEFF_EMB_COEF_22
> +#define MRV_IMGEFF_EMB_COEF_22_MASK 0x00000007
> +#define MRV_IMGEFF_EMB_COEF_22_SHIFT 0
> +
> +#define MRV_IMGEFF_EMB_COEF_22_4
> +#define MRV_IMGEFF_EMB_COEF_22_4_MASK 0x0000000F
> +#define MRV_IMGEFF_EMB_COEF_22_4_SHIFT 0
> +
> +#define MRV_IMGEFF_SKET_COEF_13_EN
> +#define MRV_IMGEFF_SKET_COEF_13_EN_MASK 0x00008000
> +#define MRV_IMGEFF_SKET_COEF_13_EN_SHIFT 15
> +#define MRV_IMGEFF_SKET_COEF_13
> +#define MRV_IMGEFF_SKET_COEF_13_MASK 0x00007000
> +#define MRV_IMGEFF_SKET_COEF_13_SHIFT 12
> +
> +#define MRV_IMGEFF_SKET_COEF_13_4
> +#define MRV_IMGEFF_SKET_COEF_13_4_MASK 0x0000F000
> +#define MRV_IMGEFF_SKET_COEF_13_4_SHIFT 12
> +#define MRV_IMGEFF_SKET_COEF_12_EN
> +#define MRV_IMGEFF_SKET_COEF_12_EN_MASK 0x00000800
> +#define MRV_IMGEFF_SKET_COEF_12_EN_SHIFT 11
> +#define MRV_IMGEFF_SKET_COEF_12
> +#define MRV_IMGEFF_SKET_COEF_12_MASK 0x00000700
> +#define MRV_IMGEFF_SKET_COEF_12_SHIFT 8
> +
> +#define MRV_IMGEFF_SKET_COEF_12_4
> +#define MRV_IMGEFF_SKET_COEF_12_4_MASK 0x00000F00
> +#define MRV_IMGEFF_SKET_COEF_12_4_SHIFT 8
> +#define MRV_IMGEFF_SKET_COEF_11_EN
> +#define MRV_IMGEFF_SKET_COEF_11_EN_MASK 0x00000080
> +#define MRV_IMGEFF_SKET_COEF_11_EN_SHIFT 7
> +#define MRV_IMGEFF_SKET_COEF_11
> +#define MRV_IMGEFF_SKET_COEF_11_MASK 0x00000070
> +#define MRV_IMGEFF_SKET_COEF_11_SHIFT 4
> +
> +#define MRV_IMGEFF_SKET_COEF_11_4
> +#define MRV_IMGEFF_SKET_COEF_11_4_MASK 0x000000F0
> +#define MRV_IMGEFF_SKET_COEF_11_4_SHIFT 4
> +#define MRV_IMGEFF_EMB_COEF_33_EN
> +#define MRV_IMGEFF_EMB_COEF_33_EN_MASK 0x00000008
> +#define MRV_IMGEFF_EMB_COEF_33_EN_SHIFT 3
> +#define MRV_IMGEFF_EMB_COEF_33
> +#define MRV_IMGEFF_EMB_COEF_33_MASK 0x00000007
> +#define MRV_IMGEFF_EMB_COEF_33_SHIFT 0
> +
> +#define MRV_IMGEFF_EMB_COEF_33_4
> +#define MRV_IMGEFF_EMB_COEF_33_4_MASK 0x0000000F
> +#define MRV_IMGEFF_EMB_COEF_33_4_SHIFT 0
> +
> +#define MRV_IMGEFF_SKET_COEF_31_EN
> +#define MRV_IMGEFF_SKET_COEF_31_EN_MASK 0x00008000
> +#define MRV_IMGEFF_SKET_COEF_31_EN_SHIFT 15
> +#define MRV_IMGEFF_SKET_COEF_31
> +#define MRV_IMGEFF_SKET_COEF_31_MASK 0x00007000
> +#define MRV_IMGEFF_SKET_COEF_31_SHIFT 12
> +
> +#define MRV_IMGEFF_SKET_COEF_31_4
> +#define MRV_IMGEFF_SKET_COEF_31_4_MASK 0x0000F000
> +#define MRV_IMGEFF_SKET_COEF_31_4_SHIFT 12
> +#define MRV_IMGEFF_SKET_COEF_23_EN
> +#define MRV_IMGEFF_SKET_COEF_23_EN_MASK 0x00000800
> +#define MRV_IMGEFF_SKET_COEF_23_EN_SHIFT 11
> +#define MRV_IMGEFF_SKET_COEF_23
> +#define MRV_IMGEFF_SKET_COEF_23_MASK 0x00000700
> +#define MRV_IMGEFF_SKET_COEF_23_SHIFT 8
> +
> +#define MRV_IMGEFF_SKET_COEF_23_4
> +#define MRV_IMGEFF_SKET_COEF_23_4_MASK 0x00000F00
> +#define MRV_IMGEFF_SKET_COEF_23_4_SHIFT 8
> +#define MRV_IMGEFF_SKET_COEF_22_EN
> +#define MRV_IMGEFF_SKET_COEF_22_EN_MASK 0x00000080
> +#define MRV_IMGEFF_SKET_COEF_22_EN_SHIFT 7
> +#define MRV_IMGEFF_SKET_COEF_22
> +#define MRV_IMGEFF_SKET_COEF_22_MASK 0x00000070
> +#define MRV_IMGEFF_SKET_COEF_22_SHIFT 4
> +
> +#define MRV_IMGEFF_SKET_COEF_22_4
> +#define MRV_IMGEFF_SKET_COEF_22_4_MASK 0x000000F0
> +#define MRV_IMGEFF_SKET_COEF_22_4_SHIFT 4
> +#define MRV_IMGEFF_SKET_COEF_21_EN
> +#define MRV_IMGEFF_SKET_COEF_21_EN_MASK 0x00000008
> +#define MRV_IMGEFF_SKET_COEF_21_EN_SHIFT 3
> +#define MRV_IMGEFF_SKET_COEF_21
> +#define MRV_IMGEFF_SKET_COEF_21_MASK 0x00000007
> +#define MRV_IMGEFF_SKET_COEF_21_SHIFT 0
> +
> +#define MRV_IMGEFF_SKET_COEF_21_4
> +#define MRV_IMGEFF_SKET_COEF_21_4_MASK 0x0000000F
> +#define MRV_IMGEFF_SKET_COEF_21_4_SHIFT 0
> +
> +#define MRV_IMGEFF_SKET_COEF_33_EN
> +#define MRV_IMGEFF_SKET_COEF_33_EN_MASK 0x00000080
> +#define MRV_IMGEFF_SKET_COEF_33_EN_SHIFT 7
> +#define MRV_IMGEFF_SKET_COEF_33
> +#define MRV_IMGEFF_SKET_COEF_33_MASK 0x00000070
> +#define MRV_IMGEFF_SKET_COEF_33_SHIFT 4
> +
> +#define MRV_IMGEFF_SKET_COEF_33_4
> +#define MRV_IMGEFF_SKET_COEF_33_4_MASK 0x000000F0
> +#define MRV_IMGEFF_SKET_COEF_33_4_SHIFT 4
> +#define MRV_IMGEFF_SKET_COEF_32_EN
> +#define MRV_IMGEFF_SKET_COEF_32_EN_MASK 0x00000008
> +#define MRV_IMGEFF_SKET_COEF_32_EN_SHIFT 3
> +#define MRV_IMGEFF_SKET_COEF_32
> +#define MRV_IMGEFF_SKET_COEF_32_MASK 0x00000007
> +#define MRV_IMGEFF_SKET_COEF_32_SHIFT 0
> +
> +#define MRV_IMGEFF_SKET_COEF_32_4
> +#define MRV_IMGEFF_SKET_COEF_32_4_MASK 0x0000000F
> +#define MRV_IMGEFF_SKET_COEF_32_4_SHIFT 0
> +
> +#define MRV_IMGEFF_INCR_CR
> +#define MRV_IMGEFF_INCR_CR_MASK 0x0000FF00
> +#define MRV_IMGEFF_INCR_CR_SHIFT 8
> +#define MRV_IMGEFF_INCR_CB
> +#define MRV_IMGEFF_INCR_CB_MASK 0x000000FF
> +#define MRV_IMGEFF_INCR_CB_SHIFT 0
> +
> +#define MRV_IMGEFF_EFFECT_MODE_SHD
> +#define MRV_IMGEFF_EFFECT_MODE_SHD_MASK 0x0000000E
> +#define MRV_IMGEFF_EFFECT_MODE_SHD_SHIFT 1
> +
> +
> +#define MRV_SI_TRANSPARENCY_MODE
> +#define MRV_SI_TRANSPARENCY_MODE_MASK 0x00000004
> +#define MRV_SI_TRANSPARENCY_MODE_SHIFT 2
> +#define MRV_SI_TRANSPARENCY_MODE_DISABLED 1
> +#define MRV_SI_TRANSPARENCY_MODE_ENABLED  0
> +#define MRV_SI_REF_IMAGE
> +#define MRV_SI_REF_IMAGE_MASK 0x00000002
> +#define MRV_SI_REF_IMAGE_SHIFT 1
> +#define MRV_SI_REF_IMAGE_MEM   1
> +#define MRV_SI_REF_IMAGE_IE    0
> +#define MRV_SI_BYPASS_MODE
> +#define MRV_SI_BYPASS_MODE_MASK 0x00000001
> +#define MRV_SI_BYPASS_MODE_SHIFT 0
> +#define MRV_SI_BYPASS_MODE_BYPASS  0
> +#define MRV_SI_BYPASS_MODE_PROCESS 1
> +
> +#define MRV_SI_OFFSET_X
> +#define MRV_SI_OFFSET_X_MASK 0x00001FFE
> +#define MRV_SI_OFFSET_X_SHIFT 0
> +#define MRV_SI_OFFSET_X_MAX  0x00001FFE
> +
> +#define MRV_SI_OFFSET_Y
> +#define MRV_SI_OFFSET_Y_MASK 0x00000FFF
> +#define MRV_SI_OFFSET_Y_SHIFT 0
> +#define MRV_SI_OFFSET_Y_MAX  0x00000FFF
> +
> +#define MRV_SI_Y_COMP
> +#define MRV_SI_Y_COMP_MASK 0x000000FF
> +#define MRV_SI_Y_COMP_SHIFT 0
> +
> +#define MRV_SI_CB_COMP
> +#define MRV_SI_CB_COMP_MASK 0x000000FF
> +#define MRV_SI_CB_COMP_SHIFT 0
> +
> +#define MRV_SI_CR_COMP
> +#define MRV_SI_CR_COMP_MASK 0x000000FF
> +#define MRV_SI_CR_COMP_SHIFT 0
> +#define MRV_ISP_ISP_CSM_C_RANGE
> +#define MRV_ISP_ISP_CSM_C_RANGE_MASK 0x00004000
> +#define MRV_ISP_ISP_CSM_C_RANGE_SHIFT 14
> +#define MRV_ISP_ISP_CSM_C_RANGE_BT601  0
> +#define MRV_ISP_ISP_CSM_C_RANGE_FULL   1
> +
> +#define MRV_ISP_ISP_CSM_Y_RANGE
> +#define MRV_ISP_ISP_CSM_Y_RANGE_MASK 0x00002000
> +#define MRV_ISP_ISP_CSM_Y_RANGE_SHIFT 13
> +#define MRV_ISP_ISP_CSM_Y_RANGE_BT601  0
> +#define MRV_ISP_ISP_CSM_Y_RANGE_FULL   1
> +#define MRV_ISP_ISP_FLASH_MODE
> +#define MRV_ISP_ISP_FLASH_MODE_MASK 0x00001000
> +#define MRV_ISP_ISP_FLASH_MODE_SHIFT 12
> +#define MRV_ISP_ISP_FLASH_MODE_INDEP  0
> +#define MRV_ISP_ISP_FLASH_MODE_SYNC   1
> +#define MRV_ISP_ISP_GAMMA_OUT_ENABLE
> +#define MRV_ISP_ISP_GAMMA_OUT_ENABLE_MASK 0x00000800
> +#define MRV_ISP_ISP_GAMMA_OUT_ENABLE_SHIFT 11
> +
> +#define MRV_ISP_ISP_GEN_CFG_UPD
> +#define MRV_ISP_ISP_GEN_CFG_UPD_MASK 0x00000400
> +#define MRV_ISP_ISP_GEN_CFG_UPD_SHIFT 10
> +
> +#define MRV_ISP_ISP_CFG_UPD
> +#define MRV_ISP_ISP_CFG_UPD_MASK 0x00000200
> +#define MRV_ISP_ISP_CFG_UPD_SHIFT 9
> +
> +#define MRV_ISP_ISP_AWB_ENABLE
> +#define MRV_ISP_ISP_AWB_ENABLE_MASK 0x00000080
> +#define MRV_ISP_ISP_AWB_ENABLE_SHIFT 7
> +#define MRV_ISP_ISP_GAMMA_IN_ENABLE
> +#define MRV_ISP_ISP_GAMMA_IN_ENABLE_MASK 0x00000040
> +#define MRV_ISP_ISP_GAMMA_IN_ENABLE_SHIFT 6
> +
> +#define MRV_ISP_ISP_INFORM_ENABLE
> +#define MRV_ISP_ISP_INFORM_ENABLE_MASK 0x00000010
> +#define MRV_ISP_ISP_INFORM_ENABLE_SHIFT 4
> +#define MRV_ISP_ISP_MODE
> +#define MRV_ISP_ISP_MODE_MASK 0x0000000E
> +#define MRV_ISP_ISP_MODE_SHIFT 1
> +#define MRV_ISP_ISP_MODE_RAW    0
> +#define MRV_ISP_ISP_MODE_656    1
> +#define MRV_ISP_ISP_MODE_601    2
> +#define MRV_ISP_ISP_MODE_RGB    3
> +#define MRV_ISP_ISP_MODE_DATA   4
> +#define MRV_ISP_ISP_MODE_RGB656 5
> +#define MRV_ISP_ISP_MODE_RAW656 6
> +#define MRV_ISP_ISP_ENABLE
> +#define MRV_ISP_ISP_ENABLE_MASK 0x00000001
> +#define MRV_ISP_ISP_ENABLE_SHIFT 0
> +
> +#define MRV_ISP_INPUT_SELECTION
> +#define MRV_ISP_INPUT_SELECTION_MASK 0x00007000
> +#define MRV_ISP_INPUT_SELECTION_SHIFT 12
> +#define MRV_ISP_INPUT_SELECTION_12EXT  0
> +#define MRV_ISP_INPUT_SELECTION_10ZERO 1
> +#define MRV_ISP_INPUT_SELECTION_10MSB  2
> +#define MRV_ISP_INPUT_SELECTION_8ZERO  3
> +#define MRV_ISP_INPUT_SELECTION_8MSB   4
> +#define MRV_ISP_FIELD_SELECTION
> +#define MRV_ISP_FIELD_SELECTION_MASK 0x00000600
> +#define MRV_ISP_FIELD_SELECTION_SHIFT 9
> +#define MRV_ISP_FIELD_SELECTION_BOTH  0
> +#define MRV_ISP_FIELD_SELECTION_EVEN  1
> +#define MRV_ISP_FIELD_SELECTION_ODD   2
> +#define MRV_ISP_CCIR_SEQ
> +#define MRV_ISP_CCIR_SEQ_MASK 0x00000180
> +#define MRV_ISP_CCIR_SEQ_SHIFT 7
> +#define MRV_ISP_CCIR_SEQ_YCBYCR 0
> +#define MRV_ISP_CCIR_SEQ_YCRYCB 1
> +#define MRV_ISP_CCIR_SEQ_CBYCRY 2
> +#define MRV_ISP_CCIR_SEQ_CRYCBY 3
> +#define MRV_ISP_CONV_422
> +#define MRV_ISP_CONV_422_MASK 0x00000060
> +#define MRV_ISP_CONV_422_SHIFT  5
> +#define MRV_ISP_CONV_422_CO     0
> +#define MRV_ISP_CONV_422_INTER  1
> +#define MRV_ISP_CONV_422_NONCO  2
> +#define MRV_ISP_BAYER_PAT
> +#define MRV_ISP_BAYER_PAT_MASK 0x00000018
> +#define MRV_ISP_BAYER_PAT_SHIFT 3
> +#define MRV_ISP_BAYER_PAT_RG    0
> +#define MRV_ISP_BAYER_PAT_GR    1
> +#define MRV_ISP_BAYER_PAT_GB    2
> +#define MRV_ISP_BAYER_PAT_BG    3
> +#define MRV_ISP_VSYNC_POL
> +#define MRV_ISP_VSYNC_POL_MASK 0x00000004
> +#define MRV_ISP_VSYNC_POL_SHIFT 2
> +#define MRV_ISP_HSYNC_POL
> +#define MRV_ISP_HSYNC_POL_MASK 0x00000002
> +#define MRV_ISP_HSYNC_POL_SHIFT 1
> +#define MRV_ISP_SAMPLE_EDGE
> +#define MRV_ISP_SAMPLE_EDGE_MASK 0x00000001
> +#define MRV_ISP_SAMPLE_EDGE_SHIFT 0
> +
> +#define MRV_ISP_ACQ_H_OFFS
> +#define MRV_ISP_ACQ_H_OFFS_MASK 0x00003FFF
> +#define MRV_ISP_ACQ_H_OFFS_SHIFT 0
> +
> +#define MRV_ISP_ACQ_V_OFFS
> +#define MRV_ISP_ACQ_V_OFFS_MASK 0x00000FFF
> +#define MRV_ISP_ACQ_V_OFFS_SHIFT 0
> +
> +#define MRV_ISP_ACQ_H_SIZE
> +#define MRV_ISP_ACQ_H_SIZE_MASK 0x00003FFF
> +#define MRV_ISP_ACQ_H_SIZE_SHIFT 0
> +
> +#define MRV_ISP_ACQ_V_SIZE
> +#define MRV_ISP_ACQ_V_SIZE_MASK 0x00000FFF
> +#define MRV_ISP_ACQ_V_SIZE_SHIFT 0
> +
> +#define MRV_ISP_ACQ_NR_FRAMES
> +#define MRV_ISP_ACQ_NR_FRAMES_MASK 0x000003FF
> +#define MRV_ISP_ACQ_NR_FRAMES_SHIFT 0
> +#define MRV_ISP_ACQ_NR_FRAMES_MAX \
> +       (MRV_ISP_ACQ_NR_FRAMES_MASK >> MRV_ISP_ACQ_NR_FRAMES_SHIFT)
> +
> +#define MRV_ISP_GAMMA_DX_8
> +#define MRV_ISP_GAMMA_DX_8_MASK 0x70000000
> +#define MRV_ISP_GAMMA_DX_8_SHIFT 28
> +
> +#define MRV_ISP_GAMMA_DX_7
> +#define MRV_ISP_GAMMA_DX_7_MASK 0x07000000
> +#define MRV_ISP_GAMMA_DX_7_SHIFT 24
> +
> +#define MRV_ISP_GAMMA_DX_6
> +#define MRV_ISP_GAMMA_DX_6_MASK 0x00700000
> +#define MRV_ISP_GAMMA_DX_6_SHIFT 20
> +
> +#define MRV_ISP_GAMMA_DX_5
> +#define MRV_ISP_GAMMA_DX_5_MASK 0x00070000
> +#define MRV_ISP_GAMMA_DX_5_SHIFT 16
> +
> +#define MRV_ISP_GAMMA_DX_4
> +#define MRV_ISP_GAMMA_DX_4_MASK 0x00007000
> +#define MRV_ISP_GAMMA_DX_4_SHIFT 12
> +
> +#define MRV_ISP_GAMMA_DX_3
> +#define MRV_ISP_GAMMA_DX_3_MASK 0x00000700
> +#define MRV_ISP_GAMMA_DX_3_SHIFT 8
> +
> +#define MRV_ISP_GAMMA_DX_2
> +#define MRV_ISP_GAMMA_DX_2_MASK 0x00000070
> +#define MRV_ISP_GAMMA_DX_2_SHIFT 4
> +
> +#define MRV_ISP_GAMMA_DX_1
> +#define MRV_ISP_GAMMA_DX_1_MASK 0x00000007
> +#define MRV_ISP_GAMMA_DX_1_SHIFT 0
> +
> +#define MRV_ISP_GAMMA_DX_16
> +#define MRV_ISP_GAMMA_DX_16_MASK 0x70000000
> +#define MRV_ISP_GAMMA_DX_16_SHIFT 28
> +
> +#define MRV_ISP_GAMMA_DX_15
> +#define MRV_ISP_GAMMA_DX_15_MASK 0x07000000
> +#define MRV_ISP_GAMMA_DX_15_SHIFT 24
> +
> +#define MRV_ISP_GAMMA_DX_14
> +#define MRV_ISP_GAMMA_DX_14_MASK 0x00700000
> +#define MRV_ISP_GAMMA_DX_14_SHIFT 20
> +
> +#define MRV_ISP_GAMMA_DX_13
> +#define MRV_ISP_GAMMA_DX_13_MASK 0x00070000
> +#define MRV_ISP_GAMMA_DX_13_SHIFT 16
> +
> +#define MRV_ISP_GAMMA_DX_12
> +#define MRV_ISP_GAMMA_DX_12_MASK 0x00007000
> +#define MRV_ISP_GAMMA_DX_12_SHIFT 12
> +
> +#define MRV_ISP_GAMMA_DX_11
> +#define MRV_ISP_GAMMA_DX_11_MASK 0x00000700
> +#define MRV_ISP_GAMMA_DX_11_SHIFT 8
> +
> +#define MRV_ISP_GAMMA_DX_10
> +#define MRV_ISP_GAMMA_DX_10_MASK 0x00000070
> +#define MRV_ISP_GAMMA_DX_10_SHIFT 4
> +
> +#define MRV_ISP_GAMMA_DX_9
> +#define MRV_ISP_GAMMA_DX_9_MASK 0x00000007
> +#define MRV_ISP_GAMMA_DX_9_SHIFT 0
> +
> +#define MRV_ISP_GAMMA_Y
> +
> +#define MRV_ISP_GAMMA_Y_MASK 0x00000FFF
> +
> +#define MRV_ISP_GAMMA_Y_SHIFT 0
> +#define MRV_ISP_GAMMA_Y_MAX (MRV_ISP_GAMMA_Y_MASK >> MRV_ISP_GAMMA_Y_SHIFT)
> +
> +#define MRV_ISP_GAMMA_R_Y
> +#define MRV_ISP_GAMMA_R_Y_MASK  MRV_ISP_GAMMA_Y_MASK
> +#define MRV_ISP_GAMMA_R_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
> +
> +#define MRV_ISP_GAMMA_G_Y
> +#define MRV_ISP_GAMMA_G_Y_MASK  MRV_ISP_GAMMA_Y_MASK
> +#define MRV_ISP_GAMMA_G_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
> +
> +#define MRV_ISP_GAMMA_B_Y
> +#define MRV_ISP_GAMMA_B_Y_MASK  MRV_ISP_GAMMA_Y_MASK
> +#define MRV_ISP_GAMMA_B_Y_SHIFT MRV_ISP_GAMMA_Y_SHIFT
> +
> +#define MRV_ISP_AWB_MEAS_MODE
> +#define MRV_ISP_AWB_MEAS_MODE_MASK 0x80000000
> +#define MRV_ISP_AWB_MEAS_MODE_SHIFT 31
> +#define MRV_ISP_AWB_MAX_EN
> +#define MRV_ISP_AWB_MAX_EN_MASK 0x00000004
> +#define MRV_ISP_AWB_MAX_EN_SHIFT 2
> +#define MRV_ISP_AWB_MODE
> +#define MRV_ISP_AWB_MODE_MASK 0x00000003
> +#define MRV_ISP_AWB_MODE_SHIFT 0
> +#define MRV_ISP_AWB_MODE_MEAS   2
> +#define MRV_ISP_AWB_MODE_NOMEAS 0
> +
> +#define MRV_ISP_AWB_H_OFFS
> +#define MRV_ISP_AWB_H_OFFS_MASK 0x00000FFF
> +#define MRV_ISP_AWB_H_OFFS_SHIFT 0
> +
> +#define MRV_ISP_AWB_V_OFFS
> +#define MRV_ISP_AWB_V_OFFS_MASK 0x00000FFF
> +#define MRV_ISP_AWB_V_OFFS_SHIFT 0
> +
> +#define MRV_ISP_AWB_H_SIZE
> +#define MRV_ISP_AWB_H_SIZE_MASK 0x00001FFF
> +#define MRV_ISP_AWB_H_SIZE_SHIFT 0
> +
> +#define MRV_ISP_AWB_V_SIZE
> +#define MRV_ISP_AWB_V_SIZE_MASK 0x00000FFF
> +#define MRV_ISP_AWB_V_SIZE_SHIFT 0
> +
> +#define MRV_ISP_AWB_FRAMES
> +#define MRV_ISP_AWB_FRAMES_MASK 0x00000007
> +#define MRV_ISP_AWB_FRAMES_SHIFT 0
> +
> +#define MRV_ISP_AWB_REF_CR__MAX_R
> +#define MRV_ISP_AWB_REF_CR__MAX_R_MASK 0x0000FF00
> +#define MRV_ISP_AWB_REF_CR__MAX_R_SHIFT 8
> +#define MRV_ISP_AWB_REF_CB__MAX_B
> +#define MRV_ISP_AWB_REF_CB__MAX_B_MASK 0x000000FF
> +#define MRV_ISP_AWB_REF_CB__MAX_B_SHIFT 0
> +
> +#define MRV_ISP_AWB_MAX_Y
> +#define MRV_ISP_AWB_MAX_Y_MASK 0xFF000000
> +#define MRV_ISP_AWB_MAX_Y_SHIFT 24
> +
> +#define MRV_ISP_AWB_MIN_Y__MAX_G
> +#define MRV_ISP_AWB_MIN_Y__MAX_G_MASK 0x00FF0000
> +#define MRV_ISP_AWB_MIN_Y__MAX_G_SHIFT 16
> +
> +#define MRV_ISP_AWB_MAX_CSUM
> +#define MRV_ISP_AWB_MAX_CSUM_MASK 0x0000FF00
> +#define MRV_ISP_AWB_MAX_CSUM_SHIFT 8
> +#define MRV_ISP_AWB_MIN_C
> +#define MRV_ISP_AWB_MIN_C_MASK 0x000000FF
> +#define MRV_ISP_AWB_MIN_C_SHIFT 0
> +
> +#define MRV_ISP_AWB_GAIN_GR
> +#define MRV_ISP_AWB_GAIN_GR_MASK 0x03FF0000
> +#define MRV_ISP_AWB_GAIN_GR_SHIFT 16
> +#define MRV_ISP_AWB_GAIN_GR_MAX  (MRV_ISP_AWB_GAIN_GR_MASK >> \
> +                                 MRV_ISP_AWB_GAIN_GR_SHIFT)
> +#define MRV_ISP_AWB_GAIN_GB
> +#define MRV_ISP_AWB_GAIN_GB_MASK 0x000003FF
> +#define MRV_ISP_AWB_GAIN_GB_SHIFT 0
> +#define MRV_ISP_AWB_GAIN_GB_MAX  (MRV_ISP_AWB_GAIN_GB_MASK >> \
> +                                 MRV_ISP_AWB_GAIN_GB_SHIFT)
> +
> +#define MRV_ISP_AWB_GAIN_R
> +#define MRV_ISP_AWB_GAIN_R_MASK 0x03FF0000
> +#define MRV_ISP_AWB_GAIN_R_SHIFT 16
> +#define MRV_ISP_AWB_GAIN_R_MAX  (MRV_ISP_AWB_GAIN_R_MASK >> \
> +                                MRV_ISP_AWB_GAIN_R_SHIFT)
> +#define MRV_ISP_AWB_GAIN_B
> +#define MRV_ISP_AWB_GAIN_B_MASK 0x000003FF
> +#define MRV_ISP_AWB_GAIN_B_SHIFT 0
> +#define MRV_ISP_AWB_GAIN_B_MAX  (MRV_ISP_AWB_GAIN_B_MASK >> \
> +                                MRV_ISP_AWB_GAIN_B_SHIFT)
> +
> +#define MRV_ISP_AWB_WHITE_CNT
> +#define MRV_ISP_AWB_WHITE_CNT_MASK 0x03FFFFFF
> +#define MRV_ISP_AWB_WHITE_CNT_SHIFT 0
> +
> +#define MRV_ISP_AWB_MEAN_Y__G
> +#define MRV_ISP_AWB_MEAN_Y__G_MASK 0x00FF0000
> +#define MRV_ISP_AWB_MEAN_Y__G_SHIFT 16
> +#define MRV_ISP_AWB_MEAN_CB__B
> +#define MRV_ISP_AWB_MEAN_CB__B_MASK 0x0000FF00
> +#define MRV_ISP_AWB_MEAN_CB__B_SHIFT 8
> +#define MRV_ISP_AWB_MEAN_CR__R
> +#define MRV_ISP_AWB_MEAN_CR__R_MASK 0x000000FF
> +#define MRV_ISP_AWB_MEAN_CR__R_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_0
> +#define MRV_ISP_CC_COEFF_0_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_0_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_1
> +#define MRV_ISP_CC_COEFF_1_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_1_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_2
> +#define MRV_ISP_CC_COEFF_2_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_2_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_3
> +#define MRV_ISP_CC_COEFF_3_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_3_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_4
> +#define MRV_ISP_CC_COEFF_4_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_4_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_5
> +#define MRV_ISP_CC_COEFF_5_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_5_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_6
> +#define MRV_ISP_CC_COEFF_6_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_6_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_7
> +#define MRV_ISP_CC_COEFF_7_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_7_SHIFT 0
> +
> +#define MRV_ISP_CC_COEFF_8
> +#define MRV_ISP_CC_COEFF_8_MASK 0x000001FF
> +#define MRV_ISP_CC_COEFF_8_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_H_OFFS
> +#define MRV_ISP_ISP_OUT_H_OFFS_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_H_OFFS_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_V_OFFS
> +#define MRV_ISP_ISP_OUT_V_OFFS_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_V_OFFS_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_H_SIZE
> +#define MRV_ISP_ISP_OUT_H_SIZE_MASK 0x00003FFF
> +#define MRV_ISP_ISP_OUT_H_SIZE_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_V_SIZE
> +#define MRV_ISP_ISP_OUT_V_SIZE_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_V_SIZE_SHIFT 0
> +
> +#define MRV_ISP_DEMOSAIC_BYPASS
> +#define MRV_ISP_DEMOSAIC_BYPASS_MASK 0x00000400
> +#define MRV_ISP_DEMOSAIC_BYPASS_SHIFT 10
> +
> +#define MRV_ISP_DEMOSAIC_MODE
> +#define MRV_ISP_DEMOSAIC_MODE_MASK  0x00000300
> +#define MRV_ISP_DEMOSAIC_MODE_SHIFT 8
> +#define MRV_ISP_DEMOSAIC_MODE_STD   0
> +#define MRV_ISP_DEMOSAIC_MODE_ENH   1
> +#define MRV_ISP_DEMOSAIC_TH
> +#define MRV_ISP_DEMOSAIC_TH_MASK 0x000000FF
> +#define MRV_ISP_DEMOSAIC_TH_SHIFT 0
> +
> +#define MRV_ISP_S_HSYNC
> +#define MRV_ISP_S_HSYNC_MASK 0x80000000
> +#define MRV_ISP_S_HSYNC_SHIFT 31
> +
> +#define MRV_ISP_S_VSYNC
> +#define MRV_ISP_S_VSYNC_MASK 0x40000000
> +#define MRV_ISP_S_VSYNC_SHIFT 30
> +
> +#define MRV_ISP_S_DATA
> +#define MRV_ISP_S_DATA_MASK 0x0FFF0000
> +
> +#define MRV_ISP_S_DATA_SHIFT 16
> +#define MRV_ISP_INFORM_FIELD
> +#define MRV_ISP_INFORM_FIELD_MASK 0x00000004
> +#define MRV_ISP_INFORM_FIELD_SHIFT 2
> +#define MRV_ISP_INFORM_FIELD_ODD   0
> +#define MRV_ISP_INFORM_FIELD_EVEN  1
> +#define MRV_ISP_INFORM_EN_SHD
> +#define MRV_ISP_INFORM_EN_SHD_MASK 0x00000002
> +#define MRV_ISP_INFORM_EN_SHD_SHIFT 1
> +#define MRV_ISP_ISP_ON_SHD
> +#define MRV_ISP_ISP_ON_SHD_MASK 0x00000001
> +#define MRV_ISP_ISP_ON_SHD_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_H_OFFS_SHD
> +#define MRV_ISP_ISP_OUT_H_OFFS_SHD_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_H_OFFS_SHD_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_V_OFFS_SHD
> +#define MRV_ISP_ISP_OUT_V_OFFS_SHD_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_V_OFFS_SHD_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_H_SIZE_SHD
> +#define MRV_ISP_ISP_OUT_H_SIZE_SHD_MASK 0x00003FFF
> +#define MRV_ISP_ISP_OUT_H_SIZE_SHD_SHIFT 0
> +
> +#define MRV_ISP_ISP_OUT_V_SIZE_SHD
> +#define MRV_ISP_ISP_OUT_V_SIZE_SHD_MASK 0x00000FFF
> +#define MRV_ISP_ISP_OUT_V_SIZE_SHD_SHIFT 0
> +
> +#define MRV_ISP_IMSC_EXP_END
> +#define MRV_ISP_IMSC_EXP_END_MASK 0x00040000
> +#define MRV_ISP_IMSC_EXP_END_SHIFT 18
> +
> +#define MRV_ISP_IMSC_FLASH_CAP
> +#define MRV_ISP_IMSC_FLASH_CAP_MASK 0x00020000
> +#define MRV_ISP_IMSC_FLASH_CAP_SHIFT 17
> +
> +#define MRV_ISP_IMSC_BP_DET
> +#define MRV_ISP_IMSC_BP_DET_MASK 0x00010000
> +#define MRV_ISP_IMSC_BP_DET_SHIFT 16
> +#define MRV_ISP_IMSC_BP_NEW_TAB_FUL
> +#define MRV_ISP_IMSC_BP_NEW_TAB_FUL_MASK 0x00008000
> +#define MRV_ISP_IMSC_BP_NEW_TAB_FUL_SHIFT 15
> +#define MRV_ISP_IMSC_AFM_FIN
> +#define MRV_ISP_IMSC_AFM_FIN_MASK 0x00004000
> +#define MRV_ISP_IMSC_AFM_FIN_SHIFT 14
> +#define MRV_ISP_IMSC_AFM_LUM_OF
> +#define MRV_ISP_IMSC_AFM_LUM_OF_MASK 0x00002000
> +#define MRV_ISP_IMSC_AFM_LUM_OF_SHIFT 13
> +#define MRV_ISP_IMSC_AFM_SUM_OF
> +#define MRV_ISP_IMSC_AFM_SUM_OF_MASK 0x00001000
> +#define MRV_ISP_IMSC_AFM_SUM_OF_SHIFT 12
> +#define MRV_ISP_IMSC_SHUTTER_OFF
> +#define MRV_ISP_IMSC_SHUTTER_OFF_MASK 0x00000800
> +#define MRV_ISP_IMSC_SHUTTER_OFF_SHIFT 11
> +#define MRV_ISP_IMSC_SHUTTER_ON
> +#define MRV_ISP_IMSC_SHUTTER_ON_MASK 0x00000400
> +#define MRV_ISP_IMSC_SHUTTER_ON_SHIFT 10
> +#define MRV_ISP_IMSC_FLASH_OFF
> +#define MRV_ISP_IMSC_FLASH_OFF_MASK 0x00000200
> +#define MRV_ISP_IMSC_FLASH_OFF_SHIFT 9
> +#define MRV_ISP_IMSC_FLASH_ON
> +#define MRV_ISP_IMSC_FLASH_ON_MASK 0x00000100
> +#define MRV_ISP_IMSC_FLASH_ON_SHIFT 8
> +
> +#define MRV_ISP_IMSC_H_START
> +#define MRV_ISP_IMSC_H_START_MASK 0x00000080
> +#define MRV_ISP_IMSC_H_START_SHIFT 7
> +#define MRV_ISP_IMSC_V_START
> +#define MRV_ISP_IMSC_V_START_MASK 0x00000040
> +#define MRV_ISP_IMSC_V_START_SHIFT 6
> +#define MRV_ISP_IMSC_FRAME_IN
> +#define MRV_ISP_IMSC_FRAME_IN_MASK 0x00000020
> +#define MRV_ISP_IMSC_FRAME_IN_SHIFT 5
> +#define MRV_ISP_IMSC_AWB_DONE
> +#define MRV_ISP_IMSC_AWB_DONE_MASK 0x00000010
> +#define MRV_ISP_IMSC_AWB_DONE_SHIFT 4
> +#define MRV_ISP_IMSC_PIC_SIZE_ERR
> +#define MRV_ISP_IMSC_PIC_SIZE_ERR_MASK 0x00000008
> +#define MRV_ISP_IMSC_PIC_SIZE_ERR_SHIFT 3
> +#define MRV_ISP_IMSC_DATA_LOSS
> +#define MRV_ISP_IMSC_DATA_LOSS_MASK 0x00000004
> +#define MRV_ISP_IMSC_DATA_LOSS_SHIFT 2
> +#define MRV_ISP_IMSC_FRAME
> +#define MRV_ISP_IMSC_FRAME_MASK 0x00000002
> +#define MRV_ISP_IMSC_FRAME_SHIFT 1
> +#define MRV_ISP_IMSC_ISP_OFF
> +#define MRV_ISP_IMSC_ISP_OFF_MASK 0x00000001
> +#define MRV_ISP_IMSC_ISP_OFF_SHIFT 0
> +
> +#define MRV_ISP_IMSC_ALL
> +#define MRV_ISP_IMSC_ALL_MASK \
> +(0 \
> +| MRV_ISP_IMSC_EXP_END_MASK \
> +| MRV_ISP_IMSC_FLASH_CAP_MASK \
> +| MRV_ISP_IMSC_BP_DET_MASK \
> +| MRV_ISP_IMSC_BP_NEW_TAB_FUL_MASK \
> +| MRV_ISP_IMSC_AFM_FIN_MASK \
> +| MRV_ISP_IMSC_AFM_LUM_OF_MASK \
> +| MRV_ISP_IMSC_AFM_SUM_OF_MASK \
> +| MRV_ISP_IMSC_SHUTTER_OFF_MASK \
> +| MRV_ISP_IMSC_SHUTTER_ON_MASK \
> +| MRV_ISP_IMSC_FLASH_OFF_MASK \
> +| MRV_ISP_IMSC_FLASH_ON_MASK \
> +| MRV_ISP_IMSC_H_START_MASK \
> +| MRV_ISP_IMSC_V_START_MASK \
> +| MRV_ISP_IMSC_FRAME_IN_MASK \
> +| MRV_ISP_IMSC_AWB_DONE_MASK \
> +| MRV_ISP_IMSC_PIC_SIZE_ERR_MASK \
> +| MRV_ISP_IMSC_DATA_LOSS_MASK \
> +| MRV_ISP_IMSC_FRAME_MASK \
> +| MRV_ISP_IMSC_ISP_OFF_MASK \
> +)
> +#define MRV_ISP_IMSC_ALL_SHIFT 0
> +
> +#define MRV_ISP_RIS_EXP_END
> +#define MRV_ISP_RIS_EXP_END_MASK 0x00040000
> +#define MRV_ISP_RIS_EXP_END_SHIFT 18
> +
> +#define MRV_ISP_RIS_FLASH_CAP
> +#define MRV_ISP_RIS_FLASH_CAP_MASK 0x00020000
> +#define MRV_ISP_RIS_FLASH_CAP_SHIFT 17
> +
> +#define MRV_ISP_RIS_BP_DET
> +#define MRV_ISP_RIS_BP_DET_MASK 0x00010000
> +#define MRV_ISP_RIS_BP_DET_SHIFT 16
> +#define MRV_ISP_RIS_BP_NEW_TAB_FUL
> +#define MRV_ISP_RIS_BP_NEW_TAB_FUL_MASK 0x00008000
> +#define MRV_ISP_RIS_BP_NEW_TAB_FUL_SHIFT 15
> +#define MRV_ISP_RIS_AFM_FIN
> +#define MRV_ISP_RIS_AFM_FIN_MASK 0x00004000
> +#define MRV_ISP_RIS_AFM_FIN_SHIFT 14
> +#define MRV_ISP_RIS_AFM_LUM_OF
> +#define MRV_ISP_RIS_AFM_LUM_OF_MASK 0x00002000
> +#define MRV_ISP_RIS_AFM_LUM_OF_SHIFT 13
> +#define MRV_ISP_RIS_AFM_SUM_OF
> +#define MRV_ISP_RIS_AFM_SUM_OF_MASK 0x00001000
> +#define MRV_ISP_RIS_AFM_SUM_OF_SHIFT 12
> +#define MRV_ISP_RIS_SHUTTER_OFF
> +#define MRV_ISP_RIS_SHUTTER_OFF_MASK 0x00000800
> +#define MRV_ISP_RIS_SHUTTER_OFF_SHIFT 11
> +#define MRV_ISP_RIS_SHUTTER_ON
> +#define MRV_ISP_RIS_SHUTTER_ON_MASK 0x00000400
> +#define MRV_ISP_RIS_SHUTTER_ON_SHIFT 10
> +#define MRV_ISP_RIS_FLASH_OFF
> +#define MRV_ISP_RIS_FLASH_OFF_MASK 0x00000200
> +#define MRV_ISP_RIS_FLASH_OFF_SHIFT 9
> +#define MRV_ISP_RIS_FLASH_ON
> +#define MRV_ISP_RIS_FLASH_ON_MASK 0x00000100
> +#define MRV_ISP_RIS_FLASH_ON_SHIFT 8
> +
> +#define MRV_ISP_RIS_H_START
> +#define MRV_ISP_RIS_H_START_MASK 0x00000080
> +#define MRV_ISP_RIS_H_START_SHIFT 7
> +#define MRV_ISP_RIS_V_START
> +#define MRV_ISP_RIS_V_START_MASK 0x00000040
> +#define MRV_ISP_RIS_V_START_SHIFT 6
> +#define MRV_ISP_RIS_FRAME_IN
> +#define MRV_ISP_RIS_FRAME_IN_MASK 0x00000020
> +#define MRV_ISP_RIS_FRAME_IN_SHIFT 5
> +#define MRV_ISP_RIS_AWB_DONE
> +#define MRV_ISP_RIS_AWB_DONE_MASK 0x00000010
> +#define MRV_ISP_RIS_AWB_DONE_SHIFT 4
> +#define MRV_ISP_RIS_PIC_SIZE_ERR
> +#define MRV_ISP_RIS_PIC_SIZE_ERR_MASK 0x00000008
> +#define MRV_ISP_RIS_PIC_SIZE_ERR_SHIFT 3
> +#define MRV_ISP_RIS_DATA_LOSS
> +#define MRV_ISP_RIS_DATA_LOSS_MASK 0x00000004
> +#define MRV_ISP_RIS_DATA_LOSS_SHIFT 2
> +#define MRV_ISP_RIS_FRAME
> +#define MRV_ISP_RIS_FRAME_MASK 0x00000002
> +#define MRV_ISP_RIS_FRAME_SHIFT 1
> +#define MRV_ISP_RIS_ISP_OFF
> +#define MRV_ISP_RIS_ISP_OFF_MASK 0x00000001
> +#define MRV_ISP_RIS_ISP_OFF_SHIFT 0
> +
> +#define MRV_ISP_RIS_ALL
> +#define MRV_ISP_RIS_ALL_MASK \
> +(0 \
> +| MRV_ISP_RIS_EXP_END_MASK \
> +| MRV_ISP_RIS_FLASH_CAP_MASK \
> +| MRV_ISP_RIS_BP_DET_MASK \
> +| MRV_ISP_RIS_BP_NEW_TAB_FUL_MASK \
> +| MRV_ISP_RIS_AFM_FIN_MASK \
> +| MRV_ISP_RIS_AFM_LUM_OF_MASK \
> +| MRV_ISP_RIS_AFM_SUM_OF_MASK \
> +| MRV_ISP_RIS_SHUTTER_OFF_MASK \
> +| MRV_ISP_RIS_SHUTTER_ON_MASK \
> +| MRV_ISP_RIS_FLASH_OFF_MASK \
> +| MRV_ISP_RIS_FLASH_ON_MASK \
> +| MRV_ISP_RIS_H_START_MASK \
> +| MRV_ISP_RIS_V_START_MASK \
> +| MRV_ISP_RIS_FRAME_IN_MASK \
> +| MRV_ISP_RIS_AWB_DONE_MASK \
> +| MRV_ISP_RIS_PIC_SIZE_ERR_MASK \
> +| MRV_ISP_RIS_DATA_LOSS_MASK \
> +| MRV_ISP_RIS_FRAME_MASK \
> +| MRV_ISP_RIS_ISP_OFF_MASK \
> +)
> +#define MRV_ISP_RIS_ALL_SHIFT 0
> +
> +#define MRV_ISP_MIS_EXP_END
> +#define MRV_ISP_MIS_EXP_END_MASK 0x00040000
> +#define MRV_ISP_MIS_EXP_END_SHIFT 18
> +
> +#define MRV_ISP_MIS_FLASH_CAP
> +#define MRV_ISP_MIS_FLASH_CAP_MASK 0x00020000
> +#define MRV_ISP_MIS_FLASH_CAP_SHIFT 17
> +
> +#define MRV_ISP_MIS_BP_DET
> +#define MRV_ISP_MIS_BP_DET_MASK 0x00010000
> +#define MRV_ISP_MIS_BP_DET_SHIFT 16
> +#define MRV_ISP_MIS_BP_NEW_TAB_FUL
> +#define MRV_ISP_MIS_BP_NEW_TAB_FUL_MASK 0x00008000
> +#define MRV_ISP_MIS_BP_NEW_TAB_FUL_SHIFT 15
> +#define MRV_ISP_MIS_AFM_FIN
> +#define MRV_ISP_MIS_AFM_FIN_MASK 0x00004000
> +#define MRV_ISP_MIS_AFM_FIN_SHIFT 14
> +#define MRV_ISP_MIS_AFM_LUM_OF
> +#define MRV_ISP_MIS_AFM_LUM_OF_MASK 0x00002000
> +#define MRV_ISP_MIS_AFM_LUM_OF_SHIFT 13
> +#define MRV_ISP_MIS_AFM_SUM_OF
> +#define MRV_ISP_MIS_AFM_SUM_OF_MASK 0x00001000
> +#define MRV_ISP_MIS_AFM_SUM_OF_SHIFT 12
> +#define MRV_ISP_MIS_SHUTTER_OFF
> +#define MRV_ISP_MIS_SHUTTER_OFF_MASK 0x00000800
> +#define MRV_ISP_MIS_SHUTTER_OFF_SHIFT 11
> +#define MRV_ISP_MIS_SHUTTER_ON
> +#define MRV_ISP_MIS_SHUTTER_ON_MASK 0x00000400
> +#define MRV_ISP_MIS_SHUTTER_ON_SHIFT 10
> +#define MRV_ISP_MIS_FLASH_OFF
> +#define MRV_ISP_MIS_FLASH_OFF_MASK 0x00000200
> +#define MRV_ISP_MIS_FLASH_OFF_SHIFT 9
> +#define MRV_ISP_MIS_FLASH_ON
> +#define MRV_ISP_MIS_FLASH_ON_MASK 0x00000100
> +#define MRV_ISP_MIS_FLASH_ON_SHIFT 8
> +
> +#define MRV_ISP_MIS_H_START
> +#define MRV_ISP_MIS_H_START_MASK 0x00000080
> +#define MRV_ISP_MIS_H_START_SHIFT 7
> +#define MRV_ISP_MIS_V_START
> +#define MRV_ISP_MIS_V_START_MASK 0x00000040
> +#define MRV_ISP_MIS_V_START_SHIFT 6
> +#define MRV_ISP_MIS_FRAME_IN
> +#define MRV_ISP_MIS_FRAME_IN_MASK 0x00000020
> +#define MRV_ISP_MIS_FRAME_IN_SHIFT 5
> +#define MRV_ISP_MIS_AWB_DONE
> +#define MRV_ISP_MIS_AWB_DONE_MASK 0x00000010
> +#define MRV_ISP_MIS_AWB_DONE_SHIFT 4
> +#define MRV_ISP_MIS_PIC_SIZE_ERR
> +#define MRV_ISP_MIS_PIC_SIZE_ERR_MASK 0x00000008
> +#define MRV_ISP_MIS_PIC_SIZE_ERR_SHIFT 3
> +#define MRV_ISP_MIS_DATA_LOSS
> +#define MRV_ISP_MIS_DATA_LOSS_MASK 0x00000004
> +#define MRV_ISP_MIS_DATA_LOSS_SHIFT 2
> +#define MRV_ISP_MIS_FRAME
> +#define MRV_ISP_MIS_FRAME_MASK 0x00000002
> +#define MRV_ISP_MIS_FRAME_SHIFT 1
> +#define MRV_ISP_MIS_ISP_OFF
> +#define MRV_ISP_MIS_ISP_OFF_MASK 0x00000001
> +#define MRV_ISP_MIS_ISP_OFF_SHIFT 0
> +
> +#define MRV_ISP_MIS_ALL
> +#define MRV_ISP_MIS_ALL_MASK \
> +(0 \
> +| MRV_ISP_MIS_EXP_END_MASK \
> +| MRV_ISP_MIS_FLASH_CAP_MASK \
> +| MRV_ISP_MIS_BP_DET_MASK \
> +| MRV_ISP_MIS_BP_NEW_TAB_FUL_MASK \
> +| MRV_ISP_MIS_AFM_FIN_MASK \
> +| MRV_ISP_MIS_AFM_LUM_OF_MASK \
> +| MRV_ISP_MIS_AFM_SUM_OF_MASK \
> +| MRV_ISP_MIS_SHUTTER_OFF_MASK \
> +| MRV_ISP_MIS_SHUTTER_ON_MASK \
> +| MRV_ISP_MIS_FLASH_OFF_MASK \
> +| MRV_ISP_MIS_FLASH_ON_MASK \
> +| MRV_ISP_MIS_H_START_MASK \
> +| MRV_ISP_MIS_V_START_MASK \
> +| MRV_ISP_MIS_FRAME_IN_MASK \
> +| MRV_ISP_MIS_AWB_DONE_MASK \
> +| MRV_ISP_MIS_PIC_SIZE_ERR_MASK \
> +| MRV_ISP_MIS_DATA_LOSS_MASK \
> +| MRV_ISP_MIS_FRAME_MASK \
> +| MRV_ISP_MIS_ISP_OFF_MASK \
> +)
> +#define MRV_ISP_MIS_ALL_SHIFT 0
> +
> +#define MRV_ISP_ICR_EXP_END
> +#define MRV_ISP_ICR_EXP_END_MASK 0x00040000
> +#define MRV_ISP_ICR_EXP_END_SHIFT 18
> +#define MRV_ISP_ICR_FLASH_CAP
> +#define MRV_ISP_ICR_FLASH_CAP_MASK 0x00020000
> +#define MRV_ISP_ICR_FLASH_CAP_SHIFT 17
> +
> +#define MRV_ISP_ICR_BP_DET
> +#define MRV_ISP_ICR_BP_DET_MASK 0x00010000
> +#define MRV_ISP_ICR_BP_DET_SHIFT 16
> +#define MRV_ISP_ICR_BP_NEW_TAB_FUL
> +#define MRV_ISP_ICR_BP_NEW_TAB_FUL_MASK 0x00008000
> +#define MRV_ISP_ICR_BP_NEW_TAB_FUL_SHIFT 15
> +#define MRV_ISP_ICR_AFM_FIN
> +#define MRV_ISP_ICR_AFM_FIN_MASK 0x00004000
> +#define MRV_ISP_ICR_AFM_FIN_SHIFT 14
> +#define MRV_ISP_ICR_AFM_LUM_OF
> +#define MRV_ISP_ICR_AFM_LUM_OF_MASK 0x00002000
> +#define MRV_ISP_ICR_AFM_LUM_OF_SHIFT 13
> +#define MRV_ISP_ICR_AFM_SUM_OF
> +#define MRV_ISP_ICR_AFM_SUM_OF_MASK 0x00001000
> +#define MRV_ISP_ICR_AFM_SUM_OF_SHIFT 12
> +#define MRV_ISP_ICR_SHUTTER_OFF
> +#define MRV_ISP_ICR_SHUTTER_OFF_MASK 0x00000800
> +#define MRV_ISP_ICR_SHUTTER_OFF_SHIFT 11
> +#define MRV_ISP_ICR_SHUTTER_ON
> +#define MRV_ISP_ICR_SHUTTER_ON_MASK 0x00000400
> +#define MRV_ISP_ICR_SHUTTER_ON_SHIFT 10
> +#define MRV_ISP_ICR_FLASH_OFF
> +#define MRV_ISP_ICR_FLASH_OFF_MASK 0x00000200
> +#define MRV_ISP_ICR_FLASH_OFF_SHIFT 9
> +#define MRV_ISP_ICR_FLASH_ON
> +#define MRV_ISP_ICR_FLASH_ON_MASK 0x00000100
> +#define MRV_ISP_ICR_FLASH_ON_SHIFT 8
> +
> +#define MRV_ISP_ICR_H_START
> +#define MRV_ISP_ICR_H_START_MASK 0x00000080
> +#define MRV_ISP_ICR_H_START_SHIFT 7
> +#define MRV_ISP_ICR_V_START
> +#define MRV_ISP_ICR_V_START_MASK 0x00000040
> +#define MRV_ISP_ICR_V_START_SHIFT 6
> +#define MRV_ISP_ICR_FRAME_IN
> +#define MRV_ISP_ICR_FRAME_IN_MASK 0x00000020
> +#define MRV_ISP_ICR_FRAME_IN_SHIFT 5
> +#define MRV_ISP_ICR_AWB_DONE
> +#define MRV_ISP_ICR_AWB_DONE_MASK 0x00000010
> +#define MRV_ISP_ICR_AWB_DONE_SHIFT 4
> +#define MRV_ISP_ICR_PIC_SIZE_ERR
> +#define MRV_ISP_ICR_PIC_SIZE_ERR_MASK 0x00000008
> +#define MRV_ISP_ICR_PIC_SIZE_ERR_SHIFT 3
> +#define MRV_ISP_ICR_DATA_LOSS
> +#define MRV_ISP_ICR_DATA_LOSS_MASK 0x00000004
> +#define MRV_ISP_ICR_DATA_LOSS_SHIFT 2
> +#define MRV_ISP_ICR_FRAME
> +#define MRV_ISP_ICR_FRAME_MASK 0x00000002
> +#define MRV_ISP_ICR_FRAME_SHIFT 1
> +#define MRV_ISP_ICR_ISP_OFF
> +#define MRV_ISP_ICR_ISP_OFF_MASK 0x00000001
> +#define MRV_ISP_ICR_ISP_OFF_SHIFT 0
> +
> +#define MRV_ISP_ICR_ALL
> +#define MRV_ISP_ICR_ALL_MASK \
> +(0 \
> +| MRV_ISP_ICR_EXP_END_MASK \
> +| MRV_ISP_ICR_FLASH_CAP_MASK \
> +| MRV_ISP_ICR_BP_DET_MASK \
> +| MRV_ISP_ICR_BP_NEW_TAB_FUL_MASK \
> +| MRV_ISP_ICR_AFM_FIN_MASK \
> +| MRV_ISP_ICR_AFM_LUM_OF_MASK \
> +| MRV_ISP_ICR_AFM_SUM_OF_MASK \
> +| MRV_ISP_ICR_SHUTTER_OFF_MASK \
> +| MRV_ISP_ICR_SHUTTER_ON_MASK \
> +| MRV_ISP_ICR_FLASH_OFF_MASK \
> +| MRV_ISP_ICR_FLASH_ON_MASK \
> +| MRV_ISP_ICR_H_START_MASK \
> +| MRV_ISP_ICR_V_START_MASK \
> +| MRV_ISP_ICR_FRAME_IN_MASK \
> +| MRV_ISP_ICR_AWB_DONE_MASK \
> +| MRV_ISP_ICR_PIC_SIZE_ERR_MASK \
> +| MRV_ISP_ICR_DATA_LOSS_MASK \
> +| MRV_ISP_ICR_FRAME_MASK \
> +| MRV_ISP_ICR_ISP_OFF_MASK \
> +)
> +#define MRV_ISP_ICR_ALL_SHIFT 0
> +
> +#define MRV_ISP_ISR_EXP_END
> +#define MRV_ISP_ISR_EXP_END_MASK 0x00040000
> +#define MRV_ISP_ISR_EXP_END_SHIFT 18
> +#define MRV_ISP_ISR_FLASH_CAP
> +#define MRV_ISP_ISR_FLASH_CAP_MASK 0x00020000
> +#define MRV_ISP_ISR_FLASH_CAP_SHIFT 17
> +
> +#define MRV_ISP_ISR_BP_DET
> +#define MRV_ISP_ISR_BP_DET_MASK 0x00010000
> +#define MRV_ISP_ISR_BP_DET_SHIFT 16
> +#define MRV_ISP_ISR_BP_NEW_TAB_FUL
> +#define MRV_ISP_ISR_BP_NEW_TAB_FUL_MASK 0x00008000
> +#define MRV_ISP_ISR_BP_NEW_TAB_FUL_SHIFT 15
> +#define MRV_ISP_ISR_AFM_FIN
> +#define MRV_ISP_ISR_AFM_FIN_MASK 0x00004000
> +#define MRV_ISP_ISR_AFM_FIN_SHIFT 14
> +#define MRV_ISP_ISR_AFM_LUM_OF
> +#define MRV_ISP_ISR_AFM_LUM_OF_MASK 0x00002000
> +#define MRV_ISP_ISR_AFM_LUM_OF_SHIFT 13
> +#define MRV_ISP_ISR_AFM_SUM_OF
> +#define MRV_ISP_ISR_AFM_SUM_OF_MASK 0x00001000
> +#define MRV_ISP_ISR_AFM_SUM_OF_SHIFT 12
> +#define MRV_ISP_ISR_SHUTTER_OFF
> +#define MRV_ISP_ISR_SHUTTER_OFF_MASK 0x00000800
> +#define MRV_ISP_ISR_SHUTTER_OFF_SHIFT 11
> +#define MRV_ISP_ISR_SHUTTER_ON
> +#define MRV_ISP_ISR_SHUTTER_ON_MASK 0x00000400
> +#define MRV_ISP_ISR_SHUTTER_ON_SHIFT 10
> +#define MRV_ISP_ISR_FLASH_OFF
> +#define MRV_ISP_ISR_FLASH_OFF_MASK 0x00000200
> +#define MRV_ISP_ISR_FLASH_OFF_SHIFT 9
> +#define MRV_ISP_ISR_FLASH_ON
> +#define MRV_ISP_ISR_FLASH_ON_MASK 0x00000100
> +#define MRV_ISP_ISR_FLASH_ON_SHIFT 8
> +
> +#define MRV_ISP_ISR_H_START
> +#define MRV_ISP_ISR_H_START_MASK 0x00000080
> +#define MRV_ISP_ISR_H_START_SHIFT 7
> +#define MRV_ISP_ISR_V_START
> +#define MRV_ISP_ISR_V_START_MASK 0x00000040
> +#define MRV_ISP_ISR_V_START_SHIFT 6
> +#define MRV_ISP_ISR_FRAME_IN
> +#define MRV_ISP_ISR_FRAME_IN_MASK 0x00000020
> +#define MRV_ISP_ISR_FRAME_IN_SHIFT 5
> +#define MRV_ISP_ISR_AWB_DONE
> +#define MRV_ISP_ISR_AWB_DONE_MASK 0x00000010
> +#define MRV_ISP_ISR_AWB_DONE_SHIFT 4
> +#define MRV_ISP_ISR_PIC_SIZE_ERR
> +#define MRV_ISP_ISR_PIC_SIZE_ERR_MASK 0x00000008
> +#define MRV_ISP_ISR_PIC_SIZE_ERR_SHIFT 3
> +#define MRV_ISP_ISR_DATA_LOSS
> +#define MRV_ISP_ISR_DATA_LOSS_MASK 0x00000004
> +#define MRV_ISP_ISR_DATA_LOSS_SHIFT 2
> +#define MRV_ISP_ISR_FRAME
> +#define MRV_ISP_ISR_FRAME_MASK 0x00000002
> +#define MRV_ISP_ISR_FRAME_SHIFT 1
> +#define MRV_ISP_ISR_ISP_OFF
> +#define MRV_ISP_ISR_ISP_OFF_MASK 0x00000001
> +#define MRV_ISP_ISR_ISP_OFF_SHIFT 0
> +
> +#define MRV_ISP_ISR_ALL
> +#define MRV_ISP_ISR_ALL_MASK \
> +(0 \
> +| MRV_ISP_ISR_EXP_END_MASK \
> +| MRV_ISP_ISR_FLASH_CAP_MASK \
> +| MRV_ISP_ISR_BP_DET_MASK \
> +| MRV_ISP_ISR_BP_NEW_TAB_FUL_MASK \
> +| MRV_ISP_ISR_AFM_FIN_MASK \
> +| MRV_ISP_ISR_AFM_LUM_OF_MASK \
> +| MRV_ISP_ISR_AFM_SUM_OF_MASK \
> +| MRV_ISP_ISR_SHUTTER_OFF_MASK \
> +| MRV_ISP_ISR_SHUTTER_ON_MASK \
> +| MRV_ISP_ISR_FLASH_OFF_MASK \
> +| MRV_ISP_ISR_FLASH_ON_MASK \
> +| MRV_ISP_ISR_H_START_MASK \
> +| MRV_ISP_ISR_V_START_MASK \
> +| MRV_ISP_ISR_FRAME_IN_MASK \
> +| MRV_ISP_ISR_AWB_DONE_MASK \
> +| MRV_ISP_ISR_PIC_SIZE_ERR_MASK \
> +| MRV_ISP_ISR_DATA_LOSS_MASK \
> +| MRV_ISP_ISR_FRAME_MASK \
> +| MRV_ISP_ISR_ISP_OFF_MASK \
> +)
> +#define MRV_ISP_ISR_ALL_SHIFT 0
> +
> +#define MRV_ISP_CT_COEFF
> +#define MRV_ISP_CT_COEFF_MASK 0x000007FF
> +#define MRV_ISP_CT_COEFF_SHIFT 0
> +#define MRV_ISP_CT_COEFF_MAX   (MRV_ISP_CT_COEFF_MASK >> MRV_ISP_CT_COEFF_SHIFT)
> +
> +#define MRV_ISP_EQU_SEGM
> +#define MRV_ISP_EQU_SEGM_MASK 0x00000001
> +#define MRV_ISP_EQU_SEGM_SHIFT 0
> +#define MRV_ISP_EQU_SEGM_LOG   0
> +#define MRV_ISP_EQU_SEGM_EQU   1
> +
> +#define MRV_ISP_ISP_GAMMA_OUT_Y
> +#define MRV_ISP_ISP_GAMMA_OUT_Y_MASK 0x000003FF
> +#define MRV_ISP_ISP_GAMMA_OUT_Y_SHIFT 0
> +
> +#define MRV_ISP_OUTFORM_SIZE_ERR
> +#define MRV_ISP_OUTFORM_SIZE_ERR_MASK 0x00000004
> +#define MRV_ISP_OUTFORM_SIZE_ERR_SHIFT 2
> +#define MRV_ISP_IS_SIZE_ERR
> +#define MRV_ISP_IS_SIZE_ERR_MASK 0x00000002
> +#define MRV_ISP_IS_SIZE_ERR_SHIFT 1
> +#define MRV_ISP_INFORM_SIZE_ERR
> +#define MRV_ISP_INFORM_SIZE_ERR_MASK 0x00000001
> +#define MRV_ISP_INFORM_SIZE_ERR_SHIFT 0
> +
> +#define MRV_ISP_ALL_ERR
> +#define MRV_ISP_ALL_ERR_MASK \
> +(0 \
> +| MRV_ISP_OUTFORM_SIZE_ERR_MASK \
> +| MRV_ISP_IS_SIZE_ERR_MASK      \
> +| MRV_ISP_INFORM_SIZE_ERR_MASK  \
> +)
> +#define MRV_ISP_ALL_ERR_SHIFT 0
> +
> +#define MRV_ISP_OUTFORM_SIZE_ERR_CLR
> +#define MRV_ISP_OUTFORM_SIZE_ERR_CLR_MASK 0x00000004
> +#define MRV_ISP_OUTFORM_SIZE_ERR_CLR_SHIFT 2
> +#define MRV_ISP_IS_SIZE_ERR_CLR
> +#define MRV_ISP_IS_SIZE_ERR_CLR_MASK 0x00000002
> +#define MRV_ISP_IS_SIZE_ERR_CLR_SHIFT 1
> +#define MRV_ISP_INFORM_SIZE_ERR_CLR
> +#define MRV_ISP_INFORM_SIZE_ERR_CLR_MASK 0x00000001
> +#define MRV_ISP_INFORM_SIZE_ERR_CLR_SHIFT 0
> +
> +
> +#define MRV_ISP_FRAME_COUNTER
> +#define MRV_ISP_FRAME_COUNTER_MASK 0x000003FF
> +#define MRV_ISP_FRAME_COUNTER_SHIFT 0
> +
> +#define MRV_ISP_CT_OFFSET_R
> +#define MRV_ISP_CT_OFFSET_R_MASK 0x00000FFF
> +#define MRV_ISP_CT_OFFSET_R_SHIFT 0
> +
> +#define MRV_ISP_CT_OFFSET_G
> +#define MRV_ISP_CT_OFFSET_G_MASK 0x00000FFF
> +#define MRV_ISP_CT_OFFSET_G_SHIFT 0
> +
> +#define MRV_ISP_CT_OFFSET_B
> +#define MRV_ISP_CT_OFFSET_B_MASK 0x00000FFF
> +#define MRV_ISP_CT_OFFSET_B_SHIFT 0
> +
> +#define MRV_RSZ_SCALE
> +#define MRV_RSZ_SCALE_MASK 0x00003FFF
> +
> +#define MRV_RSZ_SCALE_SHIFT 0
> +#define MRV_RSZ_SCALE_MAX (MRV_RSZ_SCALE_MASK >> MRV_RSZ_SCALE_SHIFT)
> +
> +#define MRV_MRSZ_CFG_UPD
> +#define MRV_MRSZ_CFG_UPD_MASK 0x00000100
> +#define MRV_MRSZ_CFG_UPD_SHIFT 8
> +#define MRV_MRSZ_SCALE_VC_UP
> +#define MRV_MRSZ_SCALE_VC_UP_MASK 0x00000080
> +#define MRV_MRSZ_SCALE_VC_UP_SHIFT 7
> +#define MRV_MRSZ_SCALE_VC_UP_UPSCALE   1
> +#define MRV_MRSZ_SCALE_VC_UP_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_VY_UP
> +#define MRV_MRSZ_SCALE_VY_UP_MASK 0x00000040
> +#define MRV_MRSZ_SCALE_VY_UP_SHIFT 6
> +#define MRV_MRSZ_SCALE_VY_UP_UPSCALE   1
> +#define MRV_MRSZ_SCALE_VY_UP_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_HC_UP
> +#define MRV_MRSZ_SCALE_HC_UP_MASK 0x00000020
> +#define MRV_MRSZ_SCALE_HC_UP_SHIFT 5
> +#define MRV_MRSZ_SCALE_HC_UP_UPSCALE   1
> +#define MRV_MRSZ_SCALE_HC_UP_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_HY_UP
> +#define MRV_MRSZ_SCALE_HY_UP_MASK 0x00000010
> +#define MRV_MRSZ_SCALE_HY_UP_SHIFT 4
> +#define MRV_MRSZ_SCALE_HY_UP_UPSCALE   1
> +#define MRV_MRSZ_SCALE_HY_UP_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_VC_ENABLE
> +#define MRV_MRSZ_SCALE_VC_ENABLE_MASK 0x00000008
> +#define MRV_MRSZ_SCALE_VC_ENABLE_SHIFT 3
> +#define MRV_MRSZ_SCALE_VY_ENABLE
> +#define MRV_MRSZ_SCALE_VY_ENABLE_MASK 0x00000004
> +#define MRV_MRSZ_SCALE_VY_ENABLE_SHIFT 2
> +#define MRV_MRSZ_SCALE_HC_ENABLE
> +#define MRV_MRSZ_SCALE_HC_ENABLE_MASK 0x00000002
> +#define MRV_MRSZ_SCALE_HC_ENABLE_SHIFT 1
> +#define MRV_MRSZ_SCALE_HY_ENABLE
> +#define MRV_MRSZ_SCALE_HY_ENABLE_MASK 0x00000001
> +#define MRV_MRSZ_SCALE_HY_ENABLE_SHIFT 0
> +
> +#define MRV_MRSZ_SCALE_HY
> +#define MRV_MRSZ_SCALE_HY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_HCB
> +#define MRV_MRSZ_SCALE_HCB_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HCB_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_HCR
> +#define MRV_MRSZ_SCALE_HCR_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HCR_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_VY
> +#define MRV_MRSZ_SCALE_VY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_VC
> +#define MRV_MRSZ_SCALE_VC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_HY
> +#define MRV_MRSZ_PHASE_HY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_HC
> +#define MRV_MRSZ_PHASE_HC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_HC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_VY
> +#define MRV_MRSZ_PHASE_VY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_VC
> +#define MRV_MRSZ_PHASE_VC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_LUT_ADDR
> +#define MRV_MRSZ_SCALE_LUT_ADDR_MASK 0x0000003F
> +#define MRV_MRSZ_SCALE_LUT_ADDR_SHIFT 0
> +
> +#define MRV_MRSZ_SCALE_LUT
> +#define MRV_MRSZ_SCALE_LUT_MASK 0x0000003F
> +#define MRV_MRSZ_SCALE_LUT_SHIFT 0
> +
> +#define MRV_MRSZ_SCALE_VC_UP_SHD
> +#define MRV_MRSZ_SCALE_VC_UP_SHD_MASK 0x00000080
> +#define MRV_MRSZ_SCALE_VC_UP_SHD_SHIFT 7
> +#define MRV_MRSZ_SCALE_VC_UP_SHD_UPSCALE   1
> +#define MRV_MRSZ_SCALE_VC_UP_SHD_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_VY_UP_SHD
> +#define MRV_MRSZ_SCALE_VY_UP_SHD_MASK 0x00000040
> +#define MRV_MRSZ_SCALE_VY_UP_SHD_SHIFT 6
> +#define MRV_MRSZ_SCALE_VY_UP_SHD_UPSCALE   1
> +#define MRV_MRSZ_SCALE_VY_UP_SHD_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_HC_UP_SHD
> +#define MRV_MRSZ_SCALE_HC_UP_SHD_MASK 0x00000020
> +#define MRV_MRSZ_SCALE_HC_UP_SHD_SHIFT 5
> +#define MRV_MRSZ_SCALE_HC_UP_SHD_UPSCALE   1
> +#define MRV_MRSZ_SCALE_HC_UP_SHD_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_HY_UP_SHD
> +#define MRV_MRSZ_SCALE_HY_UP_SHD_MASK 0x00000010
> +#define MRV_MRSZ_SCALE_HY_UP_SHD_SHIFT 4
> +#define MRV_MRSZ_SCALE_HY_UP_SHD_UPSCALE   1
> +#define MRV_MRSZ_SCALE_HY_UP_SHD_DOWNSCALE 0
> +#define MRV_MRSZ_SCALE_VC_ENABLE_SHD
> +#define MRV_MRSZ_SCALE_VC_ENABLE_SHD_MASK 0x00000008
> +#define MRV_MRSZ_SCALE_VC_ENABLE_SHD_SHIFT 3
> +#define MRV_MRSZ_SCALE_VY_ENABLE_SHD
> +#define MRV_MRSZ_SCALE_VY_ENABLE_SHD_MASK 0x00000004
> +#define MRV_MRSZ_SCALE_VY_ENABLE_SHD_SHIFT 2
> +#define MRV_MRSZ_SCALE_HC_ENABLE_SHD
> +#define MRV_MRSZ_SCALE_HC_ENABLE_SHD_MASK 0x00000002
> +#define MRV_MRSZ_SCALE_HC_ENABLE_SHD_SHIFT 1
> +#define MRV_MRSZ_SCALE_HY_ENABLE_SHD
> +#define MRV_MRSZ_SCALE_HY_ENABLE_SHD_MASK 0x00000001
> +#define MRV_MRSZ_SCALE_HY_ENABLE_SHD_SHIFT 0
> +
> +#define MRV_MRSZ_SCALE_HY_SHD
> +#define MRV_MRSZ_SCALE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_HCB_SHD
> +#define MRV_MRSZ_SCALE_HCB_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HCB_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_HCR_SHD
> +#define MRV_MRSZ_SCALE_HCR_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_HCR_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +
> +#define MRV_MRSZ_SCALE_VY_SHD
> +#define MRV_MRSZ_SCALE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_SCALE_VC_SHD
> +#define MRV_MRSZ_SCALE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_SCALE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_HY_SHD
> +#define MRV_MRSZ_PHASE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_HC_SHD
> +#define MRV_MRSZ_PHASE_HC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_HC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_VY_SHD
> +#define MRV_MRSZ_PHASE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MRSZ_PHASE_VC_SHD
> +#define MRV_MRSZ_PHASE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_MRSZ_PHASE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_CFG_UPD
> +#define MRV_SRSZ_CFG_UPD_MASK 0x00000100
> +#define MRV_SRSZ_CFG_UPD_SHIFT 8
> +#define MRV_SRSZ_SCALE_VC_UP
> +#define MRV_SRSZ_SCALE_VC_UP_MASK 0x00000080
> +#define MRV_SRSZ_SCALE_VC_UP_SHIFT 7
> +#define MRV_SRSZ_SCALE_VC_UP_UPSCALE   1
> +#define MRV_SRSZ_SCALE_VC_UP_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_VY_UP
> +#define MRV_SRSZ_SCALE_VY_UP_MASK 0x00000040
> +#define MRV_SRSZ_SCALE_VY_UP_SHIFT 6
> +#define MRV_SRSZ_SCALE_VY_UP_UPSCALE   1
> +#define MRV_SRSZ_SCALE_VY_UP_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_HC_UP
> +#define MRV_SRSZ_SCALE_HC_UP_MASK 0x00000020
> +#define MRV_SRSZ_SCALE_HC_UP_SHIFT 5
> +#define MRV_SRSZ_SCALE_HC_UP_UPSCALE   1
> +#define MRV_SRSZ_SCALE_HC_UP_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_HY_UP
> +#define MRV_SRSZ_SCALE_HY_UP_MASK 0x00000010
> +#define MRV_SRSZ_SCALE_HY_UP_SHIFT 4
> +#define MRV_SRSZ_SCALE_HY_UP_UPSCALE   1
> +#define MRV_SRSZ_SCALE_HY_UP_DOWNSCALE 0
> +
> +#define MRV_SRSZ_SCALE_VC_ENABLE
> +#define MRV_SRSZ_SCALE_VC_ENABLE_MASK 0x00000008
> +#define MRV_SRSZ_SCALE_VC_ENABLE_SHIFT 3
> +#define MRV_SRSZ_SCALE_VY_ENABLE
> +#define MRV_SRSZ_SCALE_VY_ENABLE_MASK 0x00000004
> +#define MRV_SRSZ_SCALE_VY_ENABLE_SHIFT 2
> +#define MRV_SRSZ_SCALE_HC_ENABLE
> +#define MRV_SRSZ_SCALE_HC_ENABLE_MASK 0x00000002
> +#define MRV_SRSZ_SCALE_HC_ENABLE_SHIFT 1
> +#define MRV_SRSZ_SCALE_HY_ENABLE
> +#define MRV_SRSZ_SCALE_HY_ENABLE_MASK 0x00000001
> +#define MRV_SRSZ_SCALE_HY_ENABLE_SHIFT 0
> +
> +#define MRV_SRSZ_SCALE_HY
> +#define MRV_SRSZ_SCALE_HY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_HCB
> +#define MRV_SRSZ_SCALE_HCB_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HCB_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_HCR
> +#define MRV_SRSZ_SCALE_HCR_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HCR_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_VY
> +#define MRV_SRSZ_SCALE_VY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_VC
> +#define MRV_SRSZ_SCALE_VC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_HY
> +#define MRV_SRSZ_PHASE_HY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_HY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_HC
> +#define MRV_SRSZ_PHASE_HC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_HC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_VY
> +#define MRV_SRSZ_PHASE_VY_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_VY_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_VC
> +#define MRV_SRSZ_PHASE_VC_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_VC_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_LUT_ADDR
> +#define MRV_SRSZ_SCALE_LUT_ADDR_MASK 0x0000003F
> +#define MRV_SRSZ_SCALE_LUT_ADDR_SHIFT 0
> +
> +#define MRV_SRSZ_SCALE_LUT
> +#define MRV_SRSZ_SCALE_LUT_MASK 0x0000003F
> +#define MRV_SRSZ_SCALE_LUT_SHIFT 0
> +
> +#define MRV_SRSZ_SCALE_VC_UP_SHD
> +#define MRV_SRSZ_SCALE_VC_UP_SHD_MASK 0x00000080
> +#define MRV_SRSZ_SCALE_VC_UP_SHD_SHIFT 7
> +#define MRV_SRSZ_SCALE_VC_UP_SHD_UPSCALE   1
> +#define MRV_SRSZ_SCALE_VC_UP_SHD_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_VY_UP_SHD
> +#define MRV_SRSZ_SCALE_VY_UP_SHD_MASK 0x00000040
> +#define MRV_SRSZ_SCALE_VY_UP_SHD_SHIFT 6
> +#define MRV_SRSZ_SCALE_VY_UP_SHD_UPSCALE   1
> +#define MRV_SRSZ_SCALE_VY_UP_SHD_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_HC_UP_SHD
> +#define MRV_SRSZ_SCALE_HC_UP_SHD_MASK 0x00000020
> +#define MRV_SRSZ_SCALE_HC_UP_SHD_SHIFT 5
> +#define MRV_SRSZ_SCALE_HC_UP_SHD_UPSCALE   1
> +#define MRV_SRSZ_SCALE_HC_UP_SHD_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_HY_UP_SHD
> +#define MRV_SRSZ_SCALE_HY_UP_SHD_MASK 0x00000010
> +#define MRV_SRSZ_SCALE_HY_UP_SHD_SHIFT 4
> +#define MRV_SRSZ_SCALE_HY_UP_SHD_UPSCALE   1
> +#define MRV_SRSZ_SCALE_HY_UP_SHD_DOWNSCALE 0
> +#define MRV_SRSZ_SCALE_VC_ENABLE_SHD
> +#define MRV_SRSZ_SCALE_VC_ENABLE_SHD_MASK 0x00000008
> +#define MRV_SRSZ_SCALE_VC_ENABLE_SHD_SHIFT 3
> +#define MRV_SRSZ_SCALE_VY_ENABLE_SHD
> +#define MRV_SRSZ_SCALE_VY_ENABLE_SHD_MASK 0x00000004
> +#define MRV_SRSZ_SCALE_VY_ENABLE_SHD_SHIFT 2
> +#define MRV_SRSZ_SCALE_HC_ENABLE_SHD
> +#define MRV_SRSZ_SCALE_HC_ENABLE_SHD_MASK 0x00000002
> +#define MRV_SRSZ_SCALE_HC_ENABLE_SHD_SHIFT 1
> +#define MRV_SRSZ_SCALE_HY_ENABLE_SHD
> +#define MRV_SRSZ_SCALE_HY_ENABLE_SHD_MASK 0x00000001
> +#define MRV_SRSZ_SCALE_HY_ENABLE_SHD_SHIFT 0
> +
> +#define MRV_SRSZ_SCALE_HY_SHD
> +#define MRV_SRSZ_SCALE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_HCB_SHD
> +#define MRV_SRSZ_SCALE_HCB_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HCB_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_HCR_SHD
> +#define MRV_SRSZ_SCALE_HCR_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_HCR_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_VY_SHD
> +#define MRV_SRSZ_SCALE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_SCALE_VC_SHD
> +#define MRV_SRSZ_SCALE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_SCALE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_HY_SHD
> +#define MRV_SRSZ_PHASE_HY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_HY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_HC_SHD
> +#define MRV_SRSZ_PHASE_HC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_HC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_VY_SHD
> +#define MRV_SRSZ_PHASE_VY_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_VY_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_SRSZ_PHASE_VC_SHD
> +#define MRV_SRSZ_PHASE_VC_SHD_MASK  MRV_RSZ_SCALE_MASK
> +#define MRV_SRSZ_PHASE_VC_SHD_SHIFT MRV_RSZ_SCALE_SHIFT
> +
> +#define MRV_MI_SP_OUTPUT_FORMAT
> +#define MRV_MI_SP_OUTPUT_FORMAT_MASK 0x70000000
> +#define MRV_MI_SP_OUTPUT_FORMAT_SHIFT 28
> +#define MRV_MI_SP_OUTPUT_FORMAT_RGB888 6
> +#define MRV_MI_SP_OUTPUT_FORMAT_RGB666 5
> +#define MRV_MI_SP_OUTPUT_FORMAT_RGB565 4
> +#define MRV_MI_SP_OUTPUT_FORMAT_YUV444 3
> +#define MRV_MI_SP_OUTPUT_FORMAT_YUV422 2
> +#define MRV_MI_SP_OUTPUT_FORMAT_YUV420 1
> +#define MRV_MI_SP_OUTPUT_FORMAT_YUV400 0
> +#define MRV_MI_SP_INPUT_FORMAT
> +#define MRV_MI_SP_INPUT_FORMAT_MASK 0x0C000000
> +#define MRV_MI_SP_INPUT_FORMAT_SHIFT 26
> +#define MRV_MI_SP_INPUT_FORMAT_YUV444 3
> +#define MRV_MI_SP_INPUT_FORMAT_YUV422 2
> +#define MRV_MI_SP_INPUT_FORMAT_YUV420 1
> +#define MRV_MI_SP_INPUT_FORMAT_YUV400 0
> +#define MRV_MI_SP_WRITE_FORMAT
> +#define MRV_MI_SP_WRITE_FORMAT_MASK 0x03000000
> +#define MRV_MI_SP_WRITE_FORMAT_SHIFT 24
> +#define MRV_MI_SP_WRITE_FORMAT_PLANAR      0
> +#define MRV_MI_SP_WRITE_FORMAT_SEMIPLANAR  1
> +#define MRV_MI_SP_WRITE_FORMAT_INTERLEAVED 2
> +#define MRV_MI_MP_WRITE_FORMAT
> +#define MRV_MI_MP_WRITE_FORMAT_MASK 0x00C00000
> +#define MRV_MI_MP_WRITE_FORMAT_SHIFT 22
> +#define MRV_MI_MP_WRITE_FORMAT_PLANAR      0
> +#define MRV_MI_MP_WRITE_FORMAT_SEMIPLANAR  1
> +#define MRV_MI_MP_WRITE_FORMAT_INTERLEAVED 2
> +#define MRV_MI_MP_WRITE_FORMAT_RAW_8       0
> +#define MRV_MI_MP_WRITE_FORMAT_RAW_12      2
> +#define MRV_MI_INIT_OFFSET_EN
> +#define MRV_MI_INIT_OFFSET_EN_MASK 0x00200000
> +#define MRV_MI_INIT_OFFSET_EN_SHIFT 21
> +
> +#define MRV_MI_INIT_BASE_EN
> +#define MRV_MI_INIT_BASE_EN_MASK 0x00100000
> +#define MRV_MI_INIT_BASE_EN_SHIFT 20
> +#define MRV_MI_BURST_LEN_CHROM
> +#define MRV_MI_BURST_LEN_CHROM_MASK 0x000C0000
> +#define MRV_MI_BURST_LEN_CHROM_SHIFT 18
> +#define MRV_MI_BURST_LEN_CHROM_4      0
> +#define MRV_MI_BURST_LEN_CHROM_8      1
> +#define MRV_MI_BURST_LEN_CHROM_16     2
> +
> +#define MRV_MI_BURST_LEN_LUM
> +#define MRV_MI_BURST_LEN_LUM_MASK 0x00030000
> +#define MRV_MI_BURST_LEN_LUM_SHIFT 16
> +#define MRV_MI_BURST_LEN_LUM_4      0
> +#define MRV_MI_BURST_LEN_LUM_8      1
> +#define MRV_MI_BURST_LEN_LUM_16     2
> +
> +#define MRV_MI_LAST_PIXEL_SIG_EN
> +#define MRV_MI_LAST_PIXEL_SIG_EN_MASK 0x00008000
> +#define MRV_MI_LAST_PIXEL_SIG_EN_SHIFT 15
> +
> +#define MRV_MI_422NONCOSITED
> +#define MRV_MI_422NONCOSITED_MASK 0x00000400
> +#define MRV_MI_422NONCOSITED_SHIFT 10
> +#define MRV_MI_CBCR_FULL_RANGE
> +#define MRV_MI_CBCR_FULL_RANGE_MASK 0x00000200
> +#define MRV_MI_CBCR_FULL_RANGE_SHIFT 9
> +#define MRV_MI_Y_FULL_RANGE
> +#define MRV_MI_Y_FULL_RANGE_MASK 0x00000100
> +#define MRV_MI_Y_FULL_RANGE_SHIFT 8
> +#define MRV_MI_BYTE_SWAP
> +#define MRV_MI_BYTE_SWAP_MASK 0x00000080
> +#define MRV_MI_BYTE_SWAP_SHIFT 7
> +#define MRV_MI_ROT
> +#define MRV_MI_ROT_MASK 0x00000040
> +#define MRV_MI_ROT_SHIFT 6
> +#define MRV_MI_V_FLIP
> +#define MRV_MI_V_FLIP_MASK 0x00000020
> +#define MRV_MI_V_FLIP_SHIFT 5
> +
> +#define MRV_MI_H_FLIP
> +#define MRV_MI_H_FLIP_MASK 0x00000010
> +#define MRV_MI_H_FLIP_SHIFT 4
> +#define MRV_MI_RAW_ENABLE
> +#define MRV_MI_RAW_ENABLE_MASK 0x00000008
> +#define MRV_MI_RAW_ENABLE_SHIFT 3
> +#define MRV_MI_JPEG_ENABLE
> +#define MRV_MI_JPEG_ENABLE_MASK 0x00000004
> +#define MRV_MI_JPEG_ENABLE_SHIFT 2
> +#define MRV_MI_SP_ENABLE
> +#define MRV_MI_SP_ENABLE_MASK 0x00000002
> +#define MRV_MI_SP_ENABLE_SHIFT 1
> +#define MRV_MI_MP_ENABLE
> +#define MRV_MI_MP_ENABLE_MASK 0x00000001
> +#define MRV_MI_MP_ENABLE_SHIFT 0
> +
> +
> +#define MRV_MI_ROT_AND_FLIP
> +#define MRV_MI_ROT_AND_FLIP_MASK   \
> +       (MRV_MI_H_FLIP_MASK | MRV_MI_V_FLIP_MASK | MRV_MI_ROT_MASK)
> +#define MRV_MI_ROT_AND_FLIP_SHIFT  \
> +       (MRV_MI_H_FLIP_SHIFT)
> +#define MRV_MI_ROT_AND_FLIP_H_FLIP \
> +       (MRV_MI_H_FLIP_MASK >> MRV_MI_ROT_AND_FLIP_SHIFT)
> +#define MRV_MI_ROT_AND_FLIP_V_FLIP \
> +       (MRV_MI_V_FLIP_MASK >> MRV_MI_ROT_AND_FLIP_SHIFT)
> +#define MRV_MI_ROT_AND_FLIP_ROTATE \
> +       (MRV_MI_ROT_MASK    >> MRV_MI_ROT_AND_FLIP_SHIFT)
> +
> +#define MRV_MI_MI_CFG_UPD
> +#define MRV_MI_MI_CFG_UPD_MASK 0x00000010
> +#define MRV_MI_MI_CFG_UPD_SHIFT 4
> +#define MRV_MI_MI_SKIP
> +#define MRV_MI_MI_SKIP_MASK 0x00000004
> +#define MRV_MI_MI_SKIP_SHIFT 2
> +
> +#define MRV_MI_MP_Y_BASE_AD_INIT
> +#define MRV_MI_MP_Y_BASE_AD_INIT_MASK 0xFFFFFFFC
> +#define MRV_MI_MP_Y_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_MP_Y_BASE_AD_INIT_VALID_MASK (MRV_MI_MP_Y_BASE_AD_INIT_MASK &\
> +                                            ~0x00000003)
> +#define MRV_MI_MP_Y_SIZE_INIT
> +#define MRV_MI_MP_Y_SIZE_INIT_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_SIZE_INIT_SHIFT 0
> +#define MRV_MI_MP_Y_SIZE_INIT_VALID_MASK (MRV_MI_MP_Y_SIZE_INIT_MASK &\
> +                                         ~0x00000003)
> +#define MRV_MI_MP_Y_OFFS_CNT_INIT
> +#define MRV_MI_MP_Y_OFFS_CNT_INIT_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_MP_Y_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_MP_Y_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_Y_OFFS_CNT_START
> +#define MRV_MI_MP_Y_OFFS_CNT_START_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_MP_Y_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_MP_Y_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_Y_IRQ_OFFS_INIT
> +#define MRV_MI_MP_Y_IRQ_OFFS_INIT_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_IRQ_OFFS_INIT_SHIFT 0
> +#define MRV_MI_MP_Y_IRQ_OFFS_INIT_VALID_MASK \
> +       (MRV_MI_MP_Y_IRQ_OFFS_INIT_MASK & ~0x00000003)
> +#define MRV_MI_MP_CB_BASE_AD_INIT
> +#define MRV_MI_MP_CB_BASE_AD_INIT_MASK 0xFFFFFFFC
> +#define MRV_MI_MP_CB_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_MP_CB_BASE_AD_INIT_VALID_MASK \
> +       (MRV_MI_MP_CB_BASE_AD_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_SIZE_INIT
> +#define MRV_MI_MP_CB_SIZE_INIT_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CB_SIZE_INIT_SHIFT 0
> +#define MRV_MI_MP_CB_SIZE_INIT_VALID_MASK \
> +       (MRV_MI_MP_CB_SIZE_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_OFFS_CNT_INIT
> +#define MRV_MI_MP_CB_OFFS_CNT_INIT_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CB_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_MP_CB_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_MP_CB_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_OFFS_CNT_START
> +#define MRV_MI_MP_CB_OFFS_CNT_START_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CB_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_MP_CB_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_MP_CB_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_BASE_AD_INIT
> +#define MRV_MI_MP_CR_BASE_AD_INIT_MASK 0xFFFFFFFC
> +#define MRV_MI_MP_CR_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_MP_CR_BASE_AD_INIT_VALID_MASK \
> +       (MRV_MI_MP_CR_BASE_AD_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_SIZE_INIT
> +#define MRV_MI_MP_CR_SIZE_INIT_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CR_SIZE_INIT_SHIFT 0
> +#define MRV_MI_MP_CR_SIZE_INIT_VALID_MASK \
> +       (MRV_MI_MP_CR_SIZE_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_OFFS_CNT_INIT
> +#define MRV_MI_MP_CR_OFFS_CNT_INIT_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CR_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_MP_CR_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_MP_CR_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_OFFS_CNT_START
> +#define MRV_MI_MP_CR_OFFS_CNT_START_MASK 0x00FFFFFC
> +#define MRV_MI_MP_CR_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_MP_CR_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_MP_CR_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_BASE_AD_INIT
> +#define MRV_MI_SP_Y_BASE_AD_INIT_MASK 0xFFFFFFFC
> +#define MRV_MI_SP_Y_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_SP_Y_BASE_AD_INIT_VALID_MASK \
> +       (MRV_MI_SP_Y_BASE_AD_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_SIZE_INIT
> +#define MRV_MI_SP_Y_SIZE_INIT_MASK 0x01FFFFFC
> +#define MRV_MI_SP_Y_SIZE_INIT_SHIFT 0
> +#define MRV_MI_SP_Y_SIZE_INIT_VALID_MASK \
> +       (MRV_MI_SP_Y_SIZE_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_OFFS_CNT_INIT
> +#define MRV_MI_SP_Y_OFFS_CNT_INIT_MASK 0x01FFFFFC
> +#define MRV_MI_SP_Y_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_SP_Y_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_SP_Y_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_OFFS_CNT_START
> +#define MRV_MI_SP_Y_OFFS_CNT_START_MASK 0x01FFFFFC
> +#define MRV_MI_SP_Y_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_SP_Y_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_SP_Y_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_LLENGTH
> +#define MRV_MI_SP_Y_LLENGTH_MASK 0x00001FFF
> +#define MRV_MI_SP_Y_LLENGTH_SHIFT 0
> +#define MRV_MI_SP_Y_LLENGTH_VALID_MASK \
> +       (MRV_MI_SP_Y_LLENGTH_MASK & ~0x00000000)
> +
> +#define MRV_MI_SP_CB_BASE_AD_INIT
> +#define MRV_MI_SP_CB_BASE_AD_INIT_MASK 0xFFFFFFFF
> +#define MRV_MI_SP_CB_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_SP_CB_BASE_AD_INIT_VALID_MASK \
> +       (MRV_MI_SP_CB_BASE_AD_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_SIZE_INIT
> +#define MRV_MI_SP_CB_SIZE_INIT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CB_SIZE_INIT_SHIFT 0
> +#define MRV_MI_SP_CB_SIZE_INIT_VALID_MASK \
> +       (MRV_MI_SP_CB_SIZE_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_OFFS_CNT_INIT
> +#define MRV_MI_SP_CB_OFFS_CNT_INIT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CB_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_SP_CB_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_SP_CB_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_OFFS_CNT_START
> +#define MRV_MI_SP_CB_OFFS_CNT_START_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CB_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_SP_CB_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_SP_CB_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_BASE_AD_INIT
> +#define MRV_MI_SP_CR_BASE_AD_INIT_MASK 0xFFFFFFFF
> +#define MRV_MI_SP_CR_BASE_AD_INIT_SHIFT 0
> +#define MRV_MI_SP_CR_BASE_AD_INIT_VALID_MASK \
> +       (MRV_MI_SP_CR_BASE_AD_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_SIZE_INIT
> +#define MRV_MI_SP_CR_SIZE_INIT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CR_SIZE_INIT_SHIFT 0
> +#define MRV_MI_SP_CR_SIZE_INIT_VALID_MASK \
> +       (MRV_MI_SP_CR_SIZE_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_OFFS_CNT_INIT
> +#define MRV_MI_SP_CR_OFFS_CNT_INIT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CR_OFFS_CNT_INIT_SHIFT 0
> +#define MRV_MI_SP_CR_OFFS_CNT_INIT_VALID_MASK \
> +       (MRV_MI_SP_CR_OFFS_CNT_INIT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_OFFS_CNT_START
> +#define MRV_MI_SP_CR_OFFS_CNT_START_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CR_OFFS_CNT_START_SHIFT 0
> +#define MRV_MI_SP_CR_OFFS_CNT_START_VALID_MASK \
> +       (MRV_MI_SP_CR_OFFS_CNT_START_MASK & ~0x00000003)
> +
> +#define MRV_MI_BYTE_CNT
> +#define MRV_MI_BYTE_CNT_MASK 0x01FFFFFF
> +#define MRV_MI_BYTE_CNT_SHIFT 0
> +
> +#define MRV_MI_RAW_ENABLE_OUT
> +#define MRV_MI_RAW_ENABLE_OUT_MASK 0x00080000
> +#define MRV_MI_RAW_ENABLE_OUT_SHIFT 19
> +#define MRV_MI_JPEG_ENABLE_OUT
> +#define MRV_MI_JPEG_ENABLE_OUT_MASK 0x00040000
> +#define MRV_MI_JPEG_ENABLE_OUT_SHIFT 18
> +#define MRV_MI_SP_ENABLE_OUT
> +#define MRV_MI_SP_ENABLE_OUT_MASK 0x00020000
> +#define MRV_MI_SP_ENABLE_OUT_SHIFT 17
> +#define MRV_MI_MP_ENABLE_OUT
> +#define MRV_MI_MP_ENABLE_OUT_MASK 0x00010000
> +#define MRV_MI_MP_ENABLE_OUT_SHIFT 16
> +#define MRV_MI_RAW_ENABLE_IN
> +#define MRV_MI_RAW_ENABLE_IN_MASK 0x00000020
> +#define MRV_MI_RAW_ENABLE_IN_SHIFT 5
> +#define MRV_MI_JPEG_ENABLE_IN
> +#define MRV_MI_JPEG_ENABLE_IN_MASK 0x00000010
> +#define MRV_MI_JPEG_ENABLE_IN_SHIFT 4
> +#define MRV_MI_SP_ENABLE_IN
> +#define MRV_MI_SP_ENABLE_IN_MASK 0x00000004
> +#define MRV_MI_SP_ENABLE_IN_SHIFT 2
> +#define MRV_MI_MP_ENABLE_IN
> +#define MRV_MI_MP_ENABLE_IN_MASK 0x00000001
> +#define MRV_MI_MP_ENABLE_IN_SHIFT 0
> +
> +#define MRV_MI_MP_Y_BASE_AD
> +#define MRV_MI_MP_Y_BASE_AD_MASK 0xFFFFFFFC
> +#define MRV_MI_MP_Y_BASE_AD_SHIFT 0
> +#define MRV_MI_MP_Y_BASE_AD_VALID_MASK \
> +       (MRV_MI_MP_Y_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_Y_SIZE
> +#define MRV_MI_MP_Y_SIZE_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_SIZE_SHIFT 0
> +#define MRV_MI_MP_Y_SIZE_VALID_MASK (MRV_MI_MP_Y_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_Y_OFFS_CNT
> +#define MRV_MI_MP_Y_OFFS_CNT_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_OFFS_CNT_SHIFT 0
> +#define MRV_MI_MP_Y_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_MP_Y_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_Y_IRQ_OFFS
> +#define MRV_MI_MP_Y_IRQ_OFFS_MASK 0x01FFFFFC
> +#define MRV_MI_MP_Y_IRQ_OFFS_SHIFT 0
> +#define MRV_MI_MP_Y_IRQ_OFFS_VALID_MASK \
> +       (MRV_MI_MP_Y_IRQ_OFFS_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_BASE_AD
> +#define MRV_MI_MP_CB_BASE_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_MP_CB_BASE_AD_SHIFT 0
> +#define MRV_MI_MP_CB_BASE_AD_VALID_MASK \
> +       (MRV_MI_MP_CB_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_SIZE
> +#define MRV_MI_MP_CB_SIZE_MASK 0x00FFFFFF
> +#define MRV_MI_MP_CB_SIZE_SHIFT 0
> +#define MRV_MI_MP_CB_SIZE_VALID_MASK (MRV_MI_MP_CB_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CB_OFFS_CNT
> +#define MRV_MI_MP_CB_OFFS_CNT_MASK 0x00FFFFFF
> +#define MRV_MI_MP_CB_OFFS_CNT_SHIFT 0
> +#define MRV_MI_MP_CB_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_MP_CB_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_BASE_AD
> +#define MRV_MI_MP_CR_BASE_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_MP_CR_BASE_AD_SHIFT 0
> +#define MRV_MI_MP_CR_BASE_AD_VALID_MASK \
> +       (MRV_MI_MP_CR_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_SIZE
> +#define MRV_MI_MP_CR_SIZE_MASK 0x00FFFFFF
> +#define MRV_MI_MP_CR_SIZE_SHIFT 0
> +#define MRV_MI_MP_CR_SIZE_VALID_MASK (MRV_MI_MP_CR_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_MP_CR_OFFS_CNT
> +#define MRV_MI_MP_CR_OFFS_CNT_MASK 0x00FFFFFF
> +#define MRV_MI_MP_CR_OFFS_CNT_SHIFT 0
> +#define MRV_MI_MP_CR_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_MP_CR_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_BASE_AD
> +#define MRV_MI_SP_Y_BASE_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_SP_Y_BASE_AD_SHIFT 0
> +#define MRV_MI_SP_Y_BASE_AD_VALID_MASK \
> +       (MRV_MI_SP_Y_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_SIZE
> +#define MRV_MI_SP_Y_SIZE_MASK 0x01FFFFFC
> +#define MRV_MI_SP_Y_SIZE_SHIFT 0
> +#define MRV_MI_SP_Y_SIZE_VALID_MASK (MRV_MI_SP_Y_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_Y_OFFS_CNT
> +#define MRV_MI_SP_Y_OFFS_CNT_MASK 0x01FFFFFC
> +#define MRV_MI_SP_Y_OFFS_CNT_SHIFT 0
> +#define MRV_MI_SP_Y_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_SP_Y_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_BASE_AD
> +#define MRV_MI_SP_CB_BASE_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_SP_CB_BASE_AD_SHIFT 0
> +#define MRV_MI_SP_CB_BASE_AD_VALID_MASK \
> +       (MRV_MI_SP_CB_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_SIZE
> +#define MRV_MI_SP_CB_SIZE_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CB_SIZE_SHIFT 0
> +#define MRV_MI_SP_CB_SIZE_VALID_MASK (MRV_MI_SP_CB_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CB_OFFS_CNT
> +#define MRV_MI_SP_CB_OFFS_CNT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CB_OFFS_CNT_SHIFT 0
> +#define MRV_MI_SP_CB_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_SP_CB_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_BASE_AD
> +#define MRV_MI_SP_CR_BASE_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_SP_CR_BASE_AD_SHIFT 0
> +#define MRV_MI_SP_CR_BASE_AD_VALID_MASK \
> +       (MRV_MI_SP_CR_BASE_AD_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_SIZE
> +#define MRV_MI_SP_CR_SIZE_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CR_SIZE_SHIFT 0
> +#define MRV_MI_SP_CR_SIZE_VALID_MASK (MRV_MI_SP_CR_SIZE_MASK & ~0x00000003)
> +
> +#define MRV_MI_SP_CR_OFFS_CNT
> +#define MRV_MI_SP_CR_OFFS_CNT_MASK 0x00FFFFFF
> +#define MRV_MI_SP_CR_OFFS_CNT_SHIFT 0
> +#define MRV_MI_SP_CR_OFFS_CNT_VALID_MASK \
> +       (MRV_MI_SP_CR_OFFS_CNT_MASK & ~0x00000003)
> +
> +#define MRV_MI_DMA_Y_PIC_START_AD
> +#define MRV_MI_DMA_Y_PIC_START_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_DMA_Y_PIC_START_AD_SHIFT 0
> +
> +#define MRV_MI_DMA_Y_PIC_WIDTH
> +#define MRV_MI_DMA_Y_PIC_WIDTH_MASK 0x00001FFF
> +#define MRV_MI_DMA_Y_PIC_WIDTH_SHIFT 0
> +
> +#define MRV_MI_DMA_Y_LLENGTH
> +#define MRV_MI_DMA_Y_LLENGTH_MASK 0x00001FFF
> +#define MRV_MI_DMA_Y_LLENGTH_SHIFT 0
> +
> +#define MRV_MI_DMA_Y_PIC_SIZE
> +#define MRV_MI_DMA_Y_PIC_SIZE_MASK 0x00FFFFFF
> +#define MRV_MI_DMA_Y_PIC_SIZE_SHIFT 0
> +
> +#define MRV_MI_DMA_CB_PIC_START_AD
> +#define MRV_MI_DMA_CB_PIC_START_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_DMA_CB_PIC_START_AD_SHIFT 0
> +
> +
> +#define MRV_MI_DMA_CR_PIC_START_AD
> +#define MRV_MI_DMA_CR_PIC_START_AD_MASK 0xFFFFFFFF
> +#define MRV_MI_DMA_CR_PIC_START_AD_SHIFT 0
> +
> +#define MRV_MI_DMA_READY
> +#define MRV_MI_DMA_READY_MASK 0x00000800
> +#define MRV_MI_DMA_READY_SHIFT 11
> +
> +#define MRV_MI_AHB_ERROR
> +
> +#define MRV_MI_AHB_ERROR_MASK 0x00000400
> +#define MRV_MI_AHB_ERROR_SHIFT 10
> +
> +#define MRV_MI_WRAP_SP_CR
> +#define MRV_MI_WRAP_SP_CR_MASK 0x00000200
> +#define MRV_MI_WRAP_SP_CR_SHIFT 9
> +#define MRV_MI_WRAP_SP_CB
> +
> +#define MRV_MI_WRAP_SP_CB_MASK 0x00000100
> +#define MRV_MI_WRAP_SP_CB_SHIFT 8
> +#define MRV_MI_WRAP_SP_Y
> +
> +#define MRV_MI_WRAP_SP_Y_MASK 0x00000080
> +#define MRV_MI_WRAP_SP_Y_SHIFT 7
> +#define MRV_MI_WRAP_MP_CR
> +
> +#define MRV_MI_WRAP_MP_CR_MASK 0x00000040
> +#define MRV_MI_WRAP_MP_CR_SHIFT 6
> +#define MRV_MI_WRAP_MP_CB
> +
> +#define MRV_MI_WRAP_MP_CB_MASK 0x00000020
> +#define MRV_MI_WRAP_MP_CB_SHIFT 5
> +#define MRV_MI_WRAP_MP_Y
> +
> +#define MRV_MI_WRAP_MP_Y_MASK 0x00000010
> +#define MRV_MI_WRAP_MP_Y_SHIFT 4
> +#define MRV_MI_FILL_MP_Y
> +
> +#define MRV_MI_FILL_MP_Y_MASK 0x00000008
> +#define MRV_MI_FILL_MP_Y_SHIFT 3
> +#define MRV_MI_MBLK_LINE
> +
> +#define MRV_MI_MBLK_LINE_MASK 0x00000004
> +#define MRV_MI_MBLK_LINE_SHIFT 2
> +#define MRV_MI_SP_FRAME_END
> +#define MRV_MI_SP_FRAME_END_MASK 0x00000002
> +#define MRV_MI_SP_FRAME_END_SHIFT 1
> +
> +#define MRV_MI_MP_FRAME_END
> +#define MRV_MI_MP_FRAME_END_MASK 0x00000001
> +#define MRV_MI_MP_FRAME_END_SHIFT 0
> +
> +#define MRV_MI_DMA_FRAME_END_MASK 0
> +
> +#define MRV_MI_ALLIRQS
> +#define MRV_MI_ALLIRQS_MASK \
> +(0 \
> +| MRV_MI_DMA_READY_MASK \
> +| MRV_MI_AHB_ERROR_MASK \
> +| MRV_MI_WRAP_SP_CR_MASK \
> +| MRV_MI_WRAP_SP_CB_MASK \
> +| MRV_MI_WRAP_SP_Y_MASK \
> +| MRV_MI_WRAP_MP_CR_MASK \
> +| MRV_MI_WRAP_MP_CB_MASK \
> +| MRV_MI_WRAP_MP_Y_MASK \
> +| MRV_MI_FILL_MP_Y_MASK \
> +| MRV_MI_MBLK_LINE_MASK \
> +| MRV_MI_SP_FRAME_END_MASK \
> +| MRV_MI_DMA_FRAME_END_MASK \
> +| MRV_MI_MP_FRAME_END_MASK \
> +)

Please properly indent it.

> +#define MRV_MI_ALLIRQS_SHIFT 0
> +
> +#define MRV_MI_AHB_READ_ERROR
> +#define MRV_MI_AHB_READ_ERROR_MASK 0x00000200
> +#define MRV_MI_AHB_READ_ERROR_SHIFT 9
> +#define MRV_MI_AHB_WRITE_ERROR
> +#define MRV_MI_AHB_WRITE_ERROR_MASK 0x00000100
> +#define MRV_MI_AHB_WRITE_ERROR_SHIFT 8
> +#define MRV_MI_SP_CR_FIFO_FULL
> +#define MRV_MI_SP_CR_FIFO_FULL_MASK 0x00000040
> +#define MRV_MI_SP_CR_FIFO_FULL_SHIFT 6
> +#define MRV_MI_SP_CB_FIFO_FULL
> +#define MRV_MI_SP_CB_FIFO_FULL_MASK 0x00000020
> +#define MRV_MI_SP_CB_FIFO_FULL_SHIFT 5
> +#define MRV_MI_SP_Y_FIFO_FULL
> +#define MRV_MI_SP_Y_FIFO_FULL_MASK 0x00000010
> +#define MRV_MI_SP_Y_FIFO_FULL_SHIFT 4
> +#define MRV_MI_MP_CR_FIFO_FULL
> +#define MRV_MI_MP_CR_FIFO_FULL_MASK 0x00000004
> +#define MRV_MI_MP_CR_FIFO_FULL_SHIFT 2
> +#define MRV_MI_MP_CB_FIFO_FULL
> +#define MRV_MI_MP_CB_FIFO_FULL_MASK 0x00000002
> +#define MRV_MI_MP_CB_FIFO_FULL_SHIFT 1
> +#define MRV_MI_MP_Y_FIFO_FULL
> +#define MRV_MI_MP_Y_FIFO_FULL_MASK 0x00000001
> +#define MRV_MI_MP_Y_FIFO_FULL_SHIFT 0
> +
> +
> +#define MRV_MI_ALL_STAT
> +#define MRV_MI_ALL_STAT_MASK \
> +(0 \
> +| MRV_MI_AHB_READ_ERROR_MASK  \
> +| MRV_MI_AHB_WRITE_ERROR_MASK \
> +| MRV_MI_SP_CR_FIFO_FULL_MASK \
> +| MRV_MI_SP_CB_FIFO_FULL_MASK \
> +| MRV_MI_SP_Y_FIFO_FULL_MASK  \
> +| MRV_MI_MP_CR_FIFO_FULL_MASK \
> +| MRV_MI_MP_CB_FIFO_FULL_MASK \
> +| MRV_MI_MP_Y_FIFO_FULL_MASK  \
> +)

Please properly indent it.

> +#define MRV_MI_ALL_STAT_SHIFT 0
> +
> +#define MRV_MI_SP_Y_PIC_WIDTH
> +#define MRV_MI_SP_Y_PIC_WIDTH_MASK 0x00000FFF
> +#define MRV_MI_SP_Y_PIC_WIDTH_SHIFT 0
> +
> +#define MRV_MI_SP_Y_PIC_HEIGHT
> +#define MRV_MI_SP_Y_PIC_HEIGHT_MASK 0x00000FFF
> +#define MRV_MI_SP_Y_PIC_HEIGHT_SHIFT 0
> +
> +#define MRV_MI_SP_Y_PIC_SIZE
> +#define MRV_MI_SP_Y_PIC_SIZE_MASK 0x01FFFFFF
> +#define MRV_MI_SP_Y_PIC_SIZE_SHIFT 0
> +
> +#define MRV_JPE_GEN_HEADER
> +#define MRV_JPE_GEN_HEADER_MASK 0x00000001
> +#define MRV_JPE_GEN_HEADER_SHIFT 0
> +
> +#define MRV_JPE_CONT_MODE
> +#define MRV_JPE_CONT_MODE_MASK 0x00000030
> +#define MRV_JPE_CONT_MODE_SHIFT 4
> +#define MRV_JPE_CONT_MODE_STOP   0
> +#define MRV_JPE_CONT_MODE_NEXT   1
> +#define MRV_JPE_CONT_MODE_HEADER 3
> +#define MRV_JPE_ENCODE
> +#define MRV_JPE_ENCODE_MASK 0x00000001
> +#define MRV_JPE_ENCODE_SHIFT 0
> +#define MRV_JPE_JP_INIT
> +#define MRV_JPE_JP_INIT_MASK 0x00000001
> +#define MRV_JPE_JP_INIT_SHIFT 0
> +
> +#define MRV_JPE_Y_SCALE_EN
> +#define MRV_JPE_Y_SCALE_EN_MASK 0x00000001
> +#define MRV_JPE_Y_SCALE_EN_SHIFT 0
> +
> +#define MRV_JPE_CBCR_SCALE_EN
> +#define MRV_JPE_CBCR_SCALE_EN_MASK 0x00000001
> +#define MRV_JPE_CBCR_SCALE_EN_SHIFT 0
> +
> +#define MRV_JPE_TABLE_FLUSH
> +#define MRV_JPE_TABLE_FLUSH_MASK 0x00000001
> +#define MRV_JPE_TABLE_FLUSH_SHIFT 0
> +
> +#define MRV_JPE_ENC_HSIZE
> +#define MRV_JPE_ENC_HSIZE_MASK 0x00001FFF
> +#define MRV_JPE_ENC_HSIZE_SHIFT 0
> +#define MRV_JPE_ENC_VSIZE
> +#define MRV_JPE_ENC_VSIZE_MASK 0x00000FFF
> +#define MRV_JPE_ENC_VSIZE_SHIFT 0
> +#define MRV_JPE_ENC_PIC_FORMAT
> +#define MRV_JPE_ENC_PIC_FORMAT_MASK 0x00000007
> +#define MRV_JPE_ENC_PIC_FORMAT_SHIFT 0
> +#define MRV_JPE_ENC_PIC_FORMAT_422 1
> +#define MRV_JPE_ENC_PIC_FORMAT_400 4
> +#define MRV_JPE_RESTART_INTERVAL
> +#define MRV_JPE_RESTART_INTERVAL_MASK 0x0000FFFF
> +#define MRV_JPE_RESTART_INTERVAL_SHIFT 0
> +#define MRV_JPE_TQ0_SELECT
> +#define MRV_JPE_TQ0_SELECT_MASK 0x00000003
> +#define MRV_JPE_TQ0_SELECT_SHIFT 0
> +#define MRV_JPE_TQ1_SELECT
> +#define MRV_JPE_TQ1_SELECT_MASK 0x00000003
> +#define MRV_JPE_TQ1_SELECT_SHIFT 0
> +#define MRV_JPE_TQ2_SELECT
> +#define MRV_JPE_TQ2_SELECT_MASK 0x00000003
> +#define MRV_JPE_TQ2_SELECT_SHIFT 0
> +#define MRV_JPE_TQ_SELECT_TAB3 3
> +#define MRV_JPE_TQ_SELECT_TAB2 2
> +#define MRV_JPE_TQ_SELECT_TAB1 1
> +#define MRV_JPE_TQ_SELECT_TAB0 0
> +
> +#define MRV_JPE_DC_TABLE_SELECT_Y
> +#define MRV_JPE_DC_TABLE_SELECT_Y_MASK 0x00000001
> +#define MRV_JPE_DC_TABLE_SELECT_Y_SHIFT 0
> +#define MRV_JPE_DC_TABLE_SELECT_U
> +#define MRV_JPE_DC_TABLE_SELECT_U_MASK 0x00000002
> +#define MRV_JPE_DC_TABLE_SELECT_U_SHIFT 1
> +#define MRV_JPE_DC_TABLE_SELECT_V
> +#define MRV_JPE_DC_TABLE_SELECT_V_MASK 0x00000004
> +#define MRV_JPE_DC_TABLE_SELECT_V_SHIFT 2
> +
> +#define MRV_JPE_AC_TABLE_SELECT_Y
> +#define MRV_JPE_AC_TABLE_SELECT_Y_MASK 0x00000001
> +#define MRV_JPE_AC_TABLE_SELECT_Y_SHIFT 0
> +#define MRV_JPE_AC_TABLE_SELECT_U
> +#define MRV_JPE_AC_TABLE_SELECT_U_MASK 0x00000002
> +#define MRV_JPE_AC_TABLE_SELECT_U_SHIFT 1
> +#define MRV_JPE_AC_TABLE_SELECT_V
> +#define MRV_JPE_AC_TABLE_SELECT_V_MASK 0x00000004
> +#define MRV_JPE_AC_TABLE_SELECT_V_SHIFT 2
> +
> +#define MRV_JPE_TABLE_WDATA_H
> +#define MRV_JPE_TABLE_WDATA_H_MASK 0x0000FF00
> +#define MRV_JPE_TABLE_WDATA_H_SHIFT 8
> +#define MRV_JPE_TABLE_WDATA_L
> +#define MRV_JPE_TABLE_WDATA_L_MASK 0x000000FF
> +#define MRV_JPE_TABLE_WDATA_L_SHIFT 0
> +
> +#define MRV_JPE_TABLE_ID
> +#define MRV_JPE_TABLE_ID_MASK 0x0000000F
> +#define MRV_JPE_TABLE_ID_SHIFT 0
> +#define MRV_JPE_TABLE_ID_QUANT0  0
> +#define MRV_JPE_TABLE_ID_QUANT1  1
> +#define MRV_JPE_TABLE_ID_QUANT2  2
> +#define MRV_JPE_TABLE_ID_QUANT3  3
> +#define MRV_JPE_TABLE_ID_VLC_DC0 4
> +#define MRV_JPE_TABLE_ID_VLC_AC0 5
> +#define MRV_JPE_TABLE_ID_VLC_DC1 6
> +#define MRV_JPE_TABLE_ID_VLC_AC1 7
> +
> +#define MRV_JPE_TAC0_LEN
> +#define MRV_JPE_TAC0_LEN_MASK 0x000000FF
> +#define MRV_JPE_TAC0_LEN_SHIFT 0
> +
> +#define MRV_JPE_TDC0_LEN
> +#define MRV_JPE_TDC0_LEN_MASK 0x000000FF
> +#define MRV_JPE_TDC0_LEN_SHIFT 0
> +
> +#define MRV_JPE_TAC1_LEN
> +#define MRV_JPE_TAC1_LEN_MASK 0x000000FF
> +#define MRV_JPE_TAC1_LEN_SHIFT 0
> +
> +#define MRV_JPE_TDC1_LEN
> +#define MRV_JPE_TDC1_LEN_MASK 0x000000FF
> +#define MRV_JPE_TDC1_LEN_SHIFT 0
> +
> +#define MRV_JPE_CODEC_BUSY
> +#define MRV_JPE_CODEC_BUSY_MASK 0x00000001
> +#define MRV_JPE_CODEC_BUSY_SHIFT 0
> +#define MRV_JPE_HEADER_MODE
> +#define MRV_JPE_HEADER_MODE_MASK 0x00000003
> +#define MRV_JPE_HEADER_MODE_SHIFT 0
> +#define MRV_JPE_HEADER_MODE_NO    0
> +#define MRV_JPE_HEADER_MODE_JFIF  2
> +#define MRV_JPE_ENCODE_MODE
> +#define MRV_JPE_ENCODE_MODE_MASK 0x00000001
> +#define MRV_JPE_ENCODE_MODE_SHIFT 0
> +
> +#define MRV_JPE_DEB_BAD_TABLE_ACCESS
> +#define MRV_JPE_DEB_BAD_TABLE_ACCESS_MASK 0x00000100
> +#define MRV_JPE_DEB_BAD_TABLE_ACCESS_SHIFT 8
> +#define MRV_JPE_DEB_VLC_TABLE_BUSY
> +#define MRV_JPE_DEB_VLC_TABLE_BUSY_MASK 0x00000020
> +#define MRV_JPE_DEB_VLC_TABLE_BUSY_SHIFT 5
> +#define MRV_JPE_DEB_R2B_MEMORY_FULL
> +#define MRV_JPE_DEB_R2B_MEMORY_FULL_MASK 0x00000010
> +#define MRV_JPE_DEB_R2B_MEMORY_FULL_SHIFT 4
> +#define MRV_JPE_DEB_VLC_ENCODE_BUSY
> +#define MRV_JPE_DEB_VLC_ENCODE_BUSY_MASK 0x00000008
> +#define MRV_JPE_DEB_VLC_ENCODE_BUSY_SHIFT 3
> +#define MRV_JPE_DEB_QIQ_TABLE_ACC
> +#define MRV_JPE_DEB_QIQ_TABLE_ACC_MASK 0x00000004
> +#define MRV_JPE_DEB_QIQ_TABLE_ACC_SHIFT 2
> +
> +#define MRV_JPE_VLC_TABLE_ERR
> +#define MRV_JPE_VLC_TABLE_ERR_MASK 0x00000400
> +#define MRV_JPE_VLC_TABLE_ERR_SHIFT 10
> +#define MRV_JPE_R2B_IMG_SIZE_ERR
> +#define MRV_JPE_R2B_IMG_SIZE_ERR_MASK 0x00000200
> +#define MRV_JPE_R2B_IMG_SIZE_ERR_SHIFT 9
> +#define MRV_JPE_DCT_ERR
> +#define MRV_JPE_DCT_ERR_MASK 0x00000080
> +#define MRV_JPE_DCT_ERR_SHIFT 7
> +#define MRV_JPE_VLC_SYMBOL_ERR
> +#define MRV_JPE_VLC_SYMBOL_ERR_MASK 0x00000010
> +#define MRV_JPE_VLC_SYMBOL_ERR_SHIFT 4
> +
> +
> +#define MRV_JPE_ALL_ERR
> +#define MRV_JPE_ALL_ERR_MASK \
> +(0 \
> +| MRV_JPE_VLC_TABLE_ERR_MASK \
> +| MRV_JPE_R2B_IMG_SIZE_ERR_MASK \
> +| MRV_JPE_DCT_ERR_MASK \
> +| MRV_JPE_VLC_SYMBOL_ERR_MASK \
> +)

Please properly indent it.


> +#define MRV_JPE_ALL_ERR_SHIFT 0
> +
> +#define MRV_JPE_GEN_HEADER_DONE
> +#define MRV_JPE_GEN_HEADER_DONE_MASK 0x00000020
> +#define MRV_JPE_GEN_HEADER_DONE_SHIFT 5
> +#define MRV_JPE_ENCODE_DONE
> +#define MRV_JPE_ENCODE_DONE_MASK 0x00000010
> +#define MRV_JPE_ENCODE_DONE_SHIFT 4
> +
> +#define MRV_JPE_ALL_STAT
> +#define MRV_JPE_ALL_STAT_MASK \
> +(0 \
> +| MRV_JPE_GEN_HEADER_DONE_MASK \
> +| MRV_JPE_ENCODE_DONE_MASK \
> +)

Please properly indent it.

> +#define MRV_JPE_ALL_STAT_SHIFT 0
> +
> +
> +#define MRV_AFM_AFM_EN
> +#define MRV_AFM_AFM_EN_MASK 0x00000001
> +#define MRV_AFM_AFM_EN_SHIFT 0
> +
> +#define MRV_AFM_A_H_L
> +#define MRV_AFM_A_H_L_MASK 0x0FFF0000
> +#define MRV_AFM_A_H_L_SHIFT 16
> +#define MRV_AFM_A_H_L_MIN  5
> +#define MRV_AFM_A_H_L_MAX  (MRV_AFM_A_H_L_MASK >> MRV_AFM_A_H_L_SHIFT)
> +#define MRV_AFM_A_V_T
> +#define MRV_AFM_A_V_T_MASK 0x00000FFF
> +#define MRV_AFM_A_V_T_SHIFT 0
> +#define MRV_AFM_A_V_T_MIN  2
> +#define MRV_AFM_A_V_T_MAX  (MRV_AFM_A_V_T_MASK >> MRV_AFM_A_V_T_SHIFT)
> +
> +#define MRV_AFM_A_H_R
> +#define MRV_AFM_A_H_R_MASK 0x0FFF0000
> +#define MRV_AFM_A_H_R_SHIFT 16
> +#define MRV_AFM_A_H_R_MIN  5
> +#define MRV_AFM_A_H_R_MAX  (MRV_AFM_A_H_R_MASK >> MRV_AFM_A_H_R_SHIFT)
> +#define MRV_AFM_A_V_B
> +#define MRV_AFM_A_V_B_MASK 0x00000FFF
> +#define MRV_AFM_A_V_B_SHIFT 0
> +#define MRV_AFM_A_V_B_MIN  2
> +#define MRV_AFM_A_V_B_MAX  (MRV_AFM_A_V_B_MASK >> MRV_AFM_A_V_B_SHIFT)
> +
> +#define MRV_AFM_B_H_L
> +#define MRV_AFM_B_H_L_MASK 0x0FFF0000
> +#define MRV_AFM_B_H_L_SHIFT 16
> +#define MRV_AFM_B_H_L_MIN  5
> +#define MRV_AFM_B_H_L_MAX  (MRV_AFM_B_H_L_MASK >> MRV_AFM_B_H_L_SHIFT)
> +#define MRV_AFM_B_V_T
> +#define MRV_AFM_B_V_T_MASK 0x00000FFF
> +#define MRV_AFM_B_V_T_SHIFT 0
> +#define MRV_AFM_B_V_T_MIN  2
> +#define MRV_AFM_B_V_T_MAX  (MRV_AFM_B_V_T_MASK >> MRV_AFM_B_V_T_SHIFT)
> +
> +#define MRV_AFM_B_H_R
> +#define MRV_AFM_B_H_R_MASK 0x0FFF0000
> +#define MRV_AFM_B_H_R_SHIFT 16
> +#define MRV_AFM_B_H_R_MIN  5
> +#define MRV_AFM_B_H_R_MAX  (MRV_AFM_B_H_R_MASK >> MRV_AFM_B_H_R_SHIFT)
> +#define MRV_AFM_B_V_B
> +#define MRV_AFM_B_V_B_MASK 0x00000FFF
> +#define MRV_AFM_B_V_B_SHIFT 0
> +#define MRV_AFM_B_V_B_MIN  2
> +#define MRV_AFM_B_V_B_MAX  (MRV_AFM_B_V_B_MASK >> MRV_AFM_B_V_B_SHIFT)
> +
> +#define MRV_AFM_C_H_L
> +#define MRV_AFM_C_H_L_MASK 0x0FFF0000
> +#define MRV_AFM_C_H_L_SHIFT 16
> +#define MRV_AFM_C_H_L_MIN  5
> +#define MRV_AFM_C_H_L_MAX  (MRV_AFM_C_H_L_MASK >> MRV_AFM_C_H_L_SHIFT)
> +#define MRV_AFM_C_V_T
> +#define MRV_AFM_C_V_T_MASK 0x00000FFF
> +#define MRV_AFM_C_V_T_SHIFT 0
> +#define MRV_AFM_C_V_T_MIN  2
> +#define MRV_AFM_C_V_T_MAX  (MRV_AFM_C_V_T_MASK >> MRV_AFM_C_V_T_SHIFT)
> +
> +#define MRV_AFM_C_H_R
> +#define MRV_AFM_C_H_R_MASK 0x0FFF0000
> +#define MRV_AFM_C_H_R_SHIFT 16
> +#define MRV_AFM_C_H_R_MIN  5
> +#define MRV_AFM_C_H_R_MAX  (MRV_AFM_C_H_R_MASK >> MRV_AFM_C_H_R_SHIFT)
> +#define MRV_AFM_C_V_B
> +#define MRV_AFM_C_V_B_MASK 0x00000FFF
> +#define MRV_AFM_C_V_B_SHIFT 0
> +#define MRV_AFM_C_V_B_MIN  2
> +#define MRV_AFM_C_V_B_MAX  (MRV_AFM_C_V_B_MASK >> MRV_AFM_C_V_B_SHIFT)
> +
> +#define MRV_AFM_AFM_THRES
> +#define MRV_AFM_AFM_THRES_MASK 0x0000FFFF
> +#define MRV_AFM_AFM_THRES_SHIFT 0
> +
> +#define MRV_AFM_LUM_VAR_SHIFT
> +#define MRV_AFM_LUM_VAR_SHIFT_MASK 0x00070000
> +#define MRV_AFM_LUM_VAR_SHIFT_SHIFT 16
> +#define MRV_AFM_AFM_VAR_SHIFT
> +#define MRV_AFM_AFM_VAR_SHIFT_MASK 0x00000007
> +#define MRV_AFM_AFM_VAR_SHIFT_SHIFT 0
> +
> +#define MRV_AFM_AFM_SUM_A
> +#define MRV_AFM_AFM_SUM_A_MASK 0xFFFFFFFF
> +#define MRV_AFM_AFM_SUM_A_SHIFT 0
> +
> +#define MRV_AFM_AFM_SUM_B
> +#define MRV_AFM_AFM_SUM_B_MASK 0xFFFFFFFF
> +#define MRV_AFM_AFM_SUM_B_SHIFT 0
> +
> +#define MRV_AFM_AFM_SUM_C
> +#define MRV_AFM_AFM_SUM_C_MASK 0xFFFFFFFF
> +#define MRV_AFM_AFM_SUM_C_SHIFT 0
> +
> +#define MRV_AFM_AFM_LUM_A
> +#define MRV_AFM_AFM_LUM_A_MASK 0x00FFFFFF
> +#define MRV_AFM_AFM_LUM_A_SHIFT 0
> +
> +#define MRV_AFM_AFM_LUM_B
> +#define MRV_AFM_AFM_LUM_B_MASK 0x00FFFFFF
> +#define MRV_AFM_AFM_LUM_B_SHIFT 0
> +
> +#define MRV_AFM_AFM_LUM_C
> +#define MRV_AFM_AFM_LUM_C_MASK 0x00FFFFFF
> +#define MRV_AFM_AFM_LUM_C_SHIFT 0
> +
> +#define MRV_BP_COR_TYPE
> +#define MRV_BP_COR_TYPE_MASK 0x00000010
> +#define MRV_BP_COR_TYPE_SHIFT 4
> +#define MRV_BP_COR_TYPE_TABLE  0
> +#define MRV_BP_COR_TYPE_DIRECT 1
> +#define MRV_BP_REP_APPR
> +#define MRV_BP_REP_APPR_MASK 0x00000008
> +#define MRV_BP_REP_APPR_SHIFT 3
> +#define MRV_BP_REP_APPR_NEAREST  0
> +#define MRV_BP_REP_APPR_INTERPOL 1
> +#define MRV_BP_DEAD_COR_EN
> +#define MRV_BP_DEAD_COR_EN_MASK 0x00000004
> +#define MRV_BP_DEAD_COR_EN_SHIFT 2
> +#define MRV_BP_HOT_COR_EN
> +#define MRV_BP_HOT_COR_EN_MASK 0x00000002
> +#define MRV_BP_HOT_COR_EN_SHIFT 1
> +#define MRV_BP_BP_DET_EN
> +#define MRV_BP_BP_DET_EN_MASK 0x00000001
> +#define MRV_BP_BP_DET_EN_SHIFT 0
> +
> +#define MRV_BP_HOT_THRES
> +#define MRV_BP_HOT_THRES_MASK 0x0FFF0000
> +#define MRV_BP_HOT_THRES_SHIFT 16
> +#define MRV_BP_DEAD_THRES
> +#define MRV_BP_DEAD_THRES_MASK 0x00000FFF
> +#define MRV_BP_DEAD_THRES_SHIFT 0
> +
> +#define MRV_BP_DEV_HOT_THRES
> +#define MRV_BP_DEV_HOT_THRES_MASK 0x0FFF0000
> +#define MRV_BP_DEV_HOT_THRES_SHIFT 16
> +#define MRV_BP_DEV_DEAD_THRES
> +#define MRV_BP_DEV_DEAD_THRES_MASK 0x00000FFF
> +#define MRV_BP_DEV_DEAD_THRES_SHIFT 0
> +#define MRV_BP_BP_NUMBER
> +
> +#define MRV_BP_BP_NUMBER_MASK 0x00000FFF
> +#define MRV_BP_BP_NUMBER_SHIFT 0
> +
> +#define MRV_BP_BP_TABLE_ADDR
> +#define MRV_BP_BP_TABLE_ADDR_MASK 0x000007FF
> +
> +#define MRV_BP_BP_TABLE_ADDR_SHIFT 0
> +#define MRV_BP_BP_TABLE_ADDR_MAX MRV_BP_BP_TABLE_ADDR_MASK
> +#define MRV_BP_PIX_TYPE
> +#define MRV_BP_PIX_TYPE_MASK 0x80000000
> +#define MRV_BP_PIX_TYPE_SHIFT 31
> +#define MRV_BP_PIX_TYPE_DEAD   0u
> +#define MRV_BP_PIX_TYPE_HOT    1u
> +#define MRV_BP_V_ADDR
> +
> +#define MRV_BP_V_ADDR_MASK 0x0FFF0000
> +
> +#define MRV_BP_V_ADDR_SHIFT 16
> +#define MRV_BP_H_ADDR
> +#define MRV_BP_H_ADDR_MASK 0x00000FFF
> +#define MRV_BP_H_ADDR_SHIFT 0
> +
> +#define MRV_BP_BP_NEW_NUMBER
> +#define MRV_BP_BP_NEW_NUMBER_MASK 0x0000000F
> +#define MRV_BP_BP_NEW_NUMBER_SHIFT 0
> +
> +#define MRV_BP_NEW_VALUE
> +
> +#define MRV_BP_NEW_VALUE_MASK 0xF8000000
> +#define MRV_BP_NEW_VALUE_SHIFT 27
> +#define MRV_BP_NEW_V_ADDR
> +
> +#define MRV_BP_NEW_V_ADDR_MASK 0x07FF0000
> +#define MRV_BP_NEW_V_ADDR_SHIFT 16
> +#define MRV_BP_NEW_H_ADDR
> +#define MRV_BP_NEW_H_ADDR_MASK 0x00000FFF
> +#define MRV_BP_NEW_H_ADDR_SHIFT 0
> +
> +#define MRV_LSC_LSC_EN
> +#define MRV_LSC_LSC_EN_MASK 0x00000001
> +#define MRV_LSC_LSC_EN_SHIFT 0
> +
> +#define MRV_LSC_R_RAM_ADDR
> +#define MRV_LSC_R_RAM_ADDR_MASK 0x000000FF
> +#define MRV_LSC_R_RAM_ADDR_SHIFT 0
> +#define MRV_LSC_R_RAM_ADDR_MIN  0x00000000
> +#define MRV_LSC_R_RAM_ADDR_MAX  0x00000098
> +
> +#define MRV_LSC_G_RAM_ADDR
> +#define MRV_LSC_G_RAM_ADDR_MASK 0x000000FF
> +#define MRV_LSC_G_RAM_ADDR_SHIFT 0
> +#define MRV_LSC_G_RAM_ADDR_MIN  0x00000000
> +#define MRV_LSC_G_RAM_ADDR_MAX  0x00000098
> +
> +#define MRV_LSC_B_RAM_ADDR
> +#define MRV_LSC_B_RAM_ADDR_MASK 0x000000FF
> +#define MRV_LSC_B_RAM_ADDR_SHIFT 0
> +#define MRV_LSC_B_RAM_ADDR_MIN  0x00000000
> +#define MRV_LSC_B_RAM_ADDR_MAX  0x00000098
> +
> +#define MRV_LSC_R_SAMPLE_1
> +#define MRV_LSC_R_SAMPLE_1_MASK 0x00FFF000
> +#define MRV_LSC_R_SAMPLE_1_SHIFT 12
> +#define MRV_LSC_R_SAMPLE_0
> +#define MRV_LSC_R_SAMPLE_0_MASK 0x00000FFF
> +#define MRV_LSC_R_SAMPLE_0_SHIFT 0
> +
> +#define MRV_LSC_G_SAMPLE_1
> +#define MRV_LSC_G_SAMPLE_1_MASK 0x00FFF000
> +#define MRV_LSC_G_SAMPLE_1_SHIFT 12
> +#define MRV_LSC_G_SAMPLE_0
> +#define MRV_LSC_G_SAMPLE_0_MASK 0x00000FFF
> +#define MRV_LSC_G_SAMPLE_0_SHIFT 0
> +
> +#define MRV_LSC_B_SAMPLE_1
> +#define MRV_LSC_B_SAMPLE_1_MASK 0x00FFF000
> +#define MRV_LSC_B_SAMPLE_1_SHIFT 12
> +#define MRV_LSC_B_SAMPLE_0
> +#define MRV_LSC_B_SAMPLE_0_MASK 0x00000FFF
> +#define MRV_LSC_B_SAMPLE_0_SHIFT 0
> +
> +#define MRV_LSC_XGRAD_1
> +#define MRV_LSC_XGRAD_1_MASK 0x0FFF0000
> +#define MRV_LSC_XGRAD_1_SHIFT 16
> +#define MRV_LSC_XGRAD_0
> +#define MRV_LSC_XGRAD_0_MASK 0x00000FFF
> +#define MRV_LSC_XGRAD_0_SHIFT 0
> +#define MRV_LSC_XGRAD_3
> +#define MRV_LSC_XGRAD_3_MASK 0x0FFF0000
> +#define MRV_LSC_XGRAD_3_SHIFT 16
> +#define MRV_LSC_XGRAD_2
> +#define MRV_LSC_XGRAD_2_MASK 0x00000FFF
> +#define MRV_LSC_XGRAD_2_SHIFT 0
> +#define MRV_LSC_XGRAD_5
> +#define MRV_LSC_XGRAD_5_MASK 0x0FFF0000
> +#define MRV_LSC_XGRAD_5_SHIFT 16
> +#define MRV_LSC_XGRAD_4
> +#define MRV_LSC_XGRAD_4_MASK 0x00000FFF
> +#define MRV_LSC_XGRAD_4_SHIFT 0
> +#define MRV_LSC_XGRAD_7
> +#define MRV_LSC_XGRAD_7_MASK 0x0FFF0000
> +#define MRV_LSC_XGRAD_7_SHIFT 16
> +#define MRV_LSC_XGRAD_6
> +#define MRV_LSC_XGRAD_6_MASK 0x00000FFF
> +#define MRV_LSC_XGRAD_6_SHIFT 0
> +#define MRV_LSC_YGRAD_1
> +#define MRV_LSC_YGRAD_1_MASK 0x0FFF0000
> +#define MRV_LSC_YGRAD_1_SHIFT 16
> +#define MRV_LSC_YGRAD_0
> +#define MRV_LSC_YGRAD_0_MASK 0x00000FFF
> +#define MRV_LSC_YGRAD_0_SHIFT 0
> +#define MRV_LSC_YGRAD_3
> +#define MRV_LSC_YGRAD_3_MASK 0x0FFF0000
> +#define MRV_LSC_YGRAD_3_SHIFT 16
> +#define MRV_LSC_YGRAD_2
> +#define MRV_LSC_YGRAD_2_MASK 0x00000FFF
> +#define MRV_LSC_YGRAD_2_SHIFT 0
> +#define MRV_LSC_YGRAD_5
> +#define MRV_LSC_YGRAD_5_MASK 0x0FFF0000
> +#define MRV_LSC_YGRAD_5_SHIFT 16
> +#define MRV_LSC_YGRAD_4
> +#define MRV_LSC_YGRAD_4_MASK 0x00000FFF
> +#define MRV_LSC_YGRAD_4_SHIFT 0
> +#define MRV_LSC_YGRAD_7
> +#define MRV_LSC_YGRAD_7_MASK 0x0FFF0000
> +#define MRV_LSC_YGRAD_7_SHIFT 16
> +#define MRV_LSC_YGRAD_6
> +#define MRV_LSC_YGRAD_6_MASK 0x00000FFF
> +#define MRV_LSC_YGRAD_6_SHIFT 0
> +#define MRV_LSC_X_SECT_SIZE_1
> +#define MRV_LSC_X_SECT_SIZE_1_MASK 0x03FF0000
> +#define MRV_LSC_X_SECT_SIZE_1_SHIFT 16
> +#define MRV_LSC_X_SECT_SIZE_0
> +#define MRV_LSC_X_SECT_SIZE_0_MASK 0x000003FF
> +#define MRV_LSC_X_SECT_SIZE_0_SHIFT 0
> +#define MRV_LSC_X_SECT_SIZE_3
> +#define MRV_LSC_X_SECT_SIZE_3_MASK 0x03FF0000
> +#define MRV_LSC_X_SECT_SIZE_3_SHIFT 16
> +#define MRV_LSC_X_SECT_SIZE_2
> +#define MRV_LSC_X_SECT_SIZE_2_MASK 0x000003FF
> +#define MRV_LSC_X_SECT_SIZE_2_SHIFT 0
> +#define MRV_LSC_X_SECT_SIZE_5
> +#define MRV_LSC_X_SECT_SIZE_5_MASK 0x03FF0000
> +#define MRV_LSC_X_SECT_SIZE_5_SHIFT 16
> +#define MRV_LSC_X_SECT_SIZE_4
> +#define MRV_LSC_X_SECT_SIZE_4_MASK 0x000003FF
> +#define MRV_LSC_X_SECT_SIZE_4_SHIFT 0
> +#define MRV_LSC_X_SECT_SIZE_7
> +#define MRV_LSC_X_SECT_SIZE_7_MASK 0x03FF0000
> +#define MRV_LSC_X_SECT_SIZE_7_SHIFT 16
> +#define MRV_LSC_X_SECT_SIZE_6
> +#define MRV_LSC_X_SECT_SIZE_6_MASK 0x000003FF
> +#define MRV_LSC_X_SECT_SIZE_6_SHIFT 0
> +#define MRV_LSC_Y_SECT_SIZE_1
> +#define MRV_LSC_Y_SECT_SIZE_1_MASK 0x03FF0000
> +#define MRV_LSC_Y_SECT_SIZE_1_SHIFT 16
> +#define MRV_LSC_Y_SECT_SIZE_0
> +#define MRV_LSC_Y_SECT_SIZE_0_MASK 0x000003FF
> +#define MRV_LSC_Y_SECT_SIZE_0_SHIFT 0
> +
> +#define MRV_LSC_Y_SECT_SIZE_3
> +#define MRV_LSC_Y_SECT_SIZE_3_MASK 0x03FF0000
> +#define MRV_LSC_Y_SECT_SIZE_3_SHIFT 16
> +#define MRV_LSC_Y_SECT_SIZE_2
> +#define MRV_LSC_Y_SECT_SIZE_2_MASK 0x000003FF
> +#define MRV_LSC_Y_SECT_SIZE_2_SHIFT 0
> +
> +#define MRV_LSC_Y_SECT_SIZE_5
> +#define MRV_LSC_Y_SECT_SIZE_5_MASK 0x03FF0000
> +#define MRV_LSC_Y_SECT_SIZE_5_SHIFT 16
> +#define MRV_LSC_Y_SECT_SIZE_4
> +#define MRV_LSC_Y_SECT_SIZE_4_MASK 0x000003FF
> +#define MRV_LSC_Y_SECT_SIZE_4_SHIFT 0
> +
> +#define MRV_LSC_Y_SECT_SIZE_7
> +#define MRV_LSC_Y_SECT_SIZE_7_MASK 0x03FF0000
> +#define MRV_LSC_Y_SECT_SIZE_7_SHIFT 16
> +#define MRV_LSC_Y_SECT_SIZE_6
> +#define MRV_LSC_Y_SECT_SIZE_6_MASK 0x000003FF
> +#define MRV_LSC_Y_SECT_SIZE_6_SHIFT 0
> +#define MRV_IS_IS_EN
> +#define MRV_IS_IS_EN_MASK 0x00000001
> +#define MRV_IS_IS_EN_SHIFT 0
> +
> +#define MRV_IS_IS_RECENTER
> +#define MRV_IS_IS_RECENTER_MASK 0x00000007
> +#define MRV_IS_IS_RECENTER_SHIFT 0
> +#define MRV_IS_IS_RECENTER_MAX \
> +       (MRV_IS_IS_RECENTER_MASK >> MRV_IS_IS_RECENTER_SHIFT)
> +#define MRV_IS_IS_H_OFFS
> +#define MRV_IS_IS_H_OFFS_MASK 0x00001FFF
> +#define MRV_IS_IS_H_OFFS_SHIFT 0
> +#define MRV_IS_IS_V_OFFS
> +#define MRV_IS_IS_V_OFFS_MASK 0x00000FFF
> +#define MRV_IS_IS_V_OFFS_SHIFT 0
> +#define MRV_IS_IS_H_SIZE
> +#define MRV_IS_IS_H_SIZE_MASK 0x00003FFF
> +#define MRV_IS_IS_H_SIZE_SHIFT 0
> +#define MRV_IS_IS_V_SIZE
> +#define MRV_IS_IS_V_SIZE_MASK 0x00000FFF
> +#define MRV_IS_IS_V_SIZE_SHIFT 0
> +#define MRV_IS_IS_MAX_DX
> +#define MRV_IS_IS_MAX_DX_MASK 0x00000FFF
> +#define MRV_IS_IS_MAX_DX_SHIFT 0
> +#define MRV_IS_IS_MAX_DX_MAX (MRV_IS_IS_MAX_DX_MASK >> MRV_IS_IS_MAX_DX_SHIFT)
> +#define MRV_IS_IS_MAX_DY
> +#define MRV_IS_IS_MAX_DY_MASK 0x00000FFF
> +#define MRV_IS_IS_MAX_DY_SHIFT 0
> +#define MRV_IS_IS_MAX_DY_MAX (MRV_IS_IS_MAX_DY_MASK >> MRV_IS_IS_MAX_DY_SHIFT)
> +#define MRV_IS_DY
> +#define MRV_IS_DY_MASK 0x0FFF0000
> +#define MRV_IS_DY_SHIFT 16
> +#define MRV_IS_DY_MAX 0x000007FF
> +#define MRV_IS_DY_MIN (~MRV_IS_DY_MAX)
> +#define MRV_IS_DX
> +#define MRV_IS_DX_MASK 0x00000FFF
> +#define MRV_IS_DX_SHIFT 0
> +#define MRV_IS_DX_MAX 0x000007FF
> +#define MRV_IS_DX_MIN (~MRV_IS_DX_MAX)
> +
> +
> +#define MRV_IS_IS_H_OFFS_SHD
> +#define MRV_IS_IS_H_OFFS_SHD_MASK 0x00001FFF
> +#define MRV_IS_IS_H_OFFS_SHD_SHIFT 0
> +
> +
> +#define MRV_IS_IS_V_OFFS_SHD
> +#define MRV_IS_IS_V_OFFS_SHD_MASK 0x00000FFF
> +#define MRV_IS_IS_V_OFFS_SHD_SHIFT 0
> +
> +#define MRV_IS_ISP_H_SIZE_SHD
> +#define MRV_IS_ISP_H_SIZE_SHD_MASK 0x00001FFF
> +#define MRV_IS_ISP_H_SIZE_SHD_SHIFT 0
> +
> +#define MRV_IS_ISP_V_SIZE_SHD
> +#define MRV_IS_ISP_V_SIZE_SHD_MASK 0x00000FFF
> +#define MRV_IS_ISP_V_SIZE_SHD_SHIFT 0
> +
> +#define MRV_FILT_STAGE1_SELECT
> +#define MRV_FILT_STAGE1_SELECT_MASK 0x00000F00
> +#define MRV_FILT_STAGE1_SELECT_SHIFT 8
> +#define MRV_FILT_STAGE1_SELECT_MAX_BLUR 0
> +#define MRV_FILT_STAGE1_SELECT_DEFAULT  4
> +#define MRV_FILT_STAGE1_SELECT_MIN_BLUR 7
> +#define MRV_FILT_STAGE1_SELECT_BYPASS   8
> +#define MRV_FILT_FILT_CHR_H_MODE
> +#define MRV_FILT_FILT_CHR_H_MODE_MASK 0x000000C0
> +#define MRV_FILT_FILT_CHR_H_MODE_SHIFT 6
> +#define MRV_FILT_FILT_CHR_H_MODE_BYPASS 0
> +#define MRV_FILT_FILT_CHR_H_MODE_STATIC 1
> +#define MRV_FILT_FILT_CHR_H_MODE_DYN_1  2
> +#define MRV_FILT_FILT_CHR_H_MODE_DYN_2  3
> +#define MRV_FILT_FILT_CHR_V_MODE
> +#define MRV_FILT_FILT_CHR_V_MODE_MASK 0x00000030
> +#define MRV_FILT_FILT_CHR_V_MODE_SHIFT 4
> +#define MRV_FILT_FILT_CHR_V_MODE_BYPASS   0
> +#define MRV_FILT_FILT_CHR_V_MODE_STATIC8  1
> +#define MRV_FILT_FILT_CHR_V_MODE_STATIC10 2
> +#define MRV_FILT_FILT_CHR_V_MODE_STATIC12 3
> +
> +#define MRV_FILT_FILT_MODE
> +#define MRV_FILT_FILT_MODE_MASK 0x00000002
> +#define MRV_FILT_FILT_MODE_SHIFT 1
> +#define MRV_FILT_FILT_MODE_STATIC  0
> +#define MRV_FILT_FILT_MODE_DYNAMIC 1
> +
> +#define MRV_FILT_FILT_ENABLE
> +#define MRV_FILT_FILT_ENABLE_MASK 0x00000001
> +#define MRV_FILT_FILT_ENABLE_SHIFT 0
> +
> +#define MRV_FILT_FILT_THRESH_BL0
> +#define MRV_FILT_FILT_THRESH_BL0_MASK 0x000003FF
> +#define MRV_FILT_FILT_THRESH_BL0_SHIFT 0
> +
> +#define MRV_FILT_FILT_THRESH_BL1
> +#define MRV_FILT_FILT_THRESH_BL1_MASK 0x000003FF
> +#define MRV_FILT_FILT_THRESH_BL1_SHIFT 0
> +
> +#define MRV_FILT_FILT_THRESH_SH0
> +#define MRV_FILT_FILT_THRESH_SH0_MASK 0x000003FF
> +#define MRV_FILT_FILT_THRESH_SH0_SHIFT 0
> +
> +#define MRV_FILT_FILT_THRESH_SH1
> +#define MRV_FILT_FILT_THRESH_SH1_MASK 0x000003FF
> +#define MRV_FILT_FILT_THRESH_SH1_SHIFT 0
> +
> +#define MRV_FILT_LUM_WEIGHT_GAIN
> +#define MRV_FILT_LUM_WEIGHT_GAIN_MASK 0x00070000
> +#define MRV_FILT_LUM_WEIGHT_GAIN_SHIFT 16
> +#define MRV_FILT_LUM_WEIGHT_KINK
> +#define MRV_FILT_LUM_WEIGHT_KINK_MASK 0x0000FF00
> +#define MRV_FILT_LUM_WEIGHT_KINK_SHIFT 8
> +#define MRV_FILT_LUM_WEIGHT_MIN
> +#define MRV_FILT_LUM_WEIGHT_MIN_MASK 0x000000FF
> +#define MRV_FILT_LUM_WEIGHT_MIN_SHIFT 0
> +#define MRV_FILT_FILT_FAC_SH1
> +#define MRV_FILT_FILT_FAC_SH1_MASK 0x0000003F
> +#define MRV_FILT_FILT_FAC_SH1_SHIFT 0
> +
> +#define MRV_FILT_FILT_FAC_SH0
> +#define MRV_FILT_FILT_FAC_SH0_MASK 0x0000003F
> +#define MRV_FILT_FILT_FAC_SH0_SHIFT 0
> +
> +
> +#define MRV_FILT_FILT_FAC_MID
> +#define MRV_FILT_FILT_FAC_MID_MASK 0x0000003F
> +#define MRV_FILT_FILT_FAC_MID_SHIFT 0
> +
> +#define MRV_FILT_FILT_FAC_BL0
> +#define MRV_FILT_FILT_FAC_BL0_MASK 0x0000003F
> +#define MRV_FILT_FILT_FAC_BL0_SHIFT 0
> +
> +#define MRV_FILT_FILT_FAC_BL1
> +#define MRV_FILT_FILT_FAC_BL1_MASK 0x0000003F
> +#define MRV_FILT_FILT_FAC_BL1_SHIFT 0
> +
> +#define MRV_BLS_WINDOW_ENABLE
> +#define MRV_BLS_WINDOW_ENABLE_MASK 0x0000000C
> +#define MRV_BLS_WINDOW_ENABLE_SHIFT 2
> +#define MRV_BLS_WINDOW_ENABLE_NONE  0
> +#define MRV_BLS_WINDOW_ENABLE_WND1  1
> +#define MRV_BLS_WINDOW_ENABLE_WND2  2
> +#define MRV_BLS_WINDOW_ENABLE_BOTH  3
> +
> +#define MRV_BLS_BLS_MODE
> +#define MRV_BLS_BLS_MODE_MASK 0x00000002
> +#define MRV_BLS_BLS_MODE_SHIFT 1
> +#define MRV_BLS_BLS_MODE_MEAS  1
> +#define MRV_BLS_BLS_MODE_FIX   0
> +
> +#define MRV_BLS_BLS_ENABLE
> +#define MRV_BLS_BLS_ENABLE_MASK 0x00000001
> +#define MRV_BLS_BLS_ENABLE_SHIFT 0
> +
> +#define MRV_BLS_BLS_SAMPLES
> +#define MRV_BLS_BLS_SAMPLES_MASK 0x0000001F
> +#define MRV_BLS_BLS_SAMPLES_SHIFT 0
> +
> +#define MRV_BLS_BLS_SAMPLES_MAX     (0x00000014)
> +
> +#define MRV_BLS_BLS_H1_START
> +#define MRV_BLS_BLS_H1_START_MASK 0x00000FFF
> +#define MRV_BLS_BLS_H1_START_SHIFT 0
> +#define MRV_BLS_BLS_H1_START_MAX \
> +       (MRV_BLS_BLS_H1_START_MASK >> MRV_BLS_BLS_H1_START_SHIFT)
> +#define MRV_BLS_BLS_H1_STOP
> +#define MRV_BLS_BLS_H1_STOP_MASK 0x00001FFF
> +#define MRV_BLS_BLS_H1_STOP_SHIFT 0
> +#define MRV_BLS_BLS_H1_STOP_MAX \
> +       (MRV_BLS_BLS_H1_STOP_MASK >> MRV_BLS_BLS_H1_STOP_SHIFT)
> +#define MRV_BLS_BLS_V1_START
> +#define MRV_BLS_BLS_V1_START_MASK 0x00001FFF
> +#define MRV_BLS_BLS_V1_START_SHIFT 0
> +#define MRV_BLS_BLS_V1_START_MAX \
> +       (MRV_BLS_BLS_V1_START_MASK >> MRV_BLS_BLS_V1_START_SHIFT)
> +
> +#define MRV_BLS_BLS_V1_STOP
> +#define MRV_BLS_BLS_V1_STOP_MASK 0x00001FFF
> +#define MRV_BLS_BLS_V1_STOP_SHIFT 0
> +#define MRV_BLS_BLS_V1_STOP_MAX \
> +       (MRV_BLS_BLS_V1_STOP_MASK >> MRV_BLS_BLS_V1_STOP_SHIFT)
> +
> +#define MRV_BLS_BLS_H2_START
> +#define MRV_BLS_BLS_H2_START_MASK 0x00001FFF
> +#define MRV_BLS_BLS_H2_START_SHIFT 0
> +#define MRV_BLS_BLS_H2_START_MAX \
> +       (MRV_BLS_BLS_H2_START_MASK >> MRV_BLS_BLS_H2_START_SHIFT)
> +#define MRV_BLS_BLS_H2_STOP
> +#define MRV_BLS_BLS_H2_STOP_MASK 0x00001FFF
> +#define MRV_BLS_BLS_H2_STOP_SHIFT 0
> +#define MRV_BLS_BLS_H2_STOP_MAX \
> +       (MRV_BLS_BLS_H2_STOP_MASK >> MRV_BLS_BLS_H2_STOP_SHIFT)
> +#define MRV_BLS_BLS_V2_START
> +#define MRV_BLS_BLS_V2_START_MASK 0x00001FFF
> +#define MRV_BLS_BLS_V2_START_SHIFT 0
> +#define MRV_BLS_BLS_V2_START_MAX \
> +       (MRV_BLS_BLS_V2_START_MASK >> MRV_BLS_BLS_V2_START_SHIFT)
> +#define MRV_BLS_BLS_V2_STOP
> +#define MRV_BLS_BLS_V2_STOP_MASK 0x00001FFF
> +#define MRV_BLS_BLS_V2_STOP_SHIFT 0
> +#define MRV_BLS_BLS_V2_STOP_MAX \
> +       (MRV_BLS_BLS_V2_STOP_MASK >> MRV_BLS_BLS_V2_STOP_SHIFT)
> +#define MRV_ISP_BLS_FIX_SUB_MIN     (0xFFFFF001)
> +#define MRV_ISP_BLS_FIX_SUB_MAX     (0x00000FFF)
> +#define MRV_ISP_BLS_FIX_MASK        (0x00001FFF)
> +#define MRV_ISP_BLS_FIX_SHIFT_A              (0)
> +#define MRV_ISP_BLS_FIX_SHIFT_B              (0)
> +#define MRV_ISP_BLS_FIX_SHIFT_C              (0)
> +#define MRV_ISP_BLS_FIX_SHIFT_D              (0)
> +#define MRV_ISP_BLS_MEAN_MASK       (0x00000FFF)
> +#define MRV_ISP_BLS_MEAN_SHIFT_A             (0)
> +#define MRV_ISP_BLS_MEAN_SHIFT_B             (0)
> +#define MRV_ISP_BLS_MEAN_SHIFT_C             (0)
> +#define MRV_ISP_BLS_MEAN_SHIFT_D             (0)
> +
> +#define MRV_BLS_BLS_A_FIXED
> +#define MRV_BLS_BLS_A_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
> +                                 MRV_ISP_BLS_FIX_SHIFT_A)
> +#define MRV_BLS_BLS_A_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_A
> +
> +#define MRV_BLS_BLS_B_FIXED
> +#define MRV_BLS_BLS_B_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
> +                                 MRV_ISP_BLS_FIX_SHIFT_B)
> +#define MRV_BLS_BLS_B_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_B
> +
> +#define MRV_BLS_BLS_C_FIXED
> +#define MRV_BLS_BLS_C_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
> +                                 MRV_ISP_BLS_FIX_SHIFT_C)
> +#define MRV_BLS_BLS_C_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_C
> +
> +#define MRV_BLS_BLS_D_FIXED
> +#define MRV_BLS_BLS_D_FIXED_MASK (MRV_ISP_BLS_FIX_MASK <<\
> +                                 MRV_ISP_BLS_FIX_SHIFT_D)
> +#define MRV_BLS_BLS_D_FIXED_SHIFT MRV_ISP_BLS_FIX_SHIFT_D
> +
> +#define MRV_BLS_BLS_A_MEASURED
> +#define MRV_BLS_BLS_A_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
> +                                    MRV_ISP_BLS_MEAN_SHIFT_A)
> +#define MRV_BLS_BLS_A_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_A
> +
> +
> +#define MRV_BLS_BLS_B_MEASURED
> +#define MRV_BLS_BLS_B_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
> +                                    MRV_ISP_BLS_MEAN_SHIFT_B)
> +#define MRV_BLS_BLS_B_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_B
> +
> +
> +#define MRV_BLS_BLS_C_MEASURED
> +#define MRV_BLS_BLS_C_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
> +                                    MRV_ISP_BLS_MEAN_SHIFT_C)
> +#define MRV_BLS_BLS_C_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_C
> +
> +#define MRV_BLS_BLS_D_MEASURED
> +#define MRV_BLS_BLS_D_MEASURED_MASK (MRV_ISP_BLS_MEAN_MASK <<\
> +                                    MRV_ISP_BLS_MEAN_SHIFT_D)
> +#define MRV_BLS_BLS_D_MEASURED_SHIFT MRV_ISP_BLS_MEAN_SHIFT_D
> +
> +
> +int ci_isp_wait_for_vsyncHelper(void);
> +void   ci_isp_jpe_set_tables(u8 compression_ratio);
> +void   ci_isp_jpe_select_tables(void);
> +void   ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale);
> +int ci_isp_jpe_generate_header(u8 header_mode);
> +void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode);
> +int ci_isp_jpe_wait_for_header_gen_done(void);
> +int ci_isp_jpe_wait_for_encode_done(void);
> +
> +
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrv_sls.h b/drivers/media/video/mrstci/mrstisp/include/mrv_sls.h
> new file mode 100644
> index 0000000..b489b68
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrv_sls.h
> @@ -0,0 +1,248 @@
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
> +
> +#ifndef _MRV_SLS_H
> +#define _MRV_SLS_H
> +
> +#define MARVIN_FEATURE_SCALEFACTOR_COMBINED_UV  (2)
> +#define MARVIN_FEATURE_SCALEFACTOR_SEPARATED_UV (3)
> +
> +#define MARVIN_FEATURE_SSCALE_FACTORCALC \
> +       MARVIN_FEATURE_SCALEFACTOR_SEPARATED_UV
> +
> +#define MARVIN_FEATURE_MSCALE_FACTORCALC \
> +               MARVIN_FEATURE_SCALEFACTOR_SEPARATED_UV
> +
> +/*
> + * simplified datapath and output formatter/resizer adjustment
> + * can be used to setup the main and self datapathes in a convenient way.
> + */
> +
> +/* data path descriptor */
> +struct ci_isp_datapath_desc {
> +       /* width of output picture (after scaling) in pixels */
> +       u16 out_w;
> +       /* height of output picture (after scaling) in pixels */
> +       u16 out_h;
> +       /* how to configure the datapath. An or'ed combination of the */
> +       u32 flags;
> +       /* MRV_DPD_xxx defines */
> +};
> +
> +/*
> + * possible Frags for the Datapath descriptor general features
> + */
> +/* enables the datapath in general */
> +#define CI_ISP_DPD_ENABLE          0x00000001
> +/*
> + * the out_w and out_h members will be ignored.  and the
> + * resize module of the datapath is switched off. Note that
> + * the resize module is also needed for croma subsampling
> + */
> +#define CI_ISP_DPD_NORESIZE        0x00000002
> +/*
> + * The input picture from ISP is being cropped to match the
> + * aspect ratio of the desired output. If this flag is not
> + * set, different scaling factors for X and Y axis
> + * may be used.
> + */
> +#define CI_ISP_DPD_KEEPRATIO       0x00000004
> +/* mirror the output picture (only applicable for self path) data path mode */
> +#define CI_ISP_DPD_MIRROR          0x00000008
> +/* mode mask (3 bits) */
> +#define CI_ISP_DPD_MODE_MASK          0x00000070
> +/* 16(12) bit raw data from ISP block (only applicable for main path) */
> +#define CI_ISP_DPD_MODE_ISPRAW_16B     0x00000000
> +/* separated Y, Cb and Cr data from ISP block */
> +#define CI_ISP_DPD_MODE_ISPYC          0x00000010
> +/* raw data from ISP block (only applicable for main path) */
> +#define CI_ISP_DPD_MODE_ISPRAW         0x00000020
> +/* Jpeg encoding with data from ISP block (only applicable for main path) */
> +#define CI_ISP_DPD_MODE_ISPJPEG        0x00000030
> +/*
> + * YCbCr data from system memory directly routed to the main/self
> + * path (DMA-read, only applicable for self path)
> + */
> +#define CI_ISP_DPD_MODE_DMAYC_DIRECT   0x00000040
> +/*
> + * YCbCr data from system memory routed through the main processing
> + * chain substituting ISP data (DMA-read)
> + */
> +#define CI_ISP_DPD_MODE_DMAYC_ISP      0x00000050
> +/*
> + * YCbCr data from system memory directly routed to the jpeg encoder
> + * (DMA-read, R2B-bufferless encoding, only applicable for main path)
> + */
> +#define CI_ISP_DPD_MODE_DMAJPEG_DIRECT 0x00000060
> +/*
> + * Jpeg encoding with YCbCr data from system memory routed through the
> + * main processing chain substituting ISP data (DMA-read, only applicable
> + * for main path) top blackline support
> + */
> +#define CI_ISP_DPD_MODE_DMAJPEG_ISP    0x00000070
> +
> +/*
> + * If set, blacklines at the top of the sensor are
> + * shown in the output (if there are any). Note that this
> + * will move the window of interest out of the center
> + * to the upper border, so especially at configurations
> + * with digital zoom, the field of sight is not centered
> + * on the optical axis anymore. If the sensor does not deliver
> + * blacklines, setting this bit has no effect.
> + * additional chroma subsampling (CSS) amount and sample position
> + */
> +#define CI_ISP_DPD_BLACKLINES_TOP  0x00000080
> +/* horizontal subsampling */
> +#define CI_ISP_DPD_CSS_H_MASK     0x00000700
> +/* no horizontal subsampling */
> +#define CI_ISP_DPD_CSS_H_OFF       0x00000000
> +/* horizontal subsampling by 2 */
> +#define CI_ISP_DPD_CSS_H2          0x00000100
> +/* horizontal subsampling by 4 */
> +#define CI_ISP_DPD_CSS_H4          0x00000200
> +/* 2 times horizontal upsampling */
> +#define CI_ISP_DPD_CSS_HUP2        0x00000500
> +/* 4 times horizontal upsampling */
> +#define CI_ISP_DPD_CSS_HUP4        0x00000600
> +/* vertical subsampling */
> +#define CI_ISP_DPD_CSS_V_MASK     0x00003800
> +/* no vertical subsampling */
> +#define CI_ISP_DPD_CSS_V_OFF       0x00000000
> +/* vertical subsampling by 2 */
> +#define CI_ISP_DPD_CSS_V2          0x00000800
> +/* vertical subsampling by 4 */
> +#define CI_ISP_DPD_CSS_V4          0x00001000
> +/* 2 times vertical upsampling */
> +#define CI_ISP_DPD_CSS_VUP2        0x00002800
> +/* 4 times vertical upsampling */
> +#define CI_ISP_DPD_CSS_VUP4        0x00003000
> +/* apply horizontal chroma phase shift by half the sample distance */
> +#define CI_ISP_DPD_CSS_HSHIFT      0x00004000
> +/* apply vertical chroma phase shift by half the sample distance */
> +#define CI_ISP_DPD_CSS_VSHIFT      0x00008000
> +
> +/*
> + * Hardware RGB conversion (currly, only supported for self path)
> + * output mode mask (3 bits, not all combination used yet)
> + */
> +#define CI_ISP_DPD_HWRGB_MASK     0x00070000
> +/* no rgb conversion */
> +#define CI_ISP_DPD_HWRGB_OFF       0x00000000
> +/* conversion to RGB565 */
> +#define CI_ISP_DPD_HWRGB_565       0x00010000
> +/* conversion to RGB666 */
> +#define CI_ISP_DPD_HWRGB_666       0x00020000
> +/* conversion to RGB888 */
> +#define CI_ISP_DPD_HWRGB_888       0x00030000
> +
> +#define CI_ISP_DPD_YUV_420     0x00040000
> +#define CI_ISP_DPD_YUV_422     0x00050000
> +#define CI_ISP_DPD_YUV_NV12    0x00060000
> +#define CI_ISP_DPD_YUV_YUYV    0x00070000
> +
> +/* input mode mask (2 bits) */
> +#define CI_ISP_DPD_DMA_IN_MASK    0x00180000
> +/* input is YCbCr 422 */
> +#define CI_ISP_DPD_DMA_IN_422      0x00000000
> +/* input is YCbCr 444 */
> +#define CI_ISP_DPD_DMA_IN_444      0x00080000
> +/* input is YCbCr 420 */
> +#define CI_ISP_DPD_DMA_IN_420      0x00100000
> +/* input is YCbCr 411 */
> +#define CI_ISP_DPD_DMA_IN_411      0x00180000
> +
> +/*
> + * Upscaling interpolation mode (tells how newly created pixels
> + * will be interpolated from the existing ones)
> + * Upscaling interpolation mode mask (2 bits, not all combinations
> + * used yet)
> + */
> +#define CI_ISP_DPD_UPSCALE_MASK       0x00600000
> +/* smooth edges, linear interpolation */
> +#define CI_ISP_DPD_UPSCALE_SMOOTH_LIN  0x00000000
> +/*
> + * sharp edges, no interpolation, just duplicate pixels, creates
> + * the typical 'blocky' effect.
> + */
> +#define CI_ISP_DPD_UPSCALE_SHARP       0x00200000
> +
> +/*
> + * additional luminance phase shift
> + * apply horizontal luminance phase shift by half the sample distance
> + */
> +#define CI_ISP_DPD_LUMA_HSHIFT     0x00800000
> +/* apply vertical luminance phase shift by half the sample distance */
> +#define CI_ISP_DPD_LUMA_VSHIFT     0x01000000
> +
> +/*
> + * picture flipping and rotation
> + * Note that when combining the flags, the rotation is applied first.
> + * This enables to configure all 8 possible orientations
> + */
> +
> +/* horizontal flipping - same as mirroring */
> +#define CI_ISP_DPD_H_FLIP          CI_ISP_DPD_MIRROR
> +/* vertical flipping */
> +#define CI_ISP_DPD_V_FLIP          0x02000000
> +/* rotation 90 degrees counter-clockwise */
> +#define CI_ISP_DPD_90DEG_CCW       0x04000000
> +
> +/*
> + * switch to differentiate between full range of values for YCbCr (0-255)
> + * and restricted range (16-235 for Y) (16-240 for CbCr)'
> + * if set leads to unrestricted range (0-255) for YCbCr
> + * package length of a system interface transfer
> + */
> +#define CI_ISP_DPD_YCBCREXT        0x10000000
> +/* burst mask (2 bits) */
> +#define CI_ISP_DPD_BURST_MASK      0x60000000
> +/* AHB 4 beat burst */
> +#define CI_ISP_DPD_BURST_4          0x00000000
> +/* AHB 8 beat burst */
> +#define CI_ISP_DPD_BURST_8          0x20000000
> +/* AHB 16 beat burst */
> +#define CI_ISP_DPD_BURST_16         0x40000000
> +
> +/* configures main and self datapathes and scaler for data coming from the
> + * ISP */
> +
> +
> +int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
> +                         const struct ci_isp_datapath_desc *main,
> +                         const struct ci_isp_datapath_desc *self, int zoom);
> +/* Initialization of the Bad Pixel Detection and Correction */
> +int ci_bp_init(
> +       const struct ci_isp_bp_corr_config *bp_corr_config,
> +       const struct ci_isp_bp_det_config *bp_det_config
> +);
> +/* Disable Bad Pixel Correction and dectection */
> +int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config);
> +/* Capture a whole JPEG snapshot */
> +u32 ci_jpe_capture(enum ci_isp_conf_update_time update_time);
> +int ci_jpe_encode(enum ci_isp_conf_update_time update_time,
> +       enum ci_isp_jpe_enc_mode mrv_jpe_encMode);
> +void ci_isp_set_yc_mode(void);
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/reg_access.h b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
> new file mode 100644
> index 0000000..6e05f72
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
> @@ -0,0 +1,220 @@
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
> +#ifndef _REG_ACCESS_H
> +#define _REG_ACCESS_H
> +
> +/*
> + * Notes:
> + *
> + * registers:
> + * - use these macros to allow a central way e.g. to print out debug
> + *   information on register access
> + *
> + *   slices:
> + * - "parameter" \a reg could be a hardware register or a (32bit) variable,
> + *   but not a pointer!
> + * - each slice (specified as "parameter" \a name) requires two \#defines:
> + *   \b \<name\>_MASK  : defines the mask to use on register side
> + *   \b \<name\>_SHIFT : defines the shift value to use (left on write, right
> + *   on read)
> + *
> + * arrays:
> + * - "parameter" \a areg could be an (32bit) array or a pointer to the
> + *   first array element
> + * - each one-dimensional array (specified as "parameter" \a name) requires
> + *   one \#define
> + * - <tt> \<name\>_ARR_SIZE </tt>: number of elements
> + * - each two-dimensional array (specified as "parameter" <name>) requires
> + *   four \#defines:
> + * - <tt> \<name\>_ARR_SIZE1 </tt>: number of elements in first dimension
> + * - <tt> \<name\>_ARR_SIZE2 </tt>: number of elements in second dimension
> + * - <tt> \<name\>_ARR_OFS1  </tt>: offset between two consecutive elements
> + *   in first dimension
> + * - <tt> \<name\>_ARR_OFS2  </tt>: offset between two consecutive elements
> + *   in second dimension
> + */

Please don't reinvent the wheel. For documenting function parameters, you
should use, instead, kernel-doc format, as explained at:
	Documentation/kernel-doc-nano-HOWTO.txt

This applies to all function comments on your code.

> +
> +/*
> + * reads and returns the complete value of register \a reg
> + * \note Use these macro to allow a central way e.g. to print out debug
> + * information on register access.
> + */
> +
> +/* helper function to let REG_READ return the value */
> +
> +static inline u32 _reg_read(u32 reg, const char *text)
> +{
> +       u32 variable = reg;
> +       DBG_DD2((text, variable));
> +       return variable;
> +}
> +
> +#define REG_READ(reg) \
> +_reg_read((reg),  "R(" VAL2STR(reg) "): 0x%08X\n")

Please properly indent it.

> +
> +static inline u32 _reg_read_ex(u32 reg, const char *text)
> +{
> +       u32 variable = reg;
> +       DBG_DD2((text, variable));
> +       return variable;
> +}
> +
> +#define REG_READ_EX(reg) \
> +_reg_read_ex((reg),  "R(" VAL2STR(reg) "): 0x%08X\n")

Please properly indent it.

> +/*
> + * writes the complete value \a value into register \a reg
> + * \note Use these macro to allow a central way e.g. to print out debug
> + * information on register access.
> + */
> +#define REG_WRITE(reg, value) \
> +{ \
> +       DBG_DD2(( \
> +       "W(" VAL2STR(reg) ", " VAL2STR(value) "): 0x%08X\n", (value))); \
> +       (reg) = (value); \
> +}
> +
> +#define REG_WRITE_EX(reg, value) \
> +{ \
> +       (reg) = (value); \
> +}

Please properly indent it.

> +
> +
> +/*
> + * returns the value of slice \a name from register or variable \a reg
> + * \note "parameter" \a reg could be a hardware register or a (32bit)
> + * variable, but not a pointer! \n
> + * each slice (specified as "parameter" \a name) requires two \#defines: \n
> + * - <tt>\<name\>_MASK  </tt>: defines the mask to use on register side
> + * - <tt>\<name\>_SHIFT </tt>: defines the shift value to use (left on write,
> + *   right on read)
> + */
> +static inline u32 _reg_get_slice(const char *text, u32 val)
> +{
> +       u32 variable = val;
> +       DBG_DD2((text, variable));
> +       return val;
> +}
> +
> +#define REG_GET_SLICE_EX(reg, name) \
> +       (((reg) & (name##_MASK)) >> (name##_SHIFT))
> +
> +#define REG_GET_SLICE(reg, name) \
> +       _reg_get_slice("R(" VAL2STR(reg) "): 0x%08X\n" , \
> +       (((reg) & (name##_MASK)) >> (name##_SHIFT)))
> +
> +/*
> + * writes the value \a value into slice \a name of register or variable \a reg
> + * \note "parameter" \a reg could be a hardware register or a (32bit) variable,
> + * but not a pointer! \n
> + * each slice (specified as "parameter" \a name) requires two \#defines: \n
> + * - <tt>\<name\>_MASK  </tt>: defines the mask to use on register side
> + * - <tt>\<name\>_SHIFT </tt>: defines the shift value to use (left on write,
> + *   right on read)
> + */
> +#define REG_SET_SLICE(reg, name, value) \
> +{ \
> +       DBG_DD2(( \
> +               "W(" VAL2STR(reg) ", " VAL2STR(value) "): 0x%08X\n", \
> +               (value)));      \
> +               ((reg) = (((reg) & ~(name##_MASK)) | \
> +               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
> +}
> +
> +#define REG_SET_SLICE_EX(reg, name, value) \
> +{ \
> +               ((reg) = (((reg) & ~(name##_MASK)) | \
> +               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
> +}

Please properly indent this and all other #defines bellow with more than one line.

The proper way to define the above would be as defined in Documentation/CodingStyle, chapter 12:

Macros with multiple statements should be enclosed in a do - while block:

#define macrofun(a, b, c)                       \
        do {                                    \
                if (a == 5)                     \
                        do_this(b, c);          \
        } while (0)



> +
> +/*
> + * returns the value of element \a idx from register array or array variable \a
> + * areg
> + * \note "parameter" \a areg could be an (32bit) array or a pointer to the first
> + * array element \n
> + * each one-dimensional array (specified as "parameter" \a name) requires one
> + * \#define: \n
> + *        - <tt>\<name\>_ARR_SIZE </tt>: number of elements
> + */
> +#define REG_GET_ARRAY_ELEM1(areg, name, idx) \
> +((idx < name##_ARR_SIZE) \
> +? areg[idx] \
> +: 0)
> +
> +
> +/*
> + * writes the value \a value into element \a idx of register array or array
> + * variable \a areg
> + * \note "parameter" \a areg could be an (32bit) array or a pointer to the
> + * first array element \n
> + *       each one-dimensional array (specified as "parameter" \a name) requires
> + *       one \#define: \n
> + *        - <tt>\<name\>_ARR_SIZE </tt>: number of elements
> + */
> +#define REG_SET_ARRAY_ELEM1(areg, name, idx, value) \
> +((idx < name##_ARR_SIZE) \
> +? areg[idx] = value \
> +: 0)
> +
> +
> +/*
> + * returns the value of element \a idx1, \a idx2 from two-dimensional register
> + * array or array variable \a areg
> + * \note "parameter" \a areg could be an (32bit) array or a pointer to the
> + * first array element \n
> + *       each two-dimensional array (specified as "parameter" \a name) requires
> + *       four \#defines:
> + *        - <tt>\<name\>_ARR_SIZE1 </tt>: number of elements in first dimension
> + *        - <tt>\<name\>_ARR_SIZE2 </tt>: number of elements in second dimension
> + *        - <tt>\<name\>_ARR_OFS1  </tt>: offset between two consecutive
> + *        elements in first dimension
> + *        - <tt>\<name\>_ARR_OFS2  </tt>: offset between two consecutive
> + *        elements in second dimension
> + */
> +#define REG_GET_ARRAY_ELEM2(areg, name, idx1, idx2) \
> +(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
> +? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] \
> +: 0)
> +
> +
> +/*
> + * writes the value \a value into element \a idx1, \a idx2 of two-dimensional
> + * register array or array variable \a areg
> + * \note "parameter" \a areg could be an (32bit) array or a pointer to the
> + * first array element \n
> + *       each two-dimensional array (specified as "parameter" \a name) requires
> + *       four \#defines:
> + *        - <tt>\<name\>_ARR_SIZE1 </tt>: number of elements in first dimension
> + *        - <tt>\<name\>_ARR_SIZE2 </tt>: number of elements in second dimension
> + *        - <tt>\<name\>_ARR_OFS1  </tt>: offset between two consecutive
> + *        elements in first dimension
> + *        - <tt>\<name\>_ARR_OFS2  </tt>: offset between two consecutive
> + *        elements in second dimension
> + */
> +#define REG_SET_ARRAY_ELEM2(areg, name, idx1, idx2, value) \
> +(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
> +? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] = value \
> +: 0)
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/stdinc.h b/drivers/media/video/mrstci/mrstisp/include/stdinc.h
> new file mode 100644
> index 0000000..7b1b7b9
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/stdinc.h
> @@ -0,0 +1,114 @@
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
> +#ifndef _STDINC_H
> +#define _STDINC_H
> +
> +#ifdef __KERNEL__
> +#include <linux/module.h>
> +#include <linux/version.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +
> +#include <linux/proc_fs.h>
> +#include <linux/ctype.h>
> +#include <linux/pagemap.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +
> +
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/string.h>
> +/* kmalloc, kfree, etc */
> +#include <linux/slab.h>
> +/* vmalloc, vfree, etc */
> +#include <linux/vmalloc.h>
> +#include <linux/types.h>       /* pic_t, size_t, __u32, etc */
> +#include <linux/errno.h>       /* error codes */
> +#include <linux/sched.h>       /* suser(), capable() replacement */
> +#include <linux/moduleparam.h> /* module_param() */
> +#include <linux/smp_lock.h>    /* kernel_locked */
> +#include <asm/kmap_types.h>    /* page table entry lookup */
> +#include <linux/pci.h>         /* pci_find_class, etc */
> +#include <linux/interrupt.h>   /* tasklets, interrupt helpers */
> +#include <linux/timer.h>
> +#include <asm/system.h>                /* cli, sli, save_flags */
> +#include <asm/page.h>          /* PAGE_OFFSET */
> +#include <asm/pgtable.h>       /* pte bit definitions */
> +#include <linux/time.h>                /* for do_gettimeofday */
> +
> +#ifdef CONFIG_KMOD
> +#include <linux/kmod.h>
> +#endif
> +
> +#include "def.h"
> +#include "ci_sensor_isp.h"
> +
> +void intel_timer_start(void);
> +void intel_timer_stop(void);
> +unsigned long intel_get_micro_sec(void);
> +void intel_sleep_micro_sec(unsigned long micro_sec);
> +unsigned long intel_get_micro_sec(void);
> +void intel_sleep_micro_sec(unsigned long micro_sec);
> +
> +#include "mrv.h"
> +#include "mrv_priv.h"
> +#include "mrv_sls.h"
> +#include "debug.h"
> +#include "ci_isp_common.h"
> +
> +#include "intel_v4l2.h"
> +
> +#define MEM_CSC_REG_BASE                (0x08500000)
> +extern struct intel_isp_device *g_intel;
> +#define MEM_MRV_REG_BASE (g_intel->regs)
> +
> +extern int km_debug;
> +#define DBG_DD(x) \
> +       do { \
> +               if (km_debug >= 1) {    \
> +                       printk(KERN_INFO ">>mrstisp: %s@", __func__);   \
> +                       printk x; \
> +               }       \
> +       } while (0)
> +
> +#define DBG_DD2(x) \
> +       do { \
> +               if (km_debug >= 2) {    \
> +                       printk(KERN_INFO ">>**mrstisp: %s ", __func__); \
> +                       printk x; \
> +               }       \
> +       } while (0)
> +
> +#include "reg_access.h"
> +#endif
> +#endif
> --
> 1.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
