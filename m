Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56060 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752853AbdJTJ6D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 05:58:03 -0400
Date: Fri, 20 Oct 2017 12:58:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, jerry.w.hu@intel.com
Subject: Re: [PATCH v3 08/12] intel-ipu3: params: compute and program ccs
Message-ID: <20171020095800.iapx2v3uukeohq2f@valkosipuli.retiisi.org.uk>
References: <1500434023-2411-1-git-send-email-yong.zhi@intel.com>
 <1500434023-2411-6-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500434023-2411-6-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Jul 18, 2017 at 10:13:40PM -0500, Yong Zhi wrote:
> A collection of routines that are mainly responsible
> to calculate the acc parameters.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-css-params.c | 3114 ++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-params.h |  105 +
>  drivers/media/pci/intel/ipu3/ipu3-css.h        |   92 +
>  3 files changed, 3311 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-params.h
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-params.c b/drivers/media/pci/intel/ipu3/ipu3-css-params.c
> new file mode 100644
> index 0000000..4b600bc
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-params.c
> @@ -0,0 +1,3114 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +
> +#include "ipu3-abi.h"
> +#include "ipu3-css.h"
> +#include "ipu3-css-fw.h"
> +#include "ipu3-css-params.h"
> +#include "ipu3-tables.h"
> +
> +static unsigned int ipu3_css_scaler_get_exp(unsigned int counter,
> +					    unsigned int divider)
> +{
> +	int i = fls(divider) - fls(counter);
> +
> +	if (i <= 0)
> +		return 0;
> +
> +	if (divider >> i < counter)
> +		i = i - 1;

i--;

> +
> +	return i;
> +}
> +
> +/* Set up the CSS scaler look up table */
> +static void ipu3_css_scaler_setup_lut(unsigned int taps,
> +				      unsigned int input_width,
> +				      unsigned int output_width,
> +				      int phase_step_correction,
> +				      const int *coeffs,
> +				      unsigned int coeffs_size,
> +				      s8 coeff_lut[IMGU_SCALER_PHASES *
> +						   IMGU_SCALER_FILTER_TAPS],
> +				      struct ipu3_css_scaler_info *info)
> +{
> +	int tap;
> +	int phase;
> +	int exponent = ipu3_css_scaler_get_exp(output_width, input_width);
> +	int mantissa = (1 << exponent) * output_width;
> +	unsigned int phase_step = 0;
> +	int phase_sum_left = 0;
> +	int phase_sum_right = 0;
> +
> +	for (phase = 0; phase < IMGU_SCALER_PHASES; phase++) {
> +		for (tap = 0; tap < taps; tap++) {
> +			/* flip table to for convolution reverse indexing */
> +			s64 coeff =  coeffs[coeffs_size -
> +						((tap * (coeffs_size / taps)) +
> +						phase) - 1];
> +			coeff *= mantissa;
> +			coeff /= input_width;

Please use do_div() so this will compile on 32-bit machines.

> +
> +			/* Add +"0.5" */
> +			coeff += 1 << (IMGU_SCALER_COEFF_BITS - 1);
> +			coeff >>= IMGU_SCALER_COEFF_BITS;
> +
> +			coeff_lut[phase * IMGU_SCALER_FILTER_TAPS + tap] =
> +				coeff;
> +		}
> +	}
> +
> +	phase_step = IMGU_SCALER_PHASES *
> +			(1 << IMGU_SCALER_PHASE_COUNTER_PREC_REF)
> +			* output_width / input_width;
> +	phase_step += phase_step_correction;
> +	phase_sum_left = (taps / 2 * IMGU_SCALER_PHASES *
> +			(1 << IMGU_SCALER_PHASE_COUNTER_PREC_REF))
> +			- (1 << (IMGU_SCALER_PHASE_COUNTER_PREC_REF - 1));
> +	phase_sum_right = (taps / 2 * IMGU_SCALER_PHASES *
> +			(1 << IMGU_SCALER_PHASE_COUNTER_PREC_REF))
> +			+ (1 << (IMGU_SCALER_PHASE_COUNTER_PREC_REF - 1));
> +
> +	info->exp_shift = IMGU_SCALER_MAX_EXPONENT_SHIFT - exponent;
> +	info->pad_left = (phase_sum_left % phase_step == 0) ?
> +		phase_sum_left / phase_step - 1 : phase_sum_left / phase_step;
> +	info->pad_right = (phase_sum_right % phase_step == 0) ?
> +		phase_sum_right / phase_step - 1 : phase_sum_right / phase_step;
> +	info->phase_init = phase_sum_left - phase_step * info->pad_left;
> +	info->phase_step = phase_step;
> +	info->crop_left = taps - 1;
> +	info->crop_top = taps - 1;
> +}
> +
> +/*
> + * Calculates the exact output image width/height, based on phase_step setting
> + * (must be perfectly aligned with hardware).
> + */
> +static unsigned int ipu3_css_scaler_calc_scaled_output(unsigned int input,
> +					struct ipu3_css_scaler_info *info)
> +{
> +	unsigned int arg1 = input * info->phase_step +
> +		(1 - IMGU_SCALER_TAPS_Y / 2) *
> +		IMGU_SCALER_FIR_PHASES - IMGU_SCALER_FIR_PHASES
> +		/ (2 * IMGU_SCALER_PHASES);
> +	unsigned int arg2 = ((IMGU_SCALER_TAPS_Y / 2) * IMGU_SCALER_FIR_PHASES
> +		+ IMGU_SCALER_FIR_PHASES / (2 * IMGU_SCALER_PHASES))
> +		* IMGU_SCALER_FIR_PHASES + info->phase_step / 2;
> +
> +	return ((arg1 + (arg2 - IMGU_SCALER_FIR_PHASES * info->phase_step)
> +		/ IMGU_SCALER_FIR_PHASES) / (2 * IMGU_SCALER_FIR_PHASES)) * 2;
> +}
> +
> +/*
> + * Calculate the output width and height, given the luma
> + * and chroma details of a scaler
> + */
> +static int ipu3_css_scaler_calc(u32 input_width, u32 input_height,
> +				u32 target_width, u32 target_height,
> +				struct ipu3_uapi_osys_config *cfg,
> +				struct ipu3_css_scaler_info *info_luma,
> +				struct ipu3_css_scaler_info *info_chroma,
> +				unsigned int *output_width,
> +				unsigned int *output_height)
> +{
> +	u32 out_width = target_width;
> +	u32 out_height = target_height;
> +	unsigned int height_alignment = 2;
> +	int phase_step_correction = -1;
> +
> +	/*
> +	 * Calculate scaled output width. If the horizontal and vertical scaling
> +	 * factor is different, then choose the biggest and crop off excess
> +	 * lines or columns after formatting.
> +	 */
> +	if (target_height * input_width > target_width * input_height)
> +		target_width = DIV_ROUND_UP(target_height * input_width,
> +			input_height);
> +
> +	memset(&cfg->scaler_coeffs_chroma, 0,
> +		sizeof(cfg->scaler_coeffs_chroma));
> +	memset(&cfg->scaler_coeffs_luma, 0, sizeof(*cfg->scaler_coeffs_luma));
> +	do {
> +		phase_step_correction++;
> +
> +		ipu3_css_scaler_setup_lut(IMGU_SCALER_TAPS_Y,
> +					  input_width, target_width,
> +					  phase_step_correction,
> +					  ipu3_css_downscale_4taps,
> +					  IMGU_SCALER_DOWNSCALE_4TAPS_LEN,
> +					  cfg->scaler_coeffs_luma, info_luma);
> +
> +		ipu3_css_scaler_setup_lut(IMGU_SCALER_TAPS_UV,
> +					  input_width, target_width,
> +					  phase_step_correction,
> +					  ipu3_css_downscale_2taps,
> +					  IMGU_SCALER_DOWNSCALE_2TAPS_LEN,
> +					  cfg->scaler_coeffs_chroma,
> +					  info_chroma);
> +
> +		out_width = ipu3_css_scaler_calc_scaled_output(input_width,
> +							       info_luma);
> +		out_height = ipu3_css_scaler_calc_scaled_output(input_height,
> +								info_luma);
> +	} while ((out_width < target_width || out_height < target_height
> +		  || !IS_ALIGNED(out_height, height_alignment))
> +		 && phase_step_correction <= 5);
> +
> +	*output_width = out_width;
> +	*output_height = out_height;
> +
> +	return 0;
> +}
> +
> +/********************** Osys routines for scaler*****************************/
> +
> +/* FIXME:
> + * The OSYS formats could be added nicely into table
> + * "ipu3_css_formats", avoiding the "switch...case" here.
> + */

I think the switch below is entirely reasonable, no need for such a
comment.

> +static void ipu3_css_osys_set_format(enum imgu_abi_frame_format host_format,
> +				     unsigned int *osys_format,
> +				     unsigned int *osys_tiling)
> +{
> +	*osys_format = IMGU_ABI_OSYS_FORMAT_YUV420;
> +	*osys_tiling = IMGU_ABI_OSYS_TILING_NONE;
> +
> +	switch (host_format) {
> +	case IMGU_ABI_FRAME_FORMAT_YUV420:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_YUV420;
> +		break;
> +	case IMGU_ABI_FRAME_FORMAT_YV12:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_YV12;
> +		break;
> +	case IMGU_ABI_FRAME_FORMAT_NV12:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_NV12;
> +		break;
> +	case IMGU_ABI_FRAME_FORMAT_NV16:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_NV16;
> +		break;
> +	case IMGU_ABI_FRAME_FORMAT_NV21:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_NV21;
> +		break;
> +	case IMGU_ABI_FRAME_FORMAT_NV12_TILEY:
> +		*osys_format = IMGU_ABI_OSYS_FORMAT_NV12;
> +		*osys_tiling = IMGU_ABI_OSYS_TILING_Y;
> +		break;
> +	default:
> +		/* For now, assume use default values */
> +		break;
> +	}
> +}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
