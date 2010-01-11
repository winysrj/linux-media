Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:52925 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0AKVip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 16:38:45 -0500
Received: by pzk26 with SMTP id 26so12547326pzk.4
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 13:38:45 -0800 (PST)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH - v4 2/4] V4L-vpfe-capture-converting dm355 ccdc driver to a platform driver
References: <1263237778-22361-1-git-send-email-m-karicheri2@ti.com>
	<1263237778-22361-2-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 11 Jan 2010 13:38:41 -0800
In-Reply-To: <1263237778-22361-2-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Mon\, 11 Jan 2010 14\:22\:56 -0500")
Message-ID: <874omsnwym.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Rebased to latest linux-next tree 
>
> Updated based on Kevin's comments on clock configuration.

Since the above comments are useful for reviewers but not for the git
history, the should come after the '---' separator.  That way they
are not included in the git history.

Kevin

> The ccdc now uses a generic name for clocks. "master" and "slave". On individual platforms
> these clocks will inherit from the platform specific clock. This will allow re-use of
> the driver for the same IP across different SoCs.
>
> Following are the changes done:-
> 	1) clocks are configured using generic clock names
> 	2) converting the driver to a platform driver
> 	3) cleanup - consolidate all static variables inside a structure, ccdc_cfg
>
> Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to linux-next branch of v4l-dvb
>  drivers/media/video/davinci/dm355_ccdc.c |  409 +++++++++++++++++++-----------
>  1 files changed, 256 insertions(+), 153 deletions(-)
>
> diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
> index 3143900..fc716ed 100644
> --- a/drivers/media/video/davinci/dm355_ccdc.c
> +++ b/drivers/media/video/davinci/dm355_ccdc.c
> @@ -37,8 +37,11 @@
>  #include <linux/platform_device.h>
>  #include <linux/uaccess.h>
>  #include <linux/videodev2.h>
> +#include <linux/clk.h>
> +
>  #include <media/davinci/dm355_ccdc.h>
>  #include <media/davinci/vpss.h>
> +
>  #include "dm355_ccdc_regs.h"
>  #include "ccdc_hw_device.h"
>  
> @@ -46,67 +49,75 @@ MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("CCDC Driver for DM355");
>  MODULE_AUTHOR("Texas Instruments");
>  
> -static struct device *dev;
> -
> -/* Object for CCDC raw mode */
> -static struct ccdc_params_raw ccdc_hw_params_raw = {
> -	.pix_fmt = CCDC_PIXFMT_RAW,
> -	.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
> -	.win = CCDC_WIN_VGA,
> -	.fid_pol = VPFE_PINPOL_POSITIVE,
> -	.vd_pol = VPFE_PINPOL_POSITIVE,
> -	.hd_pol = VPFE_PINPOL_POSITIVE,
> -	.gain = {
> -		.r_ye = 256,
> -		.gb_g = 256,
> -		.gr_cy = 256,
> -		.b_mg = 256
> -	},
> -	.config_params = {
> -		.datasft = 2,
> -		.data_sz = CCDC_DATA_10BITS,
> -		.mfilt1 = CCDC_NO_MEDIAN_FILTER1,
> -		.mfilt2 = CCDC_NO_MEDIAN_FILTER2,
> -		.alaw = {
> -			.gama_wd = 2,
> +static struct ccdc_oper_config {
> +	struct device *dev;
> +	/* CCDC interface type */
> +	enum vpfe_hw_if_type if_type;
> +	/* Raw Bayer configuration */
> +	struct ccdc_params_raw bayer;
> +	/* YCbCr configuration */
> +	struct ccdc_params_ycbcr ycbcr;
> +	/* Master clock */
> +	struct clk *mclk;
> +	/* slave clock */
> +	struct clk *sclk;
> +	/* ccdc base address */
> +	void __iomem *base_addr;
> +} ccdc_cfg = {
> +	/* Raw configurations */
> +	.bayer = {
> +		.pix_fmt = CCDC_PIXFMT_RAW,
> +		.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
> +		.win = CCDC_WIN_VGA,
> +		.fid_pol = VPFE_PINPOL_POSITIVE,
> +		.vd_pol = VPFE_PINPOL_POSITIVE,
> +		.hd_pol = VPFE_PINPOL_POSITIVE,
> +		.gain = {
> +			.r_ye = 256,
> +			.gb_g = 256,
> +			.gr_cy = 256,
> +			.b_mg = 256
>  		},
> -		.blk_clamp = {
> -			.sample_pixel = 1,
> -			.dc_sub = 25
> -		},
> -		.col_pat_field0 = {
> -			.olop = CCDC_GREEN_BLUE,
> -			.olep = CCDC_BLUE,
> -			.elop = CCDC_RED,
> -			.elep = CCDC_GREEN_RED
> -		},
> -		.col_pat_field1 = {
> -			.olop = CCDC_GREEN_BLUE,
> -			.olep = CCDC_BLUE,
> -			.elop = CCDC_RED,
> -			.elep = CCDC_GREEN_RED
> +		.config_params = {
> +			.datasft = 2,
> +			.mfilt1 = CCDC_NO_MEDIAN_FILTER1,
> +			.mfilt2 = CCDC_NO_MEDIAN_FILTER2,
> +			.alaw = {
> +				.gama_wd = 2,
> +			},
> +			.blk_clamp = {
> +				.sample_pixel = 1,
> +				.dc_sub = 25
> +			},
> +			.col_pat_field0 = {
> +				.olop = CCDC_GREEN_BLUE,
> +				.olep = CCDC_BLUE,
> +				.elop = CCDC_RED,
> +				.elep = CCDC_GREEN_RED
> +			},
> +			.col_pat_field1 = {
> +				.olop = CCDC_GREEN_BLUE,
> +				.olep = CCDC_BLUE,
> +				.elop = CCDC_RED,
> +				.elep = CCDC_GREEN_RED
> +			},
>  		},
>  	},
> +	/* YCbCr configuration */
> +	.ycbcr = {
> +		.win = CCDC_WIN_PAL,
> +		.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
> +		.frm_fmt = CCDC_FRMFMT_INTERLACED,
> +		.fid_pol = VPFE_PINPOL_POSITIVE,
> +		.vd_pol = VPFE_PINPOL_POSITIVE,
> +		.hd_pol = VPFE_PINPOL_POSITIVE,
> +		.bt656_enable = 1,
> +		.pix_order = CCDC_PIXORDER_CBYCRY,
> +		.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
> +	},
>  };
>  
>  
> -/* Object for CCDC ycbcr mode */
> -static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
> -	.win = CCDC_WIN_PAL,
> -	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
> -	.frm_fmt = CCDC_FRMFMT_INTERLACED,
> -	.fid_pol = VPFE_PINPOL_POSITIVE,
> -	.vd_pol = VPFE_PINPOL_POSITIVE,
> -	.hd_pol = VPFE_PINPOL_POSITIVE,
> -	.bt656_enable = 1,
> -	.pix_order = CCDC_PIXORDER_CBYCRY,
> -	.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
> -};
> -
> -static enum vpfe_hw_if_type ccdc_if_type;
> -static void *__iomem ccdc_base_addr;
> -static int ccdc_addr_size;
> -
>  /* Raw Bayer formats */
>  static u32 ccdc_raw_bayer_pix_formats[] =
>  		{V4L2_PIX_FMT_SBGGR8, V4L2_PIX_FMT_SBGGR16};
> @@ -118,18 +129,12 @@ static u32 ccdc_raw_yuv_pix_formats[] =
>  /* register access routines */
>  static inline u32 regr(u32 offset)
>  {
> -	return __raw_readl(ccdc_base_addr + offset);
> +	return __raw_readl(ccdc_cfg.base_addr + offset);
>  }
>  
>  static inline void regw(u32 val, u32 offset)
>  {
> -	__raw_writel(val, ccdc_base_addr + offset);
> -}
> -
> -static void ccdc_set_ccdc_base(void *addr, int size)
> -{
> -	ccdc_base_addr = addr;
> -	ccdc_addr_size = size;
> +	__raw_writel(val, ccdc_cfg.base_addr + offset);
>  }
>  
>  static void ccdc_enable(int en)
> @@ -153,12 +158,12 @@ static void ccdc_enable_output_to_sdram(int en)
>  static void ccdc_config_gain_offset(void)
>  {
>  	/* configure gain */
> -	regw(ccdc_hw_params_raw.gain.r_ye, RYEGAIN);
> -	regw(ccdc_hw_params_raw.gain.gr_cy, GRCYGAIN);
> -	regw(ccdc_hw_params_raw.gain.gb_g, GBGGAIN);
> -	regw(ccdc_hw_params_raw.gain.b_mg, BMGGAIN);
> +	regw(ccdc_cfg.bayer.gain.r_ye, RYEGAIN);
> +	regw(ccdc_cfg.bayer.gain.gr_cy, GRCYGAIN);
> +	regw(ccdc_cfg.bayer.gain.gb_g, GBGGAIN);
> +	regw(ccdc_cfg.bayer.gain.b_mg, BMGGAIN);
>  	/* configure offset */
> -	regw(ccdc_hw_params_raw.ccdc_offset, OFFSET);
> +	regw(ccdc_cfg.bayer.ccdc_offset, OFFSET);
>  }
>  
>  /*
> @@ -169,7 +174,7 @@ static int ccdc_restore_defaults(void)
>  {
>  	int i;
>  
> -	dev_dbg(dev, "\nstarting ccdc_restore_defaults...");
> +	dev_dbg(ccdc_cfg.dev, "\nstarting ccdc_restore_defaults...");
>  	/* set all registers to zero */
>  	for (i = 0; i <= CCDC_REG_LAST; i += 4)
>  		regw(0, i);
> @@ -180,30 +185,29 @@ static int ccdc_restore_defaults(void)
>  	regw(CULH_DEFAULT, CULH);
>  	regw(CULV_DEFAULT, CULV);
>  	/* Set default Gain and Offset */
> -	ccdc_hw_params_raw.gain.r_ye = GAIN_DEFAULT;
> -	ccdc_hw_params_raw.gain.gb_g = GAIN_DEFAULT;
> -	ccdc_hw_params_raw.gain.gr_cy = GAIN_DEFAULT;
> -	ccdc_hw_params_raw.gain.b_mg = GAIN_DEFAULT;
> +	ccdc_cfg.bayer.gain.r_ye = GAIN_DEFAULT;
> +	ccdc_cfg.bayer.gain.gb_g = GAIN_DEFAULT;
> +	ccdc_cfg.bayer.gain.gr_cy = GAIN_DEFAULT;
> +	ccdc_cfg.bayer.gain.b_mg = GAIN_DEFAULT;
>  	ccdc_config_gain_offset();
>  	regw(OUTCLIP_DEFAULT, OUTCLIP);
>  	regw(LSCCFG2_DEFAULT, LSCCFG2);
>  	/* select ccdc input */
>  	if (vpss_select_ccdc_source(VPSS_CCDCIN)) {
> -		dev_dbg(dev, "\ncouldn't select ccdc input source");
> +		dev_dbg(ccdc_cfg.dev, "\ncouldn't select ccdc input source");
>  		return -EFAULT;
>  	}
>  	/* select ccdc clock */
>  	if (vpss_enable_clock(VPSS_CCDC_CLOCK, 1) < 0) {
> -		dev_dbg(dev, "\ncouldn't enable ccdc clock");
> +		dev_dbg(ccdc_cfg.dev, "\ncouldn't enable ccdc clock");
>  		return -EFAULT;
>  	}
> -	dev_dbg(dev, "\nEnd of ccdc_restore_defaults...");
> +	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_restore_defaults...");
>  	return 0;
>  }
>  
>  static int ccdc_open(struct device *device)
>  {
> -	dev = device;
>  	return ccdc_restore_defaults();
>  }
>  
> @@ -226,7 +230,7 @@ static void ccdc_setwin(struct v4l2_rect *image_win,
>  	int vert_start, vert_nr_lines;
>  	int mid_img = 0;
>  
> -	dev_dbg(dev, "\nStarting ccdc_setwin...");
> +	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_setwin...");
>  
>  	/*
>  	 * ppc - per pixel count. indicates how many pixels per cell
> @@ -260,45 +264,46 @@ static void ccdc_setwin(struct v4l2_rect *image_win,
>  	regw(vert_start & CCDC_START_VER_ONE_MASK, SLV0);
>  	regw(vert_start & CCDC_START_VER_TWO_MASK, SLV1);
>  	regw(vert_nr_lines & CCDC_NUM_LINES_VER, NLV);
> -	dev_dbg(dev, "\nEnd of ccdc_setwin...");
> +	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_setwin...");
>  }
>  
>  static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
>  {
>  	if (ccdcparam->datasft < CCDC_DATA_NO_SHIFT ||
>  	    ccdcparam->datasft > CCDC_DATA_SHIFT_6BIT) {
> -		dev_dbg(dev, "Invalid value of data shift\n");
> +		dev_dbg(ccdc_cfg.dev, "Invalid value of data shift\n");
>  		return -EINVAL;
>  	}
>  
>  	if (ccdcparam->mfilt1 < CCDC_NO_MEDIAN_FILTER1 ||
>  	    ccdcparam->mfilt1 > CCDC_MEDIAN_FILTER1) {
> -		dev_dbg(dev, "Invalid value of median filter1\n");
> +		dev_dbg(ccdc_cfg.dev, "Invalid value of median filter1\n");
>  		return -EINVAL;
>  	}
>  
>  	if (ccdcparam->mfilt2 < CCDC_NO_MEDIAN_FILTER2 ||
>  	    ccdcparam->mfilt2 > CCDC_MEDIAN_FILTER2) {
> -		dev_dbg(dev, "Invalid value of median filter2\n");
> +		dev_dbg(ccdc_cfg.dev, "Invalid value of median filter2\n");
>  		return -EINVAL;
>  	}
>  
>  	if ((ccdcparam->med_filt_thres < 0) ||
>  	   (ccdcparam->med_filt_thres > CCDC_MED_FILT_THRESH)) {
> -		dev_dbg(dev, "Invalid value of median filter threshold\n");
> +		dev_dbg(ccdc_cfg.dev,
> +			"Invalid value of median filter thresold\n");
>  		return -EINVAL;
>  	}
>  
>  	if (ccdcparam->data_sz < CCDC_DATA_16BITS ||
>  	    ccdcparam->data_sz > CCDC_DATA_8BITS) {
> -		dev_dbg(dev, "Invalid value of data size\n");
> +		dev_dbg(ccdc_cfg.dev, "Invalid value of data size\n");
>  		return -EINVAL;
>  	}
>  
>  	if (ccdcparam->alaw.enable) {
>  		if (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_13_4 ||
>  		    ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) {
> -			dev_dbg(dev, "Invalid value of ALAW\n");
> +			dev_dbg(ccdc_cfg.dev, "Invalid value of ALAW\n");
>  			return -EINVAL;
>  		}
>  	}
> @@ -306,12 +311,14 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
>  	if (ccdcparam->blk_clamp.b_clamp_enable) {
>  		if (ccdcparam->blk_clamp.sample_pixel < CCDC_SAMPLE_1PIXELS ||
>  		    ccdcparam->blk_clamp.sample_pixel > CCDC_SAMPLE_16PIXELS) {
> -			dev_dbg(dev, "Invalid value of sample pixel\n");
> +			dev_dbg(ccdc_cfg.dev,
> +				"Invalid value of sample pixel\n");
>  			return -EINVAL;
>  		}
>  		if (ccdcparam->blk_clamp.sample_ln < CCDC_SAMPLE_1LINES ||
>  		    ccdcparam->blk_clamp.sample_ln > CCDC_SAMPLE_16LINES) {
> -			dev_dbg(dev, "Invalid value of sample lines\n");
> +			dev_dbg(ccdc_cfg.dev,
> +				"Invalid value of sample lines\n");
>  			return -EINVAL;
>  		}
>  	}
> @@ -325,18 +332,18 @@ static int ccdc_set_params(void __user *params)
>  	int x;
>  
>  	/* only raw module parameters can be set through the IOCTL */
> -	if (ccdc_if_type != VPFE_RAW_BAYER)
> +	if (ccdc_cfg.if_type != VPFE_RAW_BAYER)
>  		return -EINVAL;
>  
>  	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
>  	if (x) {
> -		dev_dbg(dev, "ccdc_set_params: error in copying ccdc"
> +		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying ccdc"
>  			"params, %d\n", x);
>  		return -EFAULT;
>  	}
>  
>  	if (!validate_ccdc_param(&ccdc_raw_params)) {
> -		memcpy(&ccdc_hw_params_raw.config_params,
> +		memcpy(&ccdc_cfg.bayer.config_params,
>  			&ccdc_raw_params,
>  			sizeof(ccdc_raw_params));
>  		return 0;
> @@ -347,11 +354,11 @@ static int ccdc_set_params(void __user *params)
>  /* This function will configure CCDC for YCbCr video capture */
>  static void ccdc_config_ycbcr(void)
>  {
> -	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
> +	struct ccdc_params_ycbcr *params = &ccdc_cfg.ycbcr;
>  	u32 temp;
>  
>  	/* first set the CCDC power on defaults values in all registers */
> -	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
> +	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_config_ycbcr...");
>  	ccdc_restore_defaults();
>  
>  	/* configure pixel format & video frame format */
> @@ -403,7 +410,7 @@ static void ccdc_config_ycbcr(void)
>  		regw(CCDC_SDOFST_FIELD_INTERLEAVED, SDOFST);
>  	}
>  
> -	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
> +	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_config_ycbcr...\n");
>  }
>  
>  /*
> @@ -483,7 +490,7 @@ int ccdc_write_dfc_entry(int index, struct ccdc_vertical_dft *dfc)
>  	 */
>  
>  	if (count) {
> -		dev_err(dev, "defect table write timeout !!!\n");
> +		dev_err(ccdc_cfg.dev, "defect table write timeout !!!\n");
>  		return -1;
>  	}
>  	return 0;
> @@ -605,12 +612,12 @@ static void ccdc_config_color_patterns(struct ccdc_col_pat *pat0,
>  /* This function will configure CCDC for Raw mode image capture */
>  static int ccdc_config_raw(void)
>  {
> -	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
> +	struct ccdc_params_raw *params = &ccdc_cfg.bayer;
>  	struct ccdc_config_params_raw *config_params =
> -		&ccdc_hw_params_raw.config_params;
> +					&ccdc_cfg.bayer.config_params;
>  	unsigned int val;
>  
> -	dev_dbg(dev, "\nStarting ccdc_config_raw...");
> +	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_config_raw...");
>  
>  	/* restore power on defaults to register */
>  	ccdc_restore_defaults();
> @@ -659,7 +666,7 @@ static int ccdc_config_raw(void)
>  	val |= (config_params->datasft & CCDC_DATASFT_MASK) <<
>  		CCDC_DATASFT_SHIFT;
>  	regw(val , MODESET);
> -	dev_dbg(dev, "\nWriting 0x%x to MODESET...\n", val);
> +	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to MODESET...\n", val);
>  
>  	/* Configure the Median Filter threshold */
>  	regw((config_params->med_filt_thres) & CCDC_MED_FILT_THRESH, MEDFILT);
> @@ -681,7 +688,7 @@ static int ccdc_config_raw(void)
>  		(config_params->mfilt2 << CCDC_MFILT2_SHIFT));
>  
>  	regw(val, GAMMAWD);
> -	dev_dbg(dev, "\nWriting 0x%x to GAMMAWD...\n", val);
> +	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to GAMMAWD...\n", val);
>  
>  	/* configure video window */
>  	ccdc_setwin(&params->win, params->frm_fmt, 1);
> @@ -706,7 +713,7 @@ static int ccdc_config_raw(void)
>  	/* Configure the Gain  & offset control */
>  	ccdc_config_gain_offset();
>  
> -	dev_dbg(dev, "\nWriting %x to COLPTN...\n", val);
> +	dev_dbg(ccdc_cfg.dev, "\nWriting %x to COLPTN...\n", val);
>  
>  	/* Configure DATAOFST  register */
>  	val = (config_params->data_offset.horz_offset & CCDC_DATAOFST_MASK) <<
> @@ -726,7 +733,7 @@ static int ccdc_config_raw(void)
>  			CCDC_HSIZE_VAL_MASK;
>  
>  		/* adjust to multiple of 32 */
> -		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
> +		dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to HSIZE...\n",
>  		       (((params->win.width) + 31) >> 5) &
>  			CCDC_HSIZE_VAL_MASK);
>  	} else {
> @@ -734,7 +741,7 @@ static int ccdc_config_raw(void)
>  		val |= (((params->win.width * 2) + 31) >> 5) &
>  			CCDC_HSIZE_VAL_MASK;
>  
> -		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
> +		dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to HSIZE...\n",
>  		       (((params->win.width * 2) + 31) >> 5) &
>  			CCDC_HSIZE_VAL_MASK);
>  	}
> @@ -745,34 +752,34 @@ static int ccdc_config_raw(void)
>  		if (params->image_invert_enable) {
>  			/* For interlace inverse mode */
>  			regw(CCDC_SDOFST_INTERLACE_INVERSE, SDOFST);
> -			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
> +			dev_dbg(ccdc_cfg.dev, "\nWriting %x to SDOFST...\n",
>  				CCDC_SDOFST_INTERLACE_INVERSE);
>  		} else {
>  			/* For interlace non inverse mode */
>  			regw(CCDC_SDOFST_INTERLACE_NORMAL, SDOFST);
> -			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
> +			dev_dbg(ccdc_cfg.dev, "\nWriting %x to SDOFST...\n",
>  				CCDC_SDOFST_INTERLACE_NORMAL);
>  		}
>  	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
>  		if (params->image_invert_enable) {
>  			/* For progessive inverse mode */
>  			regw(CCDC_SDOFST_PROGRESSIVE_INVERSE, SDOFST);
> -			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
> +			dev_dbg(ccdc_cfg.dev, "\nWriting %x to SDOFST...\n",
>  				CCDC_SDOFST_PROGRESSIVE_INVERSE);
>  		} else {
>  			/* For progessive non inverse mode */
>  			regw(CCDC_SDOFST_PROGRESSIVE_NORMAL, SDOFST);
> -			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
> +			dev_dbg(ccdc_cfg.dev, "\nWriting %x to SDOFST...\n",
>  				CCDC_SDOFST_PROGRESSIVE_NORMAL);
>  		}
>  	}
> -	dev_dbg(dev, "\nend of ccdc_config_raw...");
> +	dev_dbg(ccdc_cfg.dev, "\nend of ccdc_config_raw...");
>  	return 0;
>  }
>  
>  static int ccdc_configure(void)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
>  		return ccdc_config_raw();
>  	else
>  		ccdc_config_ycbcr();
> @@ -781,23 +788,23 @@ static int ccdc_configure(void)
>  
>  static int ccdc_set_buftype(enum ccdc_buftype buf_type)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		ccdc_hw_params_raw.buf_type = buf_type;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		ccdc_cfg.bayer.buf_type = buf_type;
>  	else
> -		ccdc_hw_params_ycbcr.buf_type = buf_type;
> +		ccdc_cfg.ycbcr.buf_type = buf_type;
>  	return 0;
>  }
>  static enum ccdc_buftype ccdc_get_buftype(void)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		return ccdc_hw_params_raw.buf_type;
> -	return ccdc_hw_params_ycbcr.buf_type;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		return ccdc_cfg.bayer.buf_type;
> +	return ccdc_cfg.ycbcr.buf_type;
>  }
>  
>  static int ccdc_enum_pix(u32 *pix, int i)
>  {
>  	int ret = -EINVAL;
> -	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>  		if (i < ARRAY_SIZE(ccdc_raw_bayer_pix_formats)) {
>  			*pix = ccdc_raw_bayer_pix_formats[i];
>  			ret = 0;
> @@ -813,20 +820,19 @@ static int ccdc_enum_pix(u32 *pix, int i)
>  
>  static int ccdc_set_pixel_format(u32 pixfmt)
>  {
> -	struct ccdc_a_law *alaw =
> -		&ccdc_hw_params_raw.config_params.alaw;
> +	struct ccdc_a_law *alaw = &ccdc_cfg.bayer.config_params.alaw;
>  
> -	if (ccdc_if_type == VPFE_RAW_BAYER) {
> -		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
> +		ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
>  		if (pixfmt == V4L2_PIX_FMT_SBGGR8)
>  			alaw->enable = 1;
>  		else if (pixfmt != V4L2_PIX_FMT_SBGGR16)
>  			return -EINVAL;
>  	} else {
>  		if (pixfmt == V4L2_PIX_FMT_YUYV)
> -			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
> +			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
>  		else if (pixfmt == V4L2_PIX_FMT_UYVY)
> -			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
> +			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
>  		else
>  			return -EINVAL;
>  	}
> @@ -834,17 +840,16 @@ static int ccdc_set_pixel_format(u32 pixfmt)
>  }
>  static u32 ccdc_get_pixel_format(void)
>  {
> -	struct ccdc_a_law *alaw =
> -		&ccdc_hw_params_raw.config_params.alaw;
> +	struct ccdc_a_law *alaw = &ccdc_cfg.bayer.config_params.alaw;
>  	u32 pixfmt;
>  
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
>  		if (alaw->enable)
>  			pixfmt = V4L2_PIX_FMT_SBGGR8;
>  		else
>  			pixfmt = V4L2_PIX_FMT_SBGGR16;
>  	else {
> -		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
> +		if (ccdc_cfg.ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
>  			pixfmt = V4L2_PIX_FMT_YUYV;
>  		else
>  			pixfmt = V4L2_PIX_FMT_UYVY;
> @@ -853,53 +858,53 @@ static u32 ccdc_get_pixel_format(void)
>  }
>  static int ccdc_set_image_window(struct v4l2_rect *win)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		ccdc_hw_params_raw.win = *win;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		ccdc_cfg.bayer.win = *win;
>  	else
> -		ccdc_hw_params_ycbcr.win = *win;
> +		ccdc_cfg.ycbcr.win = *win;
>  	return 0;
>  }
>  
>  static void ccdc_get_image_window(struct v4l2_rect *win)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		*win = ccdc_hw_params_raw.win;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		*win = ccdc_cfg.bayer.win;
>  	else
> -		*win = ccdc_hw_params_ycbcr.win;
> +		*win = ccdc_cfg.ycbcr.win;
>  }
>  
>  static unsigned int ccdc_get_line_length(void)
>  {
>  	struct ccdc_config_params_raw *config_params =
> -		&ccdc_hw_params_raw.config_params;
> +				&ccdc_cfg.bayer.config_params;
>  	unsigned int len;
>  
> -	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>  		if ((config_params->alaw.enable) ||
>  		    (config_params->data_sz == CCDC_DATA_8BITS))
> -			len = ccdc_hw_params_raw.win.width;
> +			len = ccdc_cfg.bayer.win.width;
>  		else
> -			len = ccdc_hw_params_raw.win.width * 2;
> +			len = ccdc_cfg.bayer.win.width * 2;
>  	} else
> -		len = ccdc_hw_params_ycbcr.win.width * 2;
> +		len = ccdc_cfg.ycbcr.win.width * 2;
>  	return ALIGN(len, 32);
>  }
>  
>  static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		ccdc_hw_params_raw.frm_fmt = frm_fmt;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		ccdc_cfg.bayer.frm_fmt = frm_fmt;
>  	else
> -		ccdc_hw_params_ycbcr.frm_fmt = frm_fmt;
> +		ccdc_cfg.ycbcr.frm_fmt = frm_fmt;
>  	return 0;
>  }
>  
>  static enum ccdc_frmfmt ccdc_get_frame_format(void)
>  {
> -	if (ccdc_if_type == VPFE_RAW_BAYER)
> -		return ccdc_hw_params_raw.frm_fmt;
> +	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
> +		return ccdc_cfg.bayer.frm_fmt;
>  	else
> -		return ccdc_hw_params_ycbcr.frm_fmt;
> +		return ccdc_cfg.ycbcr.frm_fmt;
>  }
>  
>  static int ccdc_getfid(void)
> @@ -916,14 +921,14 @@ static inline void ccdc_setfbaddr(unsigned long addr)
>  
>  static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
>  {
> -	ccdc_if_type = params->if_type;
> +	ccdc_cfg.if_type = params->if_type;
>  
>  	switch (params->if_type) {
>  	case VPFE_BT656:
>  	case VPFE_YCBCR_SYNC_16:
>  	case VPFE_YCBCR_SYNC_8:
> -		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
> -		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
> +		ccdc_cfg.ycbcr.vd_pol = params->vdpol;
> +		ccdc_cfg.ycbcr.hd_pol = params->hdpol;
>  		break;
>  	default:
>  		/* TODO add support for raw bayer here */
> @@ -938,7 +943,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
>  	.hw_ops = {
>  		.open = ccdc_open,
>  		.close = ccdc_close,
> -		.set_ccdc_base = ccdc_set_ccdc_base,
>  		.enable = ccdc_enable,
>  		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
>  		.set_hw_if_params = ccdc_set_hw_if_params,
> @@ -959,19 +963,118 @@ static struct ccdc_hw_device ccdc_hw_dev = {
>  	},
>  };
>  
> -static int __init dm355_ccdc_init(void)
> +static int __init dm355_ccdc_probe(struct platform_device *pdev)
>  {
> -	printk(KERN_NOTICE "dm355_ccdc_init\n");
> -	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> -		return -1;
> -	printk(KERN_NOTICE "%s is registered with vpfe.\n",
> -		ccdc_hw_dev.name);
> +	void (*setup_pinmux)(void);
> +	struct resource	*res;
> +	int status = 0;
> +
> +	/*
> +	 * first try to register with vpfe. If not correct platform, then we
> +	 * don't have to iomap
> +	 */
> +	status = vpfe_register_ccdc_device(&ccdc_hw_dev);
> +	if (status < 0)
> +		return status;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		status = -ENODEV;
> +		goto fail_nores;
> +	}
> +
> +	res = request_mem_region(res->start, resource_size(res), res->name);
> +	if (!res) {
> +		status = -EBUSY;
> +		goto fail_nores;
> +	}
> +
> +	ccdc_cfg.base_addr = ioremap_nocache(res->start, resource_size(res));
> +	if (!ccdc_cfg.base_addr) {
> +		status = -ENOMEM;
> +		goto fail_nomem;
> +	}
> +
> +	/* Get and enable Master clock */
> +	ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
> +	if (NULL == ccdc_cfg.mclk) {
> +		status = -ENODEV;
> +		goto fail_nomap;
> +	}
> +	if (clk_enable(ccdc_cfg.mclk)) {
> +		status = -ENODEV;
> +		goto fail_mclk;
> +	}
> +
> +	/* Get and enable Slave clock */
> +	ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
> +	if (NULL == ccdc_cfg.sclk) {
> +		status = -ENODEV;
> +		goto fail_mclk;
> +	}
> +	if (clk_enable(ccdc_cfg.sclk)) {
> +		status = -ENODEV;
> +		goto fail_sclk;
> +	}
> +
> +	/* Platform data holds setup_pinmux function ptr */
> +	if (NULL == pdev->dev.platform_data) {
> +		status = -ENODEV;
> +		goto fail_sclk;
> +	}
> +	setup_pinmux = pdev->dev.platform_data;
> +	/*
> +	 * setup Mux configuration for ccdc which may be different for
> +	 * different SoCs using this CCDC
> +	 */
> +	setup_pinmux();
> +	ccdc_cfg.dev = &pdev->dev;
> +	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
>  	return 0;
> +fail_sclk:
> +	clk_put(ccdc_cfg.sclk);
> +fail_mclk:
> +	clk_put(ccdc_cfg.mclk);
> +fail_nomap:
> +	iounmap(ccdc_cfg.base_addr);
> +fail_nomem:
> +	release_mem_region(res->start, resource_size(res));
> +fail_nores:
> +	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
> +	return status;
>  }
>  
> -static void __exit dm355_ccdc_exit(void)
> +static int dm355_ccdc_remove(struct platform_device *pdev)
>  {
> +	struct resource	*res;
> +
> +	clk_put(ccdc_cfg.mclk);
> +	clk_put(ccdc_cfg.sclk);
> +	iounmap(ccdc_cfg.base_addr);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res)
> +		release_mem_region(res->start, resource_size(res));
>  	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
> +	return 0;
> +}
> +
> +static struct platform_driver dm355_ccdc_driver = {
> +	.driver = {
> +		.name	= "dm355_ccdc",
> +		.owner = THIS_MODULE,
> +	},
> +	.remove = __devexit_p(dm355_ccdc_remove),
> +	.probe = dm355_ccdc_probe,
> +};
> +
> +static int __init dm355_ccdc_init(void)
> +{
> +	return platform_driver_register(&dm355_ccdc_driver);
> +}
> +
> +static void __exit dm355_ccdc_exit(void)
> +{
> +	platform_driver_unregister(&dm355_ccdc_driver);
>  }
>  
>  module_init(dm355_ccdc_init);
> -- 
> 1.6.0.4
