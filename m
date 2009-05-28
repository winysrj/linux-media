Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51584 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbZE1NN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 09:13:57 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Date: Thu, 28 May 2009 15:18:17 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281518.18879.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

most comments here apply to the DM6446 CCDC module as well. Generic comments 
apply throughout the source code.

Hans, I'd appreciate if you could review my comments, as some of them might 
made according to personal preferences more than best practice rules.

On Friday 15 May 2009 20:36:43 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> DM355 CCDC hw module
>
> Adds ccdc hw module for DM355 CCDC. This registers with the bridge
> driver a set of hw_ops for configuring the CCDC for a specific
> decoder device connected to vpfe.
>
> This has the review comments incorporated from previous review
>
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
>
>  drivers/media/video/davinci/dm355_ccdc.c      | 1728
> +++++++++++++++++++++++++ drivers/media/video/davinci/dm355_ccdc_regs.h | 
> 291 +++++
>  include/media/davinci/dm355_ccdc.h            |  477 +++++++
>  3 files changed, 2496 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/dm355_ccdc.c
>  create mode 100644 drivers/media/video/davinci/dm355_ccdc_regs.h
>  create mode 100644 include/media/davinci/dm355_ccdc.h
>
> diff --git a/drivers/media/video/davinci/dm355_ccdc.c
> b/drivers/media/video/davinci/dm355_ccdc.c new file mode 100644
> index 0000000..c6b7742
> --- /dev/null
> +++ b/drivers/media/video/davinci/dm355_ccdc.c
> @@ -0,0 +1,1728 @@
> +/*
> + * Copyright (C) 2005-2009 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + *
> + * CCDC hardware module for DM355
> + * ------------------------------
> + *
> + * This module is for configuring DM355 CCD controller of VPFE to capture
> + * Raw yuv or Bayer RGB data from a decoder. CCDC has several modules
> + * such as Defect Pixel Correction, Color Space Conversion etc to
> + * pre-process the Bayer RGB data, before writing it to SDRAM. This
> + * module also allows application to configure individual
> + * module parameters through VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL.
> + * To do so, application include dm355_ccdc.h and vpfe_capture.h header
> + * files. The setparams() API is called by vpfe_capture driver
> + * to configure module parameters
> + *
> + * TODO: Raw bayer parameter settings and bayer capture
> + * 	 Split module parameter structure to module specific ioctl structs
> + */
> +#include <linux/platform_device.h>
> +#include <linux/uaccess.h>
> +#include <asm/page.h>

Is this one needed ?

> +#include <media/davinci/ccdc_hw_device.h>
> +#include <media/davinci/dm355_ccdc.h>
> +#include "dm355_ccdc_regs.h"
> +
> +static struct device *dev;
> +
> +/*Object for CCDC raw mode */
> +static struct ccdc_params_raw ccdc_hw_params_raw = {
> +	.pix_fmt = CCDC_PIXFMT_RAW,
> +	.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
> +	.win = CCDC_WIN_VGA,
> +	.fid_pol = VPFE_PINPOL_POSITIVE,
> +	.vd_pol = VPFE_PINPOL_POSITIVE,
> +	.hd_pol = VPFE_PINPOL_POSITIVE,
> +	.image_invert_enable = 0,
> +	.data_sz = _10BITS,
> +	.med_filt_thres = 0,
> +	.mfilt1 = NO_MEDIAN_FILTER1,
> +	.mfilt2 = NO_MEDIAN_FILTER2,
> +	.ccdc_offset = 0,
> +	.gain = {
> +		.r_ye = 256,
> +		.gb_g = 256,
> +		.gr_cy = 256,
> +		.b_mg = 256
> +	},
> +	.lpf_enable = 0,
> +	.datasft = 2,
> +	.alaw = {
> +		.b_alaw_enable = 0,
> +		.gama_wd = 2
> +	},
> +	.blk_clamp = {
> +		.b_clamp_enable = 0,
> +		.sample_pixel = 1,
> +		.start_pixel = 0,
> +		.dc_sub = 25
> +	},
> +	.blk_comp = {
> +		.b_comp = 0,
> +		.gb_comp = 0,
> +		.gr_comp = 0,
> +		.r_comp = 0
> +	},
> +	.vertical_dft = {
> +		.ver_dft_en = 0
> +	},
> +	.lens_sh_corr = {
> +		.lsc_enable = 0
> +	},
> +	.data_formatter_r = {
> +		.fmt_enable = 0
> +	},
> +	.color_space_con = {
> +		.csc_enable = 0
> +	},
> +	.col_pat_field0 = {
> +		.olop = CCDC_GREEN_BLUE,
> +		.olep = CCDC_BLUE,
> +		.elop = CCDC_RED,
> +		.elep = CCDC_GREEN_RED
> +	},
> +	.col_pat_field1 = {
> +		.olop = CCDC_GREEN_BLUE,
> +		.olep = CCDC_BLUE,
> +		.elop = CCDC_RED,
> +		.elep = CCDC_GREEN_RED
> +	}
> +};
> +
> +
> +/* Object for CCDC ycbcr mode */
> +static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
> +	.win = CCDC_WIN_PAL,
> +	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
> +	.frm_fmt = CCDC_FRMFMT_INTERLACED,
> +	.fid_pol = VPFE_PINPOL_POSITIVE,
> +	.vd_pol = VPFE_PINPOL_POSITIVE,
> +	.hd_pol = VPFE_PINPOL_POSITIVE,
> +	.bt656_enable = 1,
> +	.pix_order = CCDC_PIXORDER_CBYCRY,
> +	.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
> +};
> +
> +static struct v4l2_queryctrl ccdc_control_info[CCDC_MAX_CONTROLS] = {

Make this an unbounded array and use ARRAY_SIZE(ccdc_control_info) instead of 
CCDC_MAX_CONTROLS.

> +	{
> +		.id = CCDC_CID_R_GAIN,
> +		.name = "R/Ye WB Gain",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 2047,
> +		.step = 1,
> +		.default_value = 256
> +	},
> +	{
> +		.id = CCDC_CID_GR_GAIN,
> +		.name = "Gr/Cy WB Gain",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 2047,
> +		.step = 1,
> +		.default_value = 256
> +	},
> +	{
> +		.id = CCDC_CID_GB_GAIN,
> +		.name = "Gb/G WB Gain",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 2047,
> +		.step = 1,
> +		.default_value = 256
> +	},
> +	{
> +		.id = CCDC_CID_B_GAIN,
> +		.name = "B/Mg WB Gain",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 2047,
> +		.step = 1,
> +		.default_value = 256
> +	},
> +	{
> +		.id = CCDC_CID_OFFSET,
> +		.name = "Offset",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 1023,
> +		.step = 1,
> +		.default_value = 0
> +	}
> +};
> +
> +static struct ccdc_config_params_raw ccdc_hw_params_raw_temp;
> +static enum vpfe_hw_if_type ccdc_if_type;
> +static void *__iomem ccdc_base_addr;
> +static int ccdc_addr_size;
> +static void *__iomem vpss_base_addr;
> +static int vpss_addr_size;
> +
> +#define CCDC_MAX_RAW_BAYER_FORMATS	2
> +#define CCDC_MAX_RAW_YUV_FORMATS	2
> +
> +/* Raw Bayer formats */
> +static enum vpfe_hw_pix_format
> +	ccdc_raw_bayer_hw_formats[CCDC_MAX_RAW_BAYER_FORMATS] =
> +		{VPFE_BAYER_8BIT_PACK_ALAW, VPFE_BAYER};
> +
> +/* Raw YUV formats */
> +static enum vpfe_hw_pix_format
> +	ccdc_raw_yuv_hw_formats[CCDC_MAX_RAW_YUV_FORMATS] =
> +		{VPFE_UYVY, VPFE_YUYV};

Make these two unbounded arrays as well.

> +
> +/* register access routines */
> +static inline u32 regr(u32 offset)
> +{
> +	if (offset <= ccdc_addr_size)

This should be <.

> +		return __raw_readl(ccdc_base_addr + offset);
> +	else {
> +		dev_err(dev, "offset exceeds ccdc register address space\n");
> +		return -1;
> +	}
> +}
> +
> +static inline u32 regw(u32 val, u32 offset)
> +{
> +	if (offset <= ccdc_addr_size) {

This should be <.

> +		__raw_writel(val, ccdc_base_addr + offset);
> +		return val;
> +	} else {
> +		dev_err(dev, "offset exceeds ccdc register address space\n");
> +		return -1;
> +	}
> +}

Can't you check that ccdc_addr_size is big enough in ccdc_set_ccdc_base ? The 
read/write access functions could then be made much simpler.

> +
> +/* register access routines */
> +static inline u32 regr_bl(u32 offset)
> +{
> +	if (offset <= vpss_addr_size)
> +		return __raw_readl(vpss_base_addr + offset);
> +	else {
> +		dev_err(dev, "offset exceeds vpss register address space\n");
> +		return -1;
> +	}
> +}
> +
> +static inline u32 regw_bl(u32 val, u32 offset)
> +{
> +	if (offset <= vpss_addr_size) {
> +		__raw_writel(val, vpss_base_addr + offset);
> +		return val;
> +	} else {
> +		dev_err(dev, "offset exceeds vpss register address space\n");
> +		return -1;
> +	}
> +}
> +static void ccdc_set_ccdc_base(void *addr, int size)
> +{
> +	ccdc_base_addr = addr;
> +	ccdc_addr_size = size;
> +}
> +
> +static void ccdc_set_vpss_base(void *addr, int size)
> +{
> +	vpss_base_addr = addr;
> +	vpss_addr_size = size;
> +}

I've had a quick look at the DM355 and DM6446 datasheets. The CCDC and VPSS 
registers share the same memory block. Can't you use a single resource ?

One nice (and better in my opinion) solution would be to declare a structure 
with all the VPSS/CCDC registers as they are implemented in hardware and 
access the structure fields with __raw_read/write*. You would then store a 
single pointer only. Check arch/powerpc/include/asm/immap_cpm2.h for an 
example.

> +
> +static void ccdc_enable(int en)
> +{
> +	unsigned int temp;
> +	temp = regr(SYNCEN);
> +	temp &= (~0x1);
> +	temp |= (en & 0x01);
> +	regw(temp, SYNCEN);
> +}
> +
> +static void ccdc_enable_output_to_sdram(int en)
> +{
> +	unsigned int temp;
> +	temp = regr(SYNCEN);
> +	temp &= (~(0x1 << 1));
> +	temp |= (en & 0x01) << 1;
> +	regw(temp, SYNCEN);
> +}

Please define constants for the register bits instead of using magic values.

#define	CCDC_SYNCEN_VDHDEN	(1 << 0)
#define	CCDC_SYNCEN_WEN		(1 << 1)

> +
> +static void ccdc_config_gain_offset(void)
> +{
> +	/* configure gain */
> +	regw(ccdc_hw_params_raw.gain.r_ye, RYEGAIN);
> +	regw(ccdc_hw_params_raw.gain.gr_cy, GRCYGAIN);
> +	regw(ccdc_hw_params_raw.gain.gb_g, GBGGAIN);
> +	regw(ccdc_hw_params_raw.gain.b_mg, BMGGAIN);
> +	/* configure offset */
> +	regw(ccdc_hw_params_raw.ccdc_offset, OFFSET);
> +}
> +
> +/* Query control. Only applicable for Bayer capture */
> +static int ccdc_queryctrl(struct v4l2_queryctrl *qctrl)
> +{
> +	int i, id;
> +	struct v4l2_queryctrl *control = NULL;
> +
> +	dev_dbg(dev, "ccdc_queryctrl: start\n");
> +	if (NULL == qctrl) {

Can this happen ?

> +		dev_err(dev, "ccdc_queryctrl : invalid user ptr\n");
> +		return -EINVAL;
> +	}
> +
> +	if (VPFE_RAW_BAYER != ccdc_if_type) {
> +		dev_err(dev,
> +		       "ccdc_queryctrl : Not doing Raw Bayer Capture\n");
> +		return -EINVAL;
> +	}
> +
> +	id = qctrl->id;
> +	memset(qctrl, 0, sizeof(struct v4l2_queryctrl));
> +	for (i = 0; i < CCDC_MAX_CONTROLS; i++) {
> +		control = &ccdc_control_info[i];
> +		if (control->id == id)
> +			break;
> +	}
> +	if (i == CCDC_MAX_CONTROLS) {
> +		dev_err(dev, "ccdc_queryctrl : Invalid control ID\n");
> +		return -EINVAL;
> +	}
> +	memcpy(qctrl, control, sizeof(struct v4l2_queryctrl));

sizeof(*qctrl)

> +	dev_dbg(dev, "ccdc_queryctrl: end\n");
> +	return 0;
> +}
> +
> +static int ccdc_setcontrol(struct v4l2_control *ctrl)
> +{
> +	int i;
> +	struct v4l2_queryctrl *control = NULL;
> +	struct ccdc_gain *gain =
> +	    &ccdc_hw_params_raw.gain;
> +
> +	if (NULL == ctrl) {
> +		dev_err(dev, "ccdc_setcontrol: invalid user ptr\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ccdc_if_type != VPFE_RAW_BAYER) {
> +		dev_err(dev,
> +		       "ccdc_setcontrol: Not doing Raw Bayer Capture\n");

Should user-triggered errors use dev_err or dev_dbg ? I'm not sure we want to 
fill the kernel log with KERN_ERR message just because an application doesn't 
get its control ids right.

> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < CCDC_MAX_CONTROLS; i++) {
> +		control = &ccdc_control_info[i];
> +		if (control->id == ctrl->id)
> +			break;
> +	}
> +
> +	if (i == CCDC_MAX_CONTROLS) {
> +		dev_err(dev, "ccdc_queryctrl : Invalid control ID, 0x%x\n",
> +		       control->id);
> +		return -EINVAL;
> +	}
> +
> +	if (ctrl->value > control->maximum) {

|| ctrl->value < control->minimum

> +		dev_err(dev, "ccdc_queryctrl : Invalid control value\n");
> +		return -EINVAL;
> +	}
> +
> +	switch (ctrl->id) {
> +	case CCDC_CID_R_GAIN:
> +		gain->r_ye = ctrl->value & CCDC_GAIN_MASK;
> +		break;
> +	case CCDC_CID_GR_GAIN:
> +		gain->gr_cy = ctrl->value & CCDC_GAIN_MASK;
> +		break;
> +	case CCDC_CID_GB_GAIN:
> +		gain->gb_g = ctrl->value  & CCDC_GAIN_MASK;
> +		break;
> +
> +	case CCDC_CID_B_GAIN:
> +		gain->b_mg = ctrl->value  & CCDC_GAIN_MASK;
> +		break;

	case CCDC_CID_OFFSET: ?

> +	default:
> +		ccdc_hw_params_raw.ccdc_offset = ctrl->value & CCDC_OFFSET_MASK;
> +	}
> +
> +	/* set it in hardware */
> +	ccdc_config_gain_offset();

Why don't you set the appropriate register directly instead of writing them 
all ? Only one of them has been changed.

> +	return 0;
> +}
> +
> +static int ccdc_getcontrol(struct v4l2_control *ctrl)
> +{
> +	int i;
> +	struct v4l2_queryctrl *control = NULL;
> +
> +	if (NULL == ctrl) {

Can this happen ?

> +		dev_err(dev, "ccdc_setcontrol: invalid user ptr\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ccdc_if_type != VPFE_RAW_BAYER) {
> +		dev_err(dev,
> +		       "ccdc_setcontrol: Not doing Raw Bayer Capture\n");
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < CCDC_MAX_CONTROLS; i++) {
> +		control = &ccdc_control_info[i];
> +		if (control->id == ctrl->id)
> +			break;
> +	}
> +
> +	if (i == CCDC_MAX_CONTROLS) {
> +		dev_err(dev, "ccdc_queryctrl : Invalid control ID\n");
> +		return -EINVAL;
> +	}
> +
> +	switch (ctrl->id) {
> +	case CCDC_CID_R_GAIN:
> +		ctrl->value = ccdc_hw_params_raw.gain.r_ye;
> +		break;
> +	case CCDC_CID_GR_GAIN:
> +		ctrl->value = ccdc_hw_params_raw.gain.gr_cy;
> +		break;
> +	case CCDC_CID_GB_GAIN:
> +		ctrl->value = ccdc_hw_params_raw.gain.gb_g;
> +		break;
> +	case CCDC_CID_B_GAIN:
> +		ctrl->value = ccdc_hw_params_raw.gain.b_mg;
> +		break;

	case CCDC_CID_OFFSET: ?

> +	default:
> +		/* offset */
> +		ctrl->value = ccdc_hw_params_raw.ccdc_offset;
> +	}
> +	/* set it in hardware */
> +	return 0;
> +}
> +
> +static void ccdc_reset(void)
> +{
> +	int i;
> +	/* disable CCDC */
> +	dev_dbg(dev, "\nstarting ccdc_reset...");
> +	ccdc_enable(0);
> +	/* set all registers to default value */
> +	for (i = 0; i <= 0x15c; i += 4)
> +		regw(0, i);

Ouch ! Not all registers have a 0 default value. Beside, blindly resetting all 
registers sounds hackish. According to the documentation, the proper way to 
reset the VPFE/VPSS is through the power & sleep controller.

> +	/* no culling support */
> +	regw(0xffff, CULH);
> +	regw(0xff, CULV);
> +	/* Set default Gain and Offset */
> +	ccdc_hw_params_raw.gain.r_ye = 256;
> +	ccdc_hw_params_raw.gain.gb_g = 256;
> +	ccdc_hw_params_raw.gain.gr_cy = 256;
> +	ccdc_hw_params_raw.gain.b_mg = 256;
> +	ccdc_hw_params_raw.ccdc_offset = 0;
> +	ccdc_config_gain_offset();
> +	/* up to 12 bit sensor */
> +	regw(0x0FFF, OUTCLIP);
> +	/* CCDC input Mux select directly from sensor */
> +	regw_bl(0x00, CCDCMUX);
> +	dev_dbg(dev, "\nEnd of ccdc_reset...");
> +}
> +
> +static int ccdc_open(struct device *device)
> +{
> +	dev = device;
> +	ccdc_reset();
> +	return 0;
> +}
> +
> +static int ccdc_close(struct device *device)
> +{
> +	/* do nothing for now */
> +	return 0;
> +}
> +/*
> + * ======== ccdc_setwin  ========
> + *
> + * This function will configure the window size to
> + * be capture in CCDC reg
> + */
> +static void ccdc_setwin(struct ccdc_imgwin *image_win,
> +			enum ccdc_frmfmt frm_fmt, int ppc)

What's does ppc stand for ?

> +{
> +	int horz_start, horz_nr_pixels;

Does horz_nr_pixels really store the number of pixels ? It seems to me it 
counts the number of bytes. hstart and hsize would then be more appropriate 
names.

> +	int vert_start, vert_nr_lines;

If the above comment is correct, this could become vstart and vsize to be 
consistent.

> +	int mid_img = 0;
> +	dev_dbg(dev, "\nStarting ccdc_setwin...");
> +	/* configure horizonal and vertical starts and sizes */
> +	horz_start = image_win->left << (ppc - 1);
> +	horz_nr_pixels = ((image_win->width) << (ppc - 1)) - 1;
> +
> +	/*Writing the horizontal info into the registers */
> +	regw(horz_start & START_PX_HOR_MASK, SPH);
> +	regw(horz_nr_pixels & NUM_PX_HOR_MASK, NPH);

If the values don't fit in the registers you should handle the error instead 
of blindly clearing the high bit. If higher level code makes sure they fit, 
there's no need to clear the high bit.

> +	vert_start = image_win->top;
> +
> +	if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
> +		vert_nr_lines = (image_win->height >> 1) - 1;
> +		vert_start >>= 1;
> +		vert_start += 1; /* Since first line doesn't have any data */
> +		/* configure VDINT0 and VDINT1 */
> +		regw(vert_start, VDINT0);
> +	} else {
> +		vert_start += 1; /* Since first line doesn't have any data */
> +		vert_nr_lines = image_win->height - 1;
> +		/* configure VDINT0 and VDINT1 */
> +		mid_img = vert_start + (image_win->height / 2);
> +		regw(vert_start, VDINT0);
> +		regw(mid_img, VDINT1);
> +	}
> +	regw(vert_start & START_VER_ONE_MASK, SLV0);
> +	regw(vert_start & START_VER_TWO_MASK, SLV1);
> +	regw(vert_nr_lines & NUM_LINES_VER, NLV);
> +	dev_dbg(dev, "\nEnd of ccdc_setwin...");
> +}
> +
> +static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
> +{
> +	if (ccdcparam->datasft < NO_SHIFT || ccdcparam->datasft > _6BIT) {
> +		dev_err(dev, "Invalid value of data shift\n");
> +		return -1;

Return -EINVAL.

> +	}
> +
> +	if (ccdcparam->mfilt1 < NO_MEDIAN_FILTER1
> +	    || ccdcparam->mfilt1 > MEDIAN_FILTER1) {
> +		dev_err(dev, "Invalid value of median filter1\n");
> +		return -1;
> +	}
> +
> +	if (ccdcparam->mfilt2 < NO_MEDIAN_FILTER2
> +	    || ccdcparam->mfilt2 > MEDIAN_FILTER2) {
> +		dev_err(dev, "Invalid value of median filter2\n");
> +		return -1;
> +	}
> +
> +	if (ccdcparam->ccdc_offset < 0 || ccdcparam->ccdc_offset > 1023) {
> +		dev_err(dev, "Invalid value of offset\n");
> +		return -1;
> +	}
> +
> +	if ((ccdcparam->med_filt_thres < 0)
> +		|| (ccdcparam->med_filt_thres > 0x3FFF)) {
> +		dev_err(dev, "Invalid value of median filter thresold\n");
> +		return -1;
> +	}
> +
> +	if (ccdcparam->data_sz < _16BITS || ccdcparam->data_sz > _8BITS) {
> +		dev_err(dev, "Invalid value of data size\n");
> +		return -1;
> +	}
> +
> +	if (ccdcparam->alaw.b_alaw_enable) {
> +		if (ccdcparam->alaw.gama_wd < BITS_13_4
> +		    || ccdcparam->alaw.gama_wd > BITS_09_0) {
> +			dev_err(dev, "Invalid value of ALAW\n");
> +			return -1;
> +		}
> +	}
> +
> +	if (ccdcparam->blk_clamp.b_clamp_enable) {
> +		if (ccdcparam->blk_clamp.sample_pixel < _1PIXELS
> +		    || ccdcparam->blk_clamp.sample_pixel > _16PIXELS) {
> +			dev_err(dev, "Invalid value of sample pixel\n");
> +			return -1;
> +		}
> +		if (ccdcparam->blk_clamp.sample_ln < _1LINES
> +		    || ccdcparam->blk_clamp.sample_ln > _16LINES) {
> +			dev_err(dev, "Invalid value of sample lines\n");
> +			return -1;
> +		}
> +
> +	}
> +
> +	if (ccdcparam->lens_sh_corr.lsc_enable) {
> +		dev_err(dev, "Lens shadding correction is not supported\n");
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static int ccdc_update_raw_params(void *arg)
> +{
> +	struct ccdc_config_params_raw *raw =
> +		(struct ccdc_config_params_raw *)arg;
> +
> +	ccdc_hw_params_raw.datasft =
> +		raw->datasft;

This fits on a single line.

> +	ccdc_hw_params_raw.data_sz =
> +		raw->data_sz;
> +	ccdc_hw_params_raw.mfilt1 =
> +		raw->mfilt1;
> +	ccdc_hw_params_raw.mfilt2 =
> +		raw->mfilt2;
> +	ccdc_hw_params_raw.lpf_enable =
> +		raw->lpf_enable;
> +	ccdc_hw_params_raw.horz_flip_enable =
> +		raw->horz_flip_enable;
> +	ccdc_hw_params_raw.ccdc_offset =
> +		raw->ccdc_offset;
> +	ccdc_hw_params_raw.med_filt_thres =
> +		raw->med_filt_thres;
> +	ccdc_hw_params_raw.image_invert_enable =
> +		raw->image_invert_enable;
> +	ccdc_hw_params_raw.alaw =
> +		raw->alaw;
> +	ccdc_hw_params_raw.data_offset_s =
> +		raw->data_offset_s;
> +	ccdc_hw_params_raw.blk_clamp =
> +		raw->blk_clamp;
> +	ccdc_hw_params_raw.vertical_dft =
> +		raw->vertical_dft;
> +	ccdc_hw_params_raw.lens_sh_corr =
> +		raw->lens_sh_corr;
> +	ccdc_hw_params_raw.data_formatter_r =
> +		raw->data_formatter_r;
> +	ccdc_hw_params_raw.color_space_con =
> +		raw->color_space_con;
> +	ccdc_hw_params_raw.col_pat_field0 =
> +		raw->col_pat_field0;
> +	ccdc_hw_params_raw.col_pat_field1 =
> +		raw->col_pat_field1;

All this would be much simpler (memcpy) if you embedded an instance of 
ccdc_config_params_raw inside ccdc_params_raw instead of duplicating the 
fields.

> +	return 0;
> +}
> +
> +/* Parameter operations */
> +static int ccdc_setparams(void *params)

	void __user *params

> +{
> +	int x;
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {

Handling the other case first would allow you to decrease the nesting level.

> +		x = copy_from_user(&ccdc_hw_params_raw_temp,

Make ccdc_hw_params_raw_temp a local variable.

> +				   (struct ccdc_config_params_raw *)params,

No need to cast, copy_from_user takes a void *.

> +				   sizeof(struct ccdc_config_params_raw));
> +		if (x) {

if (copy_from_user(&ccdc_params, params, sizeof(ccdc_params))) {

> +			dev_err(dev, "ccdc_setparams: error in copying ccdc"
> +				"params, %d\n", x);
> +			return -EFAULT;
> +		}
> +
> +		if (!validate_ccdc_param(&ccdc_hw_params_raw_temp)) {
> +			if (!ccdc_update_raw_params(&ccdc_hw_params_raw_temp))
> +				return 0;

Shouldn't you return -EINVAL here ?

> +		}
> +
> +	}
> +	return -EINVAL;
> +}
> +
> +
> +/*This function will configure CCDC for YCbCr parameters*/
> +static void ccdc_config_ycbcr(void)
> +{
> +	u32 modeset;
> +	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
> +
> +	/* first reset the CCDC                                          */
> +	/* all registers have default values after reset                 */
> +	/* This is important since we assume default values to be set in */
> +	/* a lot of registers that we didn't touch                       */

You don't need to close comments at the end of each line in a comment bloc.

/*
 *
...
 *
 */

is perfectly fine.

> +	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
> +	ccdc_reset();
> +
> +	/* configure pixel format */
> +	modeset = (params->pix_fmt & 0x3) << 12;
> +
> +	/* configure video frame format */
> +	modeset |= (params->frm_fmt & 0x1) << 7;
> +
> +	/* setup BT.656 sync mode */
> +	if (params->bt656_enable) {
> +		regw(3, REC656IF);
> +		/* configure the FID, VD, HD pin polarity */
> +		/* fld,hd pol positive, vd negative, 8-bit pack mode */
> +		modeset |= 0x04;
> +	} else {		/* y/c external sync mode */
> +		modeset |= ((params->fid_pol & 0x1) << 4);
> +		modeset |= ((params->hd_pol & 0x1) << 3);
> +		modeset |= ((params->vd_pol & 0x1) << 2);
> +	}

Please don't use magic number, define constants.

> +
> +	/* pack the data to 8-bit */
> +	modeset |= 0x1 << 11;
> +
> +	regw(modeset, MODESET);
> +
> +	/* configure video window */
> +	ccdc_setwin(&params->win, params->frm_fmt, 2);
> +	/* configure the order of y cb cr in SD-RAM */
> +	regw((params->pix_order << 11) | 0x8040, CCDCFG);
> +
> +	/* configure the horizontal line offset */
> +	/* this is done by rounding up width to a multiple of 16 pixels */
> +	/* and multiply by two to account for y:cb:cr 4:2:2 data */
> +	regw(((((params->win.width * 2) + 31) & 0xffffffe0) >> 5), HSIZE);

No need to mask low order bits, the shift operator will take care of that.

(params->win.width * 2 + 31) >> 5

> +
> +	/* configure the memory line offset */
> +	if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED) {
> +		/* two fields are interleaved in memory */
> +		regw(0x00000249, SDOFST);
> +	}
> +
> +	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
> +}
> +
> +
> +/*
> + * ======== ccdc_config_raw  ========
> + *
> + * This function will configure CCDC for Raw mode parameters
> + */
> +static void ccdc_config_raw(void)
> +{
> +	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
> +	unsigned int mode_set = 0;
> +	unsigned int val = 0, val1 = 0;
> +	int temp1 = 0, temp2 = 0, i = 0, fmtreg_v = 0, shift_v = 0, flag = 0;
> +	int temp_gf = 0, temp_lcs = 0;

Most of those don't need to be initialised. Please don't call variable temp, 
use a more explicit name.

> +	dev_dbg(dev, "\nStarting ccdc_config_raw...");
> +	/*      Reset CCDC */
> +	ccdc_reset();
> +
> +	/*
> +	 *      C O N F I G U R I N G  T H E  C C D C F G  R E G I S T E R

What's wrong with no-space, non-caps typesetting ? :-)

> +	 */
> +
> +	/*Set CCD Not to swap input since input is RAW data */
> +	val |= CCDC_YCINSWP_RAW;
> +
> +	/*set FID detection function to Latch at V-Sync */
> +	val |= CCDC_CCDCFG_FIDMD_LATCH_VSYNC << CCDC_CCDCFG_FIDMD_SHIFT;

CCDC_CCDCFG_FIDMD_LATCH_VSYNC should already be shifted.

> +
> +	/*set WENLOG - ccdc valid area */
> +	val |= CCDC_CCDCFG_WENLOG_AND << CCDC_CCDCFG_WENLOG_SHIFT;
> +
> +	/*set TRGSEL */
> +	val |= CCDC_CCDCFG_TRGSEL_WEN << CCDC_CCDCFG_TRGSEL_SHIFT;
> +
> +	/*set EXTRG */
> +	val |= CCDC_CCDCFG_EXTRG_DISABLE << CCDC_CCDCFG_EXTRG_SHIFT;
> +
> +	/* Disable latching function registers on VSYNC-busy writable
> +	   registers  */
> +
> +	/* Enable latching function registers on VSYNC-shadowed registers */
> +	val |= CCDC_LATCH_ON_VSYNC_DISABLE;
> +	regw(val, CCDCFG);

regw(CCDC_YCINSWP_RAW | CCDC_CCDCFG_FIDMD_LATCH_VSYNC |
     CCDC_CCDCFG_WENLOG_AND | CCDC_CCDCFG_TRGSEL_WEN |
     CCDC_CCDCFG_EXTRG_DISABLE | CCDC_LATCH_ON_VSYNC_DISABLE,
     CCDCFG);

The function will soon become smaller and easier to read :-) (you should of 
course leave the comment in).

> +	/*
> +	 *      C O N F I G U R I N G  T H E  M O D E S E T  R E G I S T E R
> +	 */
> +
> +	/*Set VDHD direction to input */
> +	mode_set |=
> +	    (CCDC_VDHDOUT_INPUT & CCDC_VDHDOUT_MASK) << CCDC_VDHDOUT_SHIFT;
> +
> +	/*Set input type to raw input */
> +	mode_set |=
> +	    (CCDC_RAW_IP_MODE & CCDC_RAW_INPUT_MASK) << CCDC_RAW_INPUT_SHIFT;
> +
> +	/*      Configure the vertical sync polarity(MODESET.VDPOL) */
> +	mode_set = (params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT;
> +
> +	/*      Configure the horizontal sync polarity (MODESET.HDPOL) */
> +	mode_set |= (params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT;
> +
> +	/*      Configure frame id polarity (MODESET.FLDPOL) */
> +	mode_set |= (params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT;
> +
> +	/*      Configure data polarity */
> +	mode_set |=
> +	    (CCDC_DATAPOL_NORMAL & CCDC_DATAPOL_MASK) << CCDC_DATAPOL_SHIFT;
> +
> +	/*      Configure External WEN Selection */
> +	mode_set |= (CCDC_EXWEN_DISABLE & CCDC_EXWEN_MASK) << CCDC_EXWEN_SHIFT;
> +
> +	/* Configure frame format(progressive or interlace) */
> +	mode_set |= (params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT;
> +
> +	/* Configure pixel format (Input mode) */
> +	mode_set |= (params->pix_fmt & CCDC_PIX_FMT_MASK) << CCDC_PIX_FMT_SHIFT;
> +
> +	if ((params->data_sz == _8BITS) || params->alaw.b_alaw_enable)
> +		mode_set |= CCDC_DATA_PACK_ENABLE;
> +
> +	/* Configure for LPF */
> +	if (params->lpf_enable)
> +		mode_set |= (params->lpf_enable & CCDC_LPF_MASK) <<
> +				CCDC_LPF_SHIFT;
> +	/* Configure the data shift */
> +	mode_set |= (params->datasft & CCDC_DATASFT_MASK) << CCDC_DATASFT_SHIFT;
> +	regw(mode_set, MODESET);
> +	dev_dbg(dev, "\nWriting 0x%x to MODESET...\n", mode_set);
> +
> +	/* Configure the Median Filter threshold */
> +	regw((params->med_filt_thres) & 0x3fff, MEDFILT);
> +
> +	/*
> +	 *      C O N F I G U R E   T H E   G A M M A W D   R E G I S T E R
> +	 */
> +
> +	val = 8;
> +	val |=
> +	    (CCDC_CFA_MOSAIC & CCDC_GAMMAWD_CFA_MASK) << CCDC_GAMMAWD_CFA_SHIFT;
> +
> +	/* Enable and configure aLaw register if needed */
> +	if (params->alaw.b_alaw_enable) {
> +		val |= (params->alaw.gama_wd & CCDC_ALAW_GAMA_WD_MASK) << 2;
> +		val |= CCDC_ALAW_ENABLE;	/*set enable bit of alaw */
> +	}
> +
> +	/* Configure Median filter1 for IPIPE capture */
> +	val |= params->mfilt1 << CCDC_MFILT1_SHIFT;
> +
> +	/* Configure Median filter2 for SDRAM capture */
> +	val |= params->mfilt2 << CCDC_MFILT2_SHIFT;
> +
> +	regw(val, GAMMAWD);
> +	dev_dbg(dev, "\nWriting 0x%x to GAMMAWD...\n", val);
> +
> +	/* configure video window */
> +	ccdc_setwin(&params->win, params->frm_fmt, 1);
> +
> +	/*
> +	 *      O P T I C A L   B L A C K   A V E R A G I N G
> +	 */
> +	val = 0;
> +	if (params->blk_clamp.b_clamp_enable) {
> +		val |= (params->blk_clamp.start_pixel & CCDC_BLK_ST_PXL_MASK);
> +
> +		/* No of line to be avg */
> +		val1 |= (params->blk_clamp.sample_ln & CCDC_NUM_LINE_CALC_MASK)
> +		    << CCDC_NUM_LINE_CALC_SHIFT;
> +		/* No of pixel/line to be avg */
> +		val |=
> +		    (params->blk_clamp.sample_pixel & CCDC_BLK_SAMPLE_LN_MASK)
> +		    << CCDC_BLK_SAMPLE_LN_SHIFT;
> +		/* Enable the Black clamping */
> +		val |= CCDC_BLK_CLAMP_ENABLE;
> +		regw(val, CLAMP);
> +
> +		dev_dbg(dev, "\nWriting 0x%x to CLAMP...\n", val);
> +		/* If Black clamping is enable then make dcsub 0 */
> +		regw(val1, DCSUB);
> +		dev_dbg(dev, "\nWriting 0x00000000 to DCSUB...\n");
> +
> +	} else {
> +		/* configure DCSub */
> +		val = (params->blk_clamp.dc_sub) & CCDC_BLK_DC_SUB_MASK;
> +		regw(val, DCSUB);
> +
> +		dev_dbg(dev, "\nWriting 0x%x to DCSUB...\n", val);
> +		regw(0x0000, CLAMP);
> +
> +		dev_dbg(dev, "\nWriting 0x0000 to CLAMP...\n");
> +	}
> +
> +	/*
> +	 *  C O N F I G U R E   B L A C K   L E V E L   C O M P E N S A T I O N
> +	 */
> +	val = 0;
> +	val = (params->blk_comp.b_comp & CCDC_BLK_COMP_MASK);
> +	val |= (params->blk_comp.gb_comp & CCDC_BLK_COMP_MASK)
> +	    << CCDC_BLK_COMP_GB_COMP_SHIFT;
> +	regw(val, BLKCMP1);
> +
> +	val1 = 0;
> +	val1 |= (params->blk_comp.gr_comp & CCDC_BLK_COMP_MASK)
> +	    << CCDC_BLK_COMP_GR_COMP_SHIFT;
> +	val1 |= (params->blk_comp.r_comp & CCDC_BLK_COMP_MASK)
> +	    << CCDC_BLK_COMP_R_COMP_SHIFT;
> +	regw(val1, BLKCMP0);
> +
> +	dev_dbg(dev, "\nWriting 0x%x to BLKCMP1...\n", val);
> +	dev_dbg(dev, "\nWriting 0x%x to BLKCMP0...\n", val1);
> +
> +	/* Configure Vertical Defect Correction if needed */
> +	if (params->vertical_dft.ver_dft_en) {
> +
> +		shift_v = 0;
> +		shift_v = 0 << CCDC_DFCCTL_VDFCEN_SHIFT;
> +		shift_v |=
> +		    params->vertical_dft.gen_dft_en & CCDC_DFCCTL_GDFCEN_MASK;
> +		shift_v |=
> +		    (params->vertical_dft.dft_corr_ctl.
> +		     vdfcsl & CCDC_DFCCTL_VDFCSL_MASK) <<
> +		    CCDC_DFCCTL_VDFCSL_SHIFT;
> +		shift_v |=
> +		    (params->vertical_dft.dft_corr_ctl.
> +		     vdfcuda & CCDC_DFCCTL_VDFCUDA_MASK) <<
> +		    CCDC_DFCCTL_VDFCUDA_SHIFT;
> +		shift_v |=
> +		    (params->vertical_dft.dft_corr_ctl.
> +		     vdflsft & CCDC_DFCCTL_VDFLSFT_MASK) <<
> +		    CCDC_DFCCTL_VDFLSFT_SHIFT;
> +		regw(shift_v, DFCCTL);
> +		regw(params->vertical_dft.dft_corr_vert[0], DFCMEM0);
> +		regw(params->vertical_dft.dft_corr_horz[0], DFCMEM1);
> +		regw(params->vertical_dft.dft_corr_sub1[0], DFCMEM2);
> +		regw(params->vertical_dft.dft_corr_sub2[0], DFCMEM3);
> +		regw(params->vertical_dft.dft_corr_sub3[0], DFCMEM4);
> +
> +		shift_v = 0;
> +		shift_v = regr(DFCMEMCTL);
> +		shift_v |= 1 << CCDC_DFCMEMCTL_DFCMARST_SHIFT;
> +		shift_v |= 1;
> +		regw(shift_v, DFCMEMCTL);
> +
> +		while (1) {
> +			flag = regr(DFCMEMCTL);
> +			if ((flag & 0x01) == 0x00)
> +				break;
> +		}

If there's a hardware error we'll loop indefinitely. How long is the low bit 
supposed to remain set ? If the time is supposed to be very short just as a 
for loop with a maximum number of iterations and bail out with an error if the 
bit doesn't go low. If the time can be long you should probably schedule() 
inside the for loop as well.

> +		flag = 0;
> +		shift_v = 0;
> +		shift_v = regr(DFCMEMCTL);
> +		shift_v |= 0 << CCDC_DFCMEMCTL_DFCMARST_SHIFT;
> +		regw(shift_v, DFCMEMCTL);
> +
> +		for (i = 1; i < 16; i++) {
> +			regw(params->vertical_dft.dft_corr_vert[i], DFCMEM0);
> +			regw(params->vertical_dft.dft_corr_horz[i], DFCMEM1);
> +			regw(params->vertical_dft.dft_corr_sub1[i], DFCMEM2);
> +			regw(params->vertical_dft.dft_corr_sub2[i], DFCMEM3);
> +			regw(params->vertical_dft.dft_corr_sub3[i], DFCMEM4);
> +
> +			shift_v = 0;
> +			shift_v = regr(DFCMEMCTL);
> +			shift_v |= 1;
> +			regw(shift_v, DFCMEMCTL);
> +
> +			while (1) {
> +				flag = regr(DFCMEMCTL);
> +				if ((flag & 0x01) == 0x00)
> +					break;
> +			}
> +			flag = 0;
> +		}
> +		regw(params->vertical_dft.
> +		     saturation_ctl & CCDC_VDC_DFCVSAT_MASK, DFCVSAT);
> +
> +		shift_v = 0;
> +		shift_v = regr(DFCCTL);
> +		shift_v |= 1 << CCDC_DFCCTL_VDFCEN_SHIFT;
> +		regw(shift_v, DFCCTL);
> +	}
> +
> +	/* Configure Lens Shading Correction if needed */
> +	if (params->lens_sh_corr.lsc_enable) {
> +		dev_dbg(dev, "\nlens shading Correction entered....\n");
> +
> +		/* first disable the LSC */
> +		regw(CCDC_LSC_DISABLE, LSCCFG1);
> +
> +		/* UPDATE PROCEDURE FOR GAIN FACTOR TABLE 1 */
> +
> +		/* select table 1 */
> +		regw(CCDC_LSC_TABLE1_SLC, LSCMEMCTL);
> +
> +		/* Reset memory address */
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_RESET;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		/* Update gainfactor for table 1 - u8q8 */
> +		temp_gf =
> +		    ((int)(params->lens_sh_corr.gf_table1[0].frac_no * 256))
> +		    & CCDC_LSC_FRAC_MASK_T1;
> +		temp_gf |=
> +		    (((int)(params->lens_sh_corr.gf_table1[0].frac_no * 256))
> +		     & CCDC_LSC_FRAC_MASK_T1) << 8;
> +		regw(temp_gf, LSCMEMD);
> +
> +		while (1) {
> +			if ((regr(LSCMEMCTL) & 0x10) == 0)
> +				break;
> +		}
> +
> +		/* set the address to incremental mode */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_INCR;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		for (i = 2; i < 255; i += 2) {
> +			temp_gf = 0;
> +			temp_gf = ((int)
> +				   (params->lens_sh_corr.gf_table1[0].frac_no *
> +				    256))
> +			    & CCDC_LSC_FRAC_MASK_T1;
> +			temp_gf |= (((int)
> +				     (params->lens_sh_corr.gf_table1[0].
> +				      frac_no * 256))
> +				    & CCDC_LSC_FRAC_MASK_T1) << 8;
> +			regw(temp_gf, LSCMEMD);
> +
> +			while (1) {
> +				if ((regr(LSCMEMCTL) & 0x10) == 0)
> +					break;
> +			}
> +		}
> +
> +		/* UPDATE PROCEDURE FOR GAIN FACTOR TABLE 2 */
> +
> +		/* select table 2 */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_TABLE2_SLC;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		/*Reset memory address */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_RESET;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		/*Update gainfactor for table 2 - u16q14 */
> +		temp_gf =
> +		    (params->lens_sh_corr.gf_table2[0].
> +		     int_no & CCDC_LSC_INT_MASK) << 14;
> +		temp_gf |=
> +		    ((int)(params->lens_sh_corr.gf_table2[0].frac_no) * 16384)
> +		    & CCDC_LSC_FRAC_MASK;
> +		regw(temp_gf, LSCMEMD);
> +
> +		while (1) {
> +			if ((regr(LSCMEMCTL) & 0x10) == 0)
> +				break;
> +		}
> +
> +		/*set the address to incremental mode */
> +		temp_lcs = 0;

This isn't needed. This function needs to be cleaned up, it's quite difficult 
to read at the moment. Regroup the comments, typeset them in normal caps with 
normal spaces, make the register setting code more condensed and split the 
code in more than one function.

> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_INCR;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		for (i = 1; i < 128; i++) {
> +			temp_gf = 0;
> +			temp_gf =
> +			    (params->lens_sh_corr.gf_table2[i].
> +			     int_no & CCDC_LSC_INT_MASK) << 14;
> +			temp_gf |=
> +			    ((int)(params->lens_sh_corr.gf_table2[0].frac_no) *
> +			     16384)
> +			    & CCDC_LSC_FRAC_MASK;
> +			regw(temp_gf, LSCMEMD);
> +
> +			while (1) {
> +				if ((regr(LSCMEMCTL) & 0x10) == 0)
> +					break;
> +			}
> +		}
> +
> +		/*UPDATE PROCEDURE FOR GAIN FACTOR TABLE 3 */
> +
> +		/*select table 3 */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_TABLE3_SLC;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		/*Reset memory address */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_RESET;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		/*Update gainfactor for table 2 - u16q14 */
> +		temp_gf =
> +		    (params->lens_sh_corr.gf_table3[0].
> +		     int_no & CCDC_LSC_INT_MASK) << 14;
> +		temp_gf |=
> +		    ((int)(params->lens_sh_corr.gf_table3[0].frac_no) * 16384)
> +		    & CCDC_LSC_FRAC_MASK;
> +		regw(temp_gf, LSCMEMD);
> +
> +		while (1) {
> +			if ((regr(LSCMEMCTL) & 0x10) == 0)
> +				break;
> +		}
> +
> +		/*set the address to incremental mode */
> +		temp_lcs = 0;
> +		temp_lcs = regr(LSCMEMCTL);
> +		temp_lcs |= CCDC_LSC_MEMADDR_INCR;
> +		regw(temp_lcs, LSCMEMCTL);
> +
> +		for (i = 1; i < 128; i++) {
> +			temp_gf = 0;
> +			temp_gf =
> +			    (params->lens_sh_corr.gf_table3[i].
> +			     int_no & CCDC_LSC_INT_MASK) << 14;
> +			temp_gf |=
> +			    ((int)(params->lens_sh_corr.gf_table3[0].frac_no) *
> +			     16384)
> +			    & CCDC_LSC_FRAC_MASK;
> +			regw(temp_gf, LSCMEMD);
> +
> +			while (1) {
> +				if ((regr(LSCMEMCTL) & 0x10) == 0)
> +					break;
> +			}
> +		}
> +		/*Configuring the optical centre of the lens */
> +		regw(params->lens_sh_corr.
> +		     lens_center_horz & CCDC_LSC_CENTRE_MASK, LSCH0);
> +		regw(params->lens_sh_corr.
> +		     lens_center_vert & CCDC_LSC_CENTRE_MASK, LSCV0);
> +
> +		val = 0;
> +		val =
> +		    ((int)(params->lens_sh_corr.horz_left_coef.frac_no * 128)) &
> +		    0x7f;
> +		val |= (params->lens_sh_corr.horz_left_coef.int_no & 0x01) << 7;
> +		val |=
> +		    (((int)(params->lens_sh_corr.horz_right_coef.frac_no * 128))
> +		     & 0x7f) << 8;
> +		val |=
> +		    (params->lens_sh_corr.horz_right_coef.int_no & 0x01) << 15;
> +		regw(val, LSCKH);
> +
> +		val = 0;
> +		val =
> +		    ((int)(params->lens_sh_corr.ver_up_coef.frac_no * 128)) &
> +		    0x7f;
> +		val |= (params->lens_sh_corr.ver_up_coef.int_no & 0x01) << 7;
> +		val |=
> +		    (((int)(params->lens_sh_corr.ver_low_coef.frac_no * 128)) &
> +		     0x7f) << 8;
> +		val |= (params->lens_sh_corr.ver_low_coef.int_no & 0x01) << 15;
> +		regw(val, LSCKV);
> +
> +		/*configuring the lsc configuration register 2 */
> +		temp_lcs = 0;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     gf_table_scaling_fact & CCDC_LSCCFG_GFTSF_MASK) <<
> +		    CCDC_LSCCFG_GFTSF_SHIFT;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     gf_table_interval & CCDC_LSCCFG_GFTINV_MASK) <<
> +		    CCDC_LSCCFG_GFTINV_SHIFT;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     epel & CCDC_LSC_GFTABLE_SEL_MASK) <<
> +		    CCDC_LSC_GFTABLE_EPEL_SHIFT;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     opel & CCDC_LSC_GFTABLE_SEL_MASK) <<
> +		    CCDC_LSC_GFTABLE_OPEL_SHIFT;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     epol & CCDC_LSC_GFTABLE_SEL_MASK) <<
> +		    CCDC_LSC_GFTABLE_EPOL_SHIFT;
> +		temp_lcs |=
> +		    (params->lens_sh_corr.lsc_config.
> +		     opol & CCDC_LSC_GFTABLE_SEL_MASK) <<
> +		    CCDC_LSC_GFTABLE_OPOL_SHIFT;
> +		regw(temp_lcs, LSCCFG2);
> +
> +		/*configuring the LSC configuration register 1 */
> +		temp_lcs = 0;
> +		temp_lcs |= CCDC_LSC_ENABLE;
> +		temp_lcs |= (params->lens_sh_corr.lsc_config.mode &
> +			     CCDC_LSC_GFMODE_MASK) << CCDC_LSC_GFMODE_SHIFT;
> +		regw(temp_lcs, LSCCFG1);
> +	}
> +
> +	/* Configure data formatter if needed */
> +	if (params->data_formatter_r.fmt_enable
> +	    && (!params->color_space_con.csc_enable)) {
> +		dev_dbg(dev,
> +		       "\ndata formatter will be configured now....\n");
> +
> +		/*Configuring the FMTPLEN */
> +		fmtreg_v = 0;
> +		fmtreg_v |=
> +		    (params->data_formatter_r.plen.
> +		     plen0 & CCDC_FMTPLEN_P0_MASK);
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.plen.
> +		      plen1 & CCDC_FMTPLEN_P1_MASK)
> +		     << CCDC_FMTPLEN_P1_SHIFT);
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.plen.
> +		      plen2 & CCDC_FMTPLEN_P2_MASK)
> +		     << CCDC_FMTPLEN_P2_SHIFT);
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.plen.
> +		      plen3 & CCDC_FMTPLEN_P3_MASK)
> +		     << CCDC_FMTPLEN_P3_SHIFT);
> +		regw(fmtreg_v, FMTPLEN);
> +
> +		/*Configurring the FMTSPH */
> +		regw((params->data_formatter_r.fmtsph & CCDC_FMTSPH_MASK),
> +		     FMTSPH);
> +
> +		/*Configurring the FMTLNH */
> +		regw((params->data_formatter_r.fmtlnh & CCDC_FMTLNH_MASK),
> +		     FMTLNH);
> +
> +		/*Configurring the FMTSLV */
> +		regw((params->data_formatter_r.fmtslv & CCDC_FMTSLV_MASK),
> +		     FMTSLV);
> +
> +		/*Configurring the FMTLNV */
> +		regw((params->data_formatter_r.fmtlnv & CCDC_FMTLNV_MASK),
> +		     FMTLNV);
> +
> +		/*Configurring the FMTRLEN */
> +		regw((params->data_formatter_r.fmtrlen & CCDC_FMTRLEN_MASK),
> +		     FMTRLEN);
> +
> +		/*Configurring the FMTHCNT */
> +		regw((params->data_formatter_r.fmthcnt & CCDC_FMTHCNT_MASK),
> +		     FMTHCNT);
> +
> +		/*Configuring the FMTADDR_PTR */
> +		for (i = 0; i < 8; i++) {
> +			fmtreg_v = 0;
> +
> +			if (params->data_formatter_r.addr_ptr[i].init >
> +			    (params->data_formatter_r.fmtrlen - 1)) {
> +				dev_dbg(dev, "\nInvalid init parameter for"
> +					   "FMTADDR_PTR....\n");
> +				return;
> +			}
> +
> +			fmtreg_v =
> +			    (params->data_formatter_r.addr_ptr[i].
> +			     init & CCDC_ADP_INIT_MASK);
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.addr_ptr[i].
> +			      line & CCDC_ADP_LINE_MASK) <<
> +			     CCDC_ADP_LINE_SHIFT);
> +			regw(fmtreg_v, FMT_ADDR_PTR(i));
> +		}
> +
> +		/* Configuring the FMTPGM_VF0 */
> +		fmtreg_v = 0;
> +		for (i = 0; i < 16; i++)
> +			fmtreg_v |= params->data_formatter_r.pgm_en[i] << i;
> +		regw(fmtreg_v, FMTPGM_VF0);
> +
> +		/* Configuring the FMTPGM_VF1 */
> +		fmtreg_v = 0;
> +		for (i = 16; i < 32; i++) {
> +			fmtreg_v |=
> +			    params->data_formatter_r.pgm_en[i] << (i - 16);
> +		}
> +		regw(fmtreg_v, FMTPGM_VF1);
> +
> +		/* Configuring the FMTPGM_AP0 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 0; i < 4; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP0);
> +
> +		/* Configuring the FMTPGM_AP1 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 4; i < 8; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP1);
> +
> +		/* Configuring the FMTPGM_AP2 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 8; i < 12; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP2);
> +
> +		/* Configuring the FMTPGM_AP3 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 12; i < 16; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP3);
> +
> +		/* Configuring the FMTPGM_AP4 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 16; i < 20; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP4);
> +
> +		/* Configuring the FMTPGM_AP5 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 20; i < 24; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP5);
> +
> +		/* Configuring the FMTPGM_AP6 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 24; i < 28; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP6);
> +
> +		/* Configuring the FMTPGM_AP7 */
> +		fmtreg_v = 0;
> +		shift_v = 0;
> +		for (i = 28; i < 32; i++) {
> +			fmtreg_v |=
> +			    ((params->data_formatter_r.pgm_ap[i].
> +			      pgm_aptr & CCDC_FMTPGN_APTR_MASK) << shift_v);
> +			fmtreg_v |=
> +			    (params->data_formatter_r.pgm_ap[i].
> +			     pgmupdt << (shift_v + 3));
> +			shift_v += 4;
> +		}
> +		regw(fmtreg_v, FMTPGM_AP7);
> +
> +		/* Configuring the FMTCFG register */
> +		fmtreg_v = 0;
> +		fmtreg_v = CCDC_DF_ENABLE;
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.cfg.
> +		      mode & CCDC_FMTCFG_FMTMODE_MASK)
> +		     << CCDC_FMTCFG_FMTMODE_SHIFT);
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.cfg.
> +		      lnum & CCDC_FMTCFG_LNUM_MASK)
> +		     << CCDC_FMTCFG_LNUM_SHIFT);
> +		fmtreg_v |=
> +		    ((params->data_formatter_r.cfg.
> +		      addrinc & CCDC_FMTCFG_ADDRINC_MASK)
> +		     << CCDC_FMTCFG_ADDRINC_SHIFT);
> +		regw(fmtreg_v, FMTCFG);
> +
> +	} else if (params->data_formatter_r.fmt_enable) {
> +		dev_dbg(dev,
> +		       "\nCSC and Data Formatter Enabled at same time....\n");
> +	}
> +
> +	/*
> +	 *      C O N F I G U R E   C O L O R   S P A C E   C O N V E R T E R
> +	 */
> +
> +	if ((params->color_space_con.csc_enable)
> +	    && (!params->data_formatter_r.fmt_enable)) {
> +		dev_dbg(dev, "\nconfiguring the CSC Now....\n");
> +
> +		/* Enable the CSC sub-module */
> +		regw(CCDC_CSC_ENABLE, CSCCTL);
> +
> +		/* Converting the co-eff as per the format of the register */
> +		for (i = 0; i < 16; i++) {
> +			temp1 = params->color_space_con.csc_dec_coeff[i];
> +			/* Masking the data for 3 bits */
> +			temp1 &= CCDC_CSC_COEFF_DEC_MASK;
> +			/* Recovering the fractional part and converting to
> +			 * binary of 5 bits
> +			 */
> +			temp2 =
> +			    (int)(params->color_space_con.csc_frac_coeff[i] *
> +				  (32 / 10));
> +			temp2 &= CCDC_CSC_COEFF_FRAC_MASK;
> +			/* shifting the decimal to the MSB */
> +			temp1 = temp1 << CCDC_CSC_DEC_SHIFT;
> +			temp1 |= temp2;
> +			params->color_space_con.csc_dec_coeff[i] = temp1;
> +		}
> +		regw(params->color_space_con.csc_dec_coeff[0], CSCM0);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[1] << CCDC_CSC_COEFF_SHIFT, CSCM0);
> +		regw(params->color_space_con.csc_dec_coeff[2], CSCM1);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[3] << CCDC_CSC_COEFF_SHIFT, CSCM1);
> +		regw(params->color_space_con.csc_dec_coeff[4], CSCM2);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[5] << CCDC_CSC_COEFF_SHIFT, CSCM2);
> +		regw(params->color_space_con.csc_dec_coeff[6], CSCM3);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[7] << CCDC_CSC_COEFF_SHIFT, CSCM3);
> +		regw(params->color_space_con.csc_dec_coeff[8], CSCM4);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[9] << CCDC_CSC_COEFF_SHIFT, CSCM4);
> +		regw(params->color_space_con.csc_dec_coeff[10], CSCM5);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[11] << CCDC_CSC_COEFF_SHIFT, CSCM5);
> +		regw(params->color_space_con.csc_dec_coeff[12], CSCM6);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[13] << CCDC_CSC_COEFF_SHIFT, CSCM6);
> +		regw(params->color_space_con.csc_dec_coeff[14], CSCM7);
> +		regw(params->color_space_con.
> +		     csc_dec_coeff[15] << CCDC_CSC_COEFF_SHIFT, CSCM7);
> +
> +	} else if (params->color_space_con.csc_enable) {
> +		dev_dbg(dev,
> +		       "\nCSC and Data Formatter Enabled at same time....\n");
> +	}
> +
> +	/* Configure the Gain  & offset control */
> +	ccdc_config_gain_offset();
> +
> +	/*
> +	 *      C O N F I G U R E  C O L O R  P A T T E R N  A S
> +	 *      P E R  N N 1 2 8 6 A  S E N S O R
> +	 */
> +
> +	val = (params->col_pat_field0.olop);
> +	val |= (params->col_pat_field0.olep << 2);
> +	val |= (params->col_pat_field0.elop << 4);
> +	val |= (params->col_pat_field0.elep << 6);
> +	val |= (params->col_pat_field1.olop << 8);
> +	val |= (params->col_pat_field1.olep << 10);
> +	val |= (params->col_pat_field1.elop << 12);
> +	val |= (params->col_pat_field1.elep << 14);
> +	regw(val, COLPTN);
> +
> +	dev_dbg(dev, "\nWriting %x to COLPTN...\n", val);
> +
> +	/*
> +	 *      C O N F I G U R I N G  T H E  H S I Z E  R E G I S T E R
> +	 */
> +	val = 0;
> +	val |=
> +	    (params->data_offset_s.
> +	     horz_offset & CCDC_DATAOFST_MASK) << CCDC_DATAOFST_H_SHIFT;
> +	val |=
> +	    (params->data_offset_s.
> +	     vert_offset & CCDC_DATAOFST_MASK) << CCDC_DATAOFST_V_SHIFT;
> +	regw(val, DATAOFST);
> +
> +	/*
> +	 *      C O N F I G U R I N G  T H E  H S I Z E  R E G I S T E R
> +	 */
> +	val = 0;
> +	val |=
> +	    (params->
> +	     horz_flip_enable & CCDC_HSIZE_FLIP_MASK) << CCDC_HSIZE_FLIP_SHIFT;
> +
> +	/* If pack 8 is enable then 1 pixel will take 1 byte */
> +	if ((params->data_sz == _8BITS) || params->alaw.b_alaw_enable) {
> +		val |= (((params->win.width) + 31) >> 5) & 0x0fff;
> +
> +		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
> +		       (((params->win.width) + 31) >> 5) & 0x0fff);
> +	} else {
> +		/* else one pixel will take 2 byte */
> +		val |= (((params->win.width * 2) + 31) >> 5) & 0x0fff;
> +
> +		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
> +		       (((params->win.width * 2) + 31) >> 5) & 0x0fff);
> +	}
> +	regw(val, HSIZE);
> +
> +	/*
> +	 *      C O N F I G U R E   S D O F S T  R E G I S T E R
> +	 */
> +
> +	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
> +		if (params->image_invert_enable) {
> +			/* For interlace inverse mode */
> +			regw(0x4B6D, SDOFST);
> +			dev_dbg(dev, "\nWriting 0x4B6D to SDOFST...\n");
> +		}
> +
> +		else {
> +			/* For interlace non inverse mode */
> +			regw(0x0B6D, SDOFST);
> +			dev_dbg(dev, "\nWriting 0x0B6D to SDOFST...\n");
> +		}
> +	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
> +		if (params->image_invert_enable) {
> +			/* For progessive inverse mode */
> +			regw(0x4000, SDOFST);
> +			dev_dbg(dev, "\nWriting 0x4000 to SDOFST...\n");
> +		}
> +
> +		else {
> +			/* For progessive non inverse mode */
> +			regw(0x0000, SDOFST);
> +			dev_dbg(dev, "\nWriting 0x0000 to SDOFST...\n");
> +		}
> +
> +	}
> +	dev_dbg(dev, "\nend of ccdc_config_raw...");
> +}
> +
> +static int ccdc_configure(void)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		dev_info(dev, "calling ccdc_config_raw()\n");

Remove the dev_info, you already print debug messages in ccdc_config_raw().

> +		ccdc_config_raw();
> +	} else {
> +		dev_info(dev, "calling ccdc_config_ycbcr()\n");
> +		ccdc_config_ycbcr();
> +	}
> +	return 0;
> +}
> +
> +static int ccdc_set_buftype(enum ccdc_buftype buf_type)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER)
> +		ccdc_hw_params_raw.buf_type = buf_type;
> +	else
> +		ccdc_hw_params_ycbcr.buf_type = buf_type;

Can't you regroup ccdc_hw_params_raw and ccdc_hw_params_ycbcr into a single 
structure (or maybe store the common fields in another structure) ? Fields 
that are only applicable for one of the formats would then be ignored for the 
other. ccdc_if_type could then be stored in ccdc_hw_params.

> +	return 0;
> +}
> +static enum ccdc_buftype ccdc_get_buftype(void)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER)
> +		return ccdc_hw_params_raw.buf_type;
> +	return ccdc_hw_params_ycbcr.buf_type;
> +}
> +
> +static int ccdc_enum_pix(enum vpfe_hw_pix_format *hw_pix, int i)
> +{
> +	int ret = -EINVAL;
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		if (i < CCDC_MAX_RAW_BAYER_FORMATS) {
> +			*hw_pix = ccdc_raw_bayer_hw_formats[i];

How does this compare to memcpy in term of code size and run time ?

> +			ret = 0;
> +		}
> +	} else {
> +		if (i < CCDC_MAX_RAW_YUV_FORMATS) {
> +			*hw_pix = ccdc_raw_yuv_hw_formats[i];
> +			ret = 0;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int ccdc_set_pixel_format(enum vpfe_hw_pix_format pixfmt)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
> +		if (pixfmt == VPFE_BAYER_8BIT_PACK_ALAW)
> +			ccdc_hw_params_raw.alaw.b_alaw_enable = 1;
> +		else if (pixfmt != VPFE_BAYER)
> +			return -1;

-EINVAL

> +	} else {
> +		if (pixfmt == VPFE_YUYV)
> +			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
> +		else if (pixfmt == VPFE_UYVY)
> +			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
> +		else
> +			return -1;
> +	}

You're translating here from VPFE pixel format to CCDC pixel format. 
vpfe_capture.c translated from V4L2 pixel format to VPFE pixel format. Can't 
we pass the V4L2 pixel format directly to the CCDC instead ? You could then 
remove the intermediate format, making vpfe_capture.c simpler.

> +	return 0;
> +}
> +static enum vpfe_hw_pix_format ccdc_get_pixel_format(void)
> +{
> +	enum vpfe_hw_pix_format pixfmt;
> +
> +	if (ccdc_if_type == VPFE_RAW_BAYER)
> +		if (ccdc_hw_params_raw.alaw.b_alaw_enable)
> +			pixfmt = VPFE_BAYER_8BIT_PACK_ALAW;
> +		else
> +			pixfmt = VPFE_BAYER;
> +	else {
> +		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
> +			pixfmt = VPFE_YUYV;
> +		else
> +			pixfmt = VPFE_UYVY;
> +	}
> +	return pixfmt;
> +}
> +static int ccdc_set_image_window(struct v4l2_rect *win)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		ccdc_hw_params_raw.win.top = win->top;
> +		ccdc_hw_params_raw.win.left = win->left;
> +		ccdc_hw_params_raw.win.width = win->width;
> +		ccdc_hw_params_raw.win.height = win->height;
> +	} else {
> +		ccdc_hw_params_ycbcr.win.top = win->top;
> +		ccdc_hw_params_ycbcr.win.left = win->left;
> +		ccdc_hw_params_ycbcr.win.width = win->width;
> +		ccdc_hw_params_ycbcr.win.height = win->height;
> +	}
> +	return 0;
> +}
> +
> +static void ccdc_get_image_window(struct v4l2_rect *win)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		win->top = ccdc_hw_params_raw.win.top;
> +		win->left = ccdc_hw_params_raw.win.left;
> +		win->width = ccdc_hw_params_raw.win.width;
> +		win->height = ccdc_hw_params_raw.win.height;
> +	} else {
> +		win->top = ccdc_hw_params_ycbcr.win.top;
> +		win->left = ccdc_hw_params_ycbcr.win.left;
> +		win->width = ccdc_hw_params_ycbcr.win.width;
> +		win->height = ccdc_hw_params_ycbcr.win.height;
> +	}
> +}
> +
> +static unsigned int ccdc_get_line_length(void)
> +{
> +	unsigned int len;
> +
> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> +		if ((ccdc_hw_params_raw.alaw.b_alaw_enable) ||
> +		    (ccdc_hw_params_raw.data_sz == _8BITS))
> +			len = ccdc_hw_params_raw.win.width;
> +		else
> +			len = ccdc_hw_params_raw.win.width * 2;
> +	} else
> +		len = ccdc_hw_params_ycbcr.win.width * 2;
> +	len = ((len + 31) & ~0x1f);
> +	return 0;

return ALIGN(len, 32);

> +}
> +
> +static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER)
> +		ccdc_hw_params_raw.frm_fmt = frm_fmt;
> +	else
> +		ccdc_hw_params_ycbcr.frm_fmt = frm_fmt;
> +	return 0;
> +}
> +
> +static enum ccdc_frmfmt ccdc_get_frame_format(void)
> +{
> +	if (ccdc_if_type == VPFE_RAW_BAYER)
> +		return ccdc_hw_params_raw.frm_fmt;
> +	else
> +		return ccdc_hw_params_ycbcr.frm_fmt;
> +}
> +
> +static int ccdc_getfid(void)
> +{
> +	int fid = (regr(MODESET) >> 15) & 0x1;
> +	return fid;

return (regr(MODESET) >> 15) & 1;

> +}
> +
> +/* misc operations */
> +static inline void ccdc_setfbaddr(unsigned long addr)
> +{
> +	regw((addr >> 21) & 0x007f, STADRH);
> +	regw((addr >> 5) & 0x0ffff, STADRL);
> +}
> +
> +static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
> +{
> +	ccdc_if_type = params->if_type;
> +
> +	switch (params->if_type) {
> +	case VPFE_BT656:
> +	case VPFE_YCBCR_SYNC_16:
> +	case VPFE_YCBCR_SYNC_8:
> +		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
> +		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
> +		break;
> +	default:
> +		/* TODO add support for raw bayer here */
> +		return -1;

-EINVAL;

> +	}
> +	return 0;
> +}
> +
> +static struct ccdc_hw_device ccdc_hw_dev = {
> +	.name = "DM355 CCDC",
> +	.owner = THIS_MODULE,
> +	.open = ccdc_open,
> +	.close = ccdc_close,
> +	.hw_ops = {
> +		.set_ccdc_base = ccdc_set_ccdc_base,
> +		.set_vpss_base = ccdc_set_vpss_base,
> +		.enable = ccdc_enable,
> +		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
> +		.set_hw_if_params = ccdc_set_hw_if_params,
> +		.setparams = ccdc_setparams,
> +		.configure = ccdc_configure,
> +		.set_buftype = ccdc_set_buftype,
> +		.get_buftype = ccdc_get_buftype,
> +		.enum_pix = ccdc_enum_pix,
> +		.set_pixelformat = ccdc_set_pixel_format,
> +		.get_pixelformat = ccdc_get_pixel_format,
> +		.set_frame_format = ccdc_set_frame_format,
> +		.get_frame_format = ccdc_get_frame_format,
> +		.set_image_window = ccdc_set_image_window,
> +		.get_image_window = ccdc_get_image_window,
> +		.get_line_length = ccdc_get_line_length,
> +		.queryctrl = ccdc_queryctrl,
> +		.setcontrol = ccdc_setcontrol,
> +		.getcontrol = ccdc_getcontrol,
> +		.setfbaddr = ccdc_setfbaddr,
> +		.getfid = ccdc_getfid,
> +	},
> +};
> +
> +static int dm355_ccdc_init(void)
> +{
> +	printk(KERN_NOTICE "dm355_ccdc_init\n");
> +	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> +		return -1;
> +	printk(KERN_NOTICE "%s is registered with vpfe.\n",
> +		ccdc_hw_dev.name);
> +	return 0;
> +}
> +
> +static void dm355_ccdc_exit(void)
> +{

Don't you need to unregister ?

> +}
> +
> +module_init(dm355_ccdc_init);
> +module_exit(dm355_ccdc_exit);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/davinci/dm355_ccdc_regs.h
> b/drivers/media/video/davinci/dm355_ccdc_regs.h new file mode 100644
> index 0000000..50f8a4a
> --- /dev/null
> +++ b/drivers/media/video/davinci/dm355_ccdc_regs.h
> @@ -0,0 +1,291 @@
> +/*
> + * Copyright (C) 2005-2009 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +#ifndef _DM355_CCDC_REGS_H
> +#define _DM355_CCDC_REGS_H
> +
> +/*************************************************************************
>*\ +* Register OFFSET Definitions
> +\*************************************************************************
>*/ +#define SYNCEN				0x00
> +#define MODESET				0x04
> +#define HDWIDTH				0x08
> +#define VDWIDTH				0x0c
> +#define PPLN				0x10
> +#define LPFR				0x14
> +#define SPH				0x18
> +#define NPH				0x1c
> +#define SLV0				0x20
> +#define SLV1				0x24
> +#define NLV				0x28
> +#define CULH				0x2c
> +#define CULV				0x30
> +#define HSIZE				0x34
> +#define SDOFST				0x38
> +#define STADRH				0x3c
> +#define STADRL				0x40
> +#define CLAMP				0x44
> +#define DCSUB				0x48
> +#define COLPTN				0x4c
> +#define BLKCMP0				0x50
> +#define BLKCMP1				0x54
> +#define MEDFILT				0x58
> +#define RYEGAIN				0x5c
> +#define GRCYGAIN			0x60
> +#define GBGGAIN				0x64
> +#define BMGGAIN				0x68
> +#define OFFSET				0x6c
> +#define OUTCLIP				0x70
> +#define VDINT0				0x74
> +#define VDINT1				0x78
> +#define RSV0				0x7c
> +#define GAMMAWD				0x80
> +#define REC656IF			0x84
> +#define CCDCFG				0x88
> +#define FMTCFG				0x8c
> +#define FMTPLEN				0x90
> +#define FMTSPH				0x94
> +#define FMTLNH				0x98
> +#define FMTSLV				0x9c
> +#define FMTLNV				0xa0
> +#define FMTRLEN				0xa4
> +#define FMTHCNT				0xa8
> +#define FMT_ADDR_PTR_B			0xac
> +#define FMT_ADDR_PTR(i)			(FMT_ADDR_PTR_B + (i * 4))
> +#define FMTPGM_VF0			0xcc
> +#define FMTPGM_VF1			0xd0
> +#define FMTPGM_AP0			0xd4
> +#define FMTPGM_AP1			0xd8
> +#define FMTPGM_AP2			0xdc
> +#define FMTPGM_AP3                      0xe0
> +#define FMTPGM_AP4                      0xe4
> +#define FMTPGM_AP5                      0xe8
> +#define FMTPGM_AP6                      0xec
> +#define FMTPGM_AP7                      0xf0
> +#define LSCCFG1                         0xf4
> +#define LSCCFG2                         0xf8
> +#define LSCH0                           0xfc
> +#define LSCV0                           0x100
> +#define LSCKH                           0x104
> +#define LSCKV                           0x108
> +#define LSCMEMCTL                       0x10c
> +#define LSCMEMD                         0x110
> +#define LSCMEMQ                         0x114
> +#define DFCCTL                          0x118
> +#define DFCVSAT                         0x11c
> +#define DFCMEMCTL                       0x120
> +#define DFCMEM0                         0x124
> +#define DFCMEM1                         0x128
> +#define DFCMEM2                         0x12c
> +#define DFCMEM3                         0x130
> +#define DFCMEM4                         0x134
> +#define CSCCTL                          0x138
> +#define CSCM0                           0x13c
> +#define CSCM1                           0x140
> +#define CSCM2                           0x144
> +#define CSCM3                           0x148
> +#define CSCM4                           0x14c
> +#define CSCM5                           0x150
> +#define CSCM6                           0x154
> +#define CSCM7                           0x158
> +#define DATAOFST			0x15c

As stated before, this could be replaced by a structure.

> +
> +#define CLKCTRL				0x04
> +
> +/* offset relative to 0x1c70800 */
> +#define INTSTAT				0xC
> +#define INTSEL				0x10
> +#define	EVTSEL				0x14
> +#define MEMCTRL				0x18
> +#define CCDCMUX				0x1C
> +
> +/**************************************************************
> +*	Define for various register bit mask and shifts for CCDC
> +*
> +**************************************************************/
> +#define CCDC_RAW_IP_MODE			(0x00)
> +#define CCDC_VDHDOUT_INPUT			(0x00)
> +#define CCDC_YCINSWP_RAW			(0x00 << 4)
> +#define CCDC_EXWEN_DISABLE 			(0x00)
> +#define CCDC_DATAPOL_NORMAL			(0x00)
> +#define CCDC_CCDCFG_FIDMD_LATCH_VSYNC		(0x00)
> +#define CCDC_CCDCFG_WENLOG_AND			(0x00)
> +#define CCDC_CCDCFG_TRGSEL_WEN			(0x00)
> +#define CCDC_CCDCFG_EXTRG_DISABLE		(0x00)
> +#define CCDC_CFA_MOSAIC				(0x00)
> +
> +#define CCDC_VDC_DFCVSAT_MASK			(0x3fff)
> +#define CCDC_DATAOFST_MASK			(0x0ff)
> +#define CCDC_DATAOFST_H_SHIFT			(0)
> +#define CCDC_DATAOFST_V_SHIFT			(8)
> +#define CCDC_GAMMAWD_CFA_MASK			(0x01)
> +#define CCDC_GAMMAWD_CFA_SHIFT			(5)
> +#define CCDC_FID_POL_MASK			(0x01)
> +#define CCDC_FID_POL_SHIFT			(4)
> +#define CCDC_HD_POL_MASK			(0x01)
> +#define CCDC_HD_POL_SHIFT			(3)
> +#define CCDC_VD_POL_MASK			(0x01)
> +#define CCDC_VD_POL_SHIFT			(2)
> +#define CCDC_FRM_FMT_MASK			(0x01)
> +#define CCDC_FRM_FMT_SHIFT			(7)
> +#define CCDC_DATA_SZ_MASK			(0x07)
> +#define CCDC_DATA_SZ_SHIFT			(8)
> +#define CCDC_VDHDOUT_MASK			(0x01)
> +#define CCDC_VDHDOUT_SHIFT			(0)
> +#define CCDC_EXWEN_MASK				(0x01)
> +#define CCDC_EXWEN_SHIFT			(5)
> +#define CCDC_RAW_INPUT_MASK			(0x03)
> +#define CCDC_RAW_INPUT_SHIFT			(12)
> +#define CCDC_PIX_FMT_MASK			(0x03)
> +#define CCDC_PIX_FMT_SHIFT			(12)
> +#define CCDC_DATAPOL_MASK			(0x01)
> +#define CCDC_DATAPOL_SHIFT			(6)
> +#define CCDC_WEN_ENABLE				(0x01 << 1)
> +#define CCDC_VDHDEN_ENABLE			(0x01 << 16)
> +#define CCDC_LPF_ENABLE				(0x01 << 14)
> +#define CCDC_ALAW_ENABLE			(0x01)
> +#define CCDC_ALAW_GAMA_WD_MASK			(0x07)
> +
> +#define CCDC_FMTCFG_FMTMODE_MASK 		(0x03)
> +#define CCDC_FMTCFG_FMTMODE_SHIFT		(1)
> +#define CCDC_FMTCFG_LNUM_MASK			(0x03)
> +#define CCDC_FMTCFG_LNUM_SHIFT			(4)
> +#define CCDC_FMTCFG_ADDRINC_MASK		(0x07)
> +#define CCDC_FMTCFG_ADDRINC_SHIFT		(8)
> +
> +#define CCDC_CCDCFG_FIDMD_SHIFT			(6)
> +#define	CCDC_CCDCFG_WENLOG_SHIFT		(8)
> +#define CCDC_CCDCFG_TRGSEL_SHIFT		(9)
> +#define CCDC_CCDCFG_EXTRG_SHIFT			(10)
> +#define CCDC_CCDCFG_MSBINVI_SHIFT		(13)
> +
> +#define CCDC_HSIZE_FLIP_SHIFT			(12)
> +#define CCDC_HSIZE_FLIP_MASK			(0x01)
> +
> +#define START_PX_HOR_MASK			(0x7FFF)
> +#define NUM_PX_HOR_MASK				(0x7FFF)
> +#define START_VER_ONE_MASK			(0x7FFF)
> +#define START_VER_TWO_MASK			(0x7FFF)
> +#define NUM_LINES_VER				(0x7FFF)

Please prefix those with CCDC_ as well.

> +
> +#define CCDC_BLK_CLAMP_ENABLE			(0x01 << 15)
> +#define CCDC_BLK_SGAIN_MASK			(0x1F)
> +#define CCDC_BLK_ST_PXL_MASK			(0x1FFF)
> +#define CCDC_BLK_SAMPLE_LN_MASK			(0x03)
> +#define CCDC_BLK_SAMPLE_LN_SHIFT		(13)
> +
> +#define CCDC_NUM_LINE_CALC_MASK			(0x03)
> +#define CCDC_NUM_LINE_CALC_SHIFT		(14)
> +
> +#define CCDC_BLK_DC_SUB_MASK			(0x03FFF)
> +#define CCDC_BLK_COMP_MASK			(0x000000FF)
> +#define CCDC_BLK_COMP_GB_COMP_SHIFT		(8)
> +#define CCDC_BLK_COMP_GR_COMP_SHIFT		(0)
> +#define CCDC_BLK_COMP_R_COMP_SHIFT		(8)
> +#define CCDC_LATCH_ON_VSYNC_DISABLE		(0x01 << 15)
> +#define CCDC_LATCH_ON_VSYNC_ENABLE		(0x00 << 15)
> +#define CCDC_FPC_ENABLE				(0x01 << 15)
> +#define CCDC_FPC_FPC_NUM_MASK 			(0x7FFF)
> +#define CCDC_DATA_PACK_ENABLE			(0x01 << 11)
> +#define CCDC_FMT_HORZ_FMTLNH_MASK		(0x1FFF)
> +#define CCDC_FMT_HORZ_FMTSPH_MASK		(0x1FFF)
> +#define CCDC_FMT_HORZ_FMTSPH_SHIFT		(16)
> +#define CCDC_FMT_VERT_FMTLNV_MASK		(0x1FFF)
> +#define CCDC_FMT_VERT_FMTSLV_MASK		(0x1FFF)
> +#define CCDC_FMT_VERT_FMTSLV_SHIFT		(16)
> +#define CCDC_VP_OUT_VERT_NUM_MASK		(0x3FFF)
> +#define CCDC_VP_OUT_VERT_NUM_SHIFT		(17)
> +#define CCDC_VP_OUT_HORZ_NUM_MASK		(0x1FFF)
> +#define CCDC_VP_OUT_HORZ_NUM_SHIFT		(4)
> +#define CCDC_VP_OUT_HORZ_ST_MASK		(0x000F)
> +
> +#define CCDC_CSC_COEFF_SHIFT			(8)
> +#define CCDC_CSC_COEFF_DEC_MASK			(0x0007)
> +#define CCDC_CSC_COEFF_FRAC_MASK		(0x001F)
> +#define CCDC_CSC_DEC_SHIFT			(5)
> +#define CCDC_CSC_ENABLE				(0x01)
> +#define CCDC_MFILT1_SHIFT			(10)
> +#define CCDC_MFILT2_SHIFT			(8)
> +#define CCDC_LPF_MASK				(0x01)
> +#define CCDC_LPF_SHIFT				(14)
> +#define CCDC_OFFSET_MASK			(0x3FF)
> +#define CCDC_DATASFT_MASK			(0x07)
> +#define CCDC_DATASFT_SHIFT			(8)
> +#define CCDC_DF_ENABLE				(0x01)
> +
> +#define CCDC_FMTPLEN_P0_MASK			(0x000F)
> +#define CCDC_FMTPLEN_P1_MASK			(0x000F)
> +#define CCDC_FMTPLEN_P2_MASK			(0x0007)
> +#define CCDC_FMTPLEN_P3_MASK			(0x0007)
> +#define CCDC_FMTPLEN_P0_SHIFT			(0)
> +#define CCDC_FMTPLEN_P1_SHIFT			(4)
> +#define CCDC_FMTPLEN_P2_SHIFT			(8)
> +#define CCDC_FMTPLEN_P3_SHIFT			(12)
> +
> +#define CCDC_FMTSPH_MASK			(0x01FFF)
> +#define CCDC_FMTLNH_MASK			(0x01FFF)
> +#define CCDC_FMTSLV_MASK			(0x01FFF)
> +#define CCDC_FMTLNV_MASK			(0x07FFF)
> +#define CCDC_FMTRLEN_MASK			(0x01FFF)
> +#define CCDC_FMTHCNT_MASK			(0x01FFF)
> +
> +#define CCDC_ADP_INIT_MASK			(0x01FFF)
> +#define CCDC_ADP_LINE_SHIFT			(13)
> +#define CCDC_ADP_LINE_MASK			(0x0003)
> +#define CCDC_FMTPGN_APTR_MASK			(0x0007)
> +
> +#define CCDC_DFCCTL_GDFCEN_MASK			(0x01)
> +#define CCDC_DFCCTL_VDFCEN_MASK			(0x01)
> +#define CCDC_DFCCTL_VDFCEN_SHIFT		(4)
> +#define CCDC_DFCCTL_VDFCSL_MASK			(0x03)
> +#define CCDC_DFCCTL_VDFCSL_SHIFT		(5)
> +#define CCDC_DFCCTL_VDFCUDA_MASK		(0x01)
> +#define CCDC_DFCCTL_VDFCUDA_SHIFT		(7)
> +#define CCDC_DFCCTL_VDFLSFT_MASK		(0x03)
> +#define CCDC_DFCCTL_VDFLSFT_SHIFT		(8)
> +#define CCDC_DFCMEMCTL_DFCMARST_MASK		(0x01)
> +#define CCDC_DFCMEMCTL_DFCMARST_SHIFT		(2)
> +#define CCDC_DFCMEMCTL_DFCMWR_MASK		(0x01)
> +#define CCDC_DFCMEMCTL_DFCMWR_SHIFT		(0)
> +
> +#define CCDC_LSCCFG_GFTSF_MASK			(0x07)
> +#define CCDC_LSCCFG_GFTSF_SHIFT			(1)
> +#define CCDC_LSCCFG_GFTINV_MASK			(0x0f)
> +#define CCDC_LSCCFG_GFTINV_SHIFT		(4)
> +#define CCDC_LSC_GFTABLE_SEL_MASK		(0x03)
> +#define CCDC_LSC_GFTABLE_EPEL_SHIFT		(8)
> +#define CCDC_LSC_GFTABLE_OPEL_SHIFT		(10)
> +#define CCDC_LSC_GFTABLE_EPOL_SHIFT		(12)
> +#define CCDC_LSC_GFTABLE_OPOL_SHIFT		(14)
> +#define CCDC_LSC_GFMODE_MASK			(0x03)
> +#define CCDC_LSC_GFMODE_SHIFT			(4)
> +#define CCDC_LSC_DISABLE			(0)
> +#define CCDC_LSC_ENABLE				(1)
> +#define CCDC_LSC_TABLE1_SLC			(0)
> +#define CCDC_LSC_TABLE2_SLC			(1)
> +#define CCDC_LSC_TABLE3_SLC			(2)
> +#define CCDC_LSC_MEMADDR_RESET			(1 << 2)
> +#define CCDC_LSC_MEMADDR_INCR			(0 << 2)
> +#define CCDC_LSC_FRAC_MASK_T1			(0xFF)
> +#define CCDC_LSC_INT_MASK			(0x03)
> +#define CCDC_LSC_FRAC_MASK			(0x3FFF)
> +#define CCDC_LSC_CENTRE_MASK			(0x3FFF)
> +#define CCDC_LSC_COEF_MASK			(0x0ff)
> +#define CCDC_LSC_COEFL_SHIFT			(0)
> +#define CCDC_LSC_COEFU_SHIFT			(8)
> +#define CCDC_GAIN_MASK				(0x7FF)
> +#endif
> diff --git a/include/media/davinci/dm355_ccdc.h
> b/include/media/davinci/dm355_ccdc.h new file mode 100644
> index 0000000..be6342b
> --- /dev/null
> +++ b/include/media/davinci/dm355_ccdc.h
> @@ -0,0 +1,477 @@
> +/*
> + * Copyright (C) 2005-2009 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +#ifndef _DM355_CCDC_H
> +#define _DM355_CCDC_H
> +#include <media/davinci/ccdc_types.h>
> +#include <media/davinci/vpfe_types.h>
> +
> +/* Define to enable/disable video port */
> +
> +#define CCDC_WIN_PAL	{0, 0, 720, 576}
> +#define CCDC_WIN_VGA	{0, 0, 640, 480}
> +

Most enumerations have too generic names, especially for a header exported to 
userspace. Beside, you shouldn't use enumerations in userspace <-> kernelspace 
APIs, especially on ARMs. Use #define instead, or, even better, integers where 
possible (for the sample length for instance).

> +/* enum for No of pixel per line to be avg. in Black Clamping */
> +enum sample_length {
> +	_1PIXELS,
> +	_2PIXELS,
> +	_4PIXELS,
> +	_8PIXELS,
> +	_16PIXELS
> +};
> +
> +/* enum for No of lines in Black Clamping */
> +enum sample_line {
> +	_1LINES,
> +	_2LINES,
> +	_4LINES,
> +	_8LINES,
> +	_16LINES
> +};
> +
> +/* enum for Alaw gama width */
> +enum gama_width {
> +	BITS_13_4,
> +	BITS_12_3,
> +	BITS_11_2,
> +	BITS_10_1,
> +	BITS_09_0
> +};
> +
> +enum ccdc_colpats {
> +	CCDC_RED,
> +	CCDC_GREEN_RED,
> +	CCDC_GREEN_BLUE,
> +	CCDC_BLUE
> +};
> +
> +struct ccdc_col_pat {
> +	enum ccdc_colpats olop;
> +	enum ccdc_colpats olep;
> +	enum ccdc_colpats elop;
> +	enum ccdc_colpats elep;
> +};
> +
> +enum ccdc_datasft {
> +	NO_SHIFT,
> +	_1BIT,
> +	_2BIT,
> +	_3BIT,
> +	_4BIT,
> +	_5BIT,
> +	_6BIT
> +};
> +
> +enum data_size {
> +	_16BITS,
> +	_15BITS,
> +	_14BITS,
> +	_13BITS,
> +	_12BITS,
> +	_11BITS,
> +	_10BITS,
> +	_8BITS
> +};
> +enum ccdc_mfilt1 {
> +	NO_MEDIAN_FILTER1,
> +	AVERAGE_FILTER1,
> +	MEDIAN_FILTER1
> +};
> +
> +enum ccdc_mfilt2 {
> +	NO_MEDIAN_FILTER2 = 0,
> +	AVERAGE_FILTER2,
> +	MEDIAN_FILTER2
> +};
> +
> +
> +/* structure for ALaw */
> +struct ccdc_a_law {
> +	/* Enable/disable A-Law */
> +	unsigned char b_alaw_enable;
> +	/* Gama Width Input */
> +	enum gama_width gama_wd;
> +};
> +
> +/* structure for Black Clamping */
> +struct ccdc_black_clamp {
> +	/* only if bClampEnable is TRUE */
> +	unsigned char b_clamp_enable;
> +	/* only if bClampEnable is TRUE */
> +	enum sample_length sample_pixel;
> +	/* only if bClampEnable is TRUE */
> +	enum sample_line sample_ln;
> +	/* only if bClampEnable is TRUE */
> +	unsigned short start_pixel;
> +	/* only if bClampEnable is FALSE */
> +	unsigned short sgain;
> +	unsigned short dc_sub;
> +};
> +
> +/* structure for Black Level Compensation */
> +struct black_compensation {
> +	/* Constant value to subtract from Red component */
> +	unsigned char r_comp;
> +	/* Constant value to subtract from Gr component */
> +	unsigned char gr_comp;
> +	/* Constant value to subtract from Blue component */
> +	unsigned char b_comp;
> +	/* Constant value to subtract from Gb component */
> +	unsigned char gb_comp;
> +};
> +
> +/* structures for lens shading correction */
> +
> +/* gain factor modes */
> +enum gfmode {
> +	u8q8_interpol,
> +	u16q14_interpol,
> +	reserved,
> +	u16q14
> +};
> +
> +enum gf_table_sel {
> +	table1 = 0,
> +	table2,
> +	table3
> +};
> +
> +/* LSC configuration structure */
> +struct lsccfg {
> +	enum gfmode mode;
> +	int gf_table_scaling_fact;
> +	int gf_table_interval;
> +	enum gf_table_sel epel;
> +	enum gf_table_sel opel;
> +	enum gf_table_sel epol;
> +	enum gf_table_sel opol;
> +};
> +
> +struct float_ccdc {
> +	unsigned int int_no;
> +	unsigned int frac_no;
> +};
> +
> +/* Main structure for lens shading correction */
> +struct lens_shading_corr {
> +	unsigned char lsc_enable;
> +	struct lsccfg lsc_config;
> +	unsigned int lens_center_horz;
> +	unsigned int lens_center_vert;
> +	struct float_ccdc horz_left_coef;
> +	struct float_ccdc horz_right_coef;
> +	struct float_ccdc ver_low_coef;
> +	struct float_ccdc ver_up_coef;
> +	struct float_ccdc gf_table1[256];
> +	/* int_no will be always 0 since it is u8q8 */
> +	struct float_ccdc gf_table2[128];
> +	struct float_ccdc gf_table3[128];
> +};
> +
> +/* structure for color space converter */
> +struct color_space_converter {
> +	unsigned char csc_enable;
> +	int csc_dec_coeff[16];
> +	int csc_frac_coeff[16];
> +};
> +
> +/*supporting structures for data formatter*/
> +enum fmtmode {
> +	split,
> +	combine,
> +	line_alt_mode
> +};
> +
> +enum line_num {
> +	_1line,
> +	_2lines,
> +	_3lines,
> +	_4lines
> +};
> +
> +enum line_pos {
> +	_1stline,
> +	_2ndline,
> +	_3rdline,
> +	_4thline
> +};
> +
> +struct fmtplen {
> +	unsigned int plen0;
> +	unsigned int plen1;
> +	unsigned int plen2;
> +	unsigned int plen3;
> +};
> +
> +struct fmtcfg {
> +	enum fmtmode mode;
> +	enum line_num lnum;
> +	unsigned int addrinc;
> +};
> +
> +struct fmtaddr_ptr {
> +	unsigned int init;
> +	enum line_pos line;
> +};
> +
> +struct fmtpgm_ap {
> +	unsigned int pgm_aptr;
> +	unsigned char pgmupdt;
> +};
> +
> +/* Main Structure for data formatter*/
> +struct data_formatter {
> +	unsigned char fmt_enable;
> +	struct fmtcfg cfg;
> +	struct fmtplen plen;
> +	unsigned int fmtsph;
> +	unsigned int fmtlnh;
> +	unsigned int fmtslv;
> +	unsigned int fmtlnv;
> +	unsigned int fmtrlen;
> +	unsigned int fmthcnt;
> +	struct fmtaddr_ptr addr_ptr[8];
> +	unsigned char pgm_en[32];
> +	struct fmtpgm_ap pgm_ap[32];
> +};
> +
> +/* Structures for Vertical Defect Correction*/
> +enum vdf_csl {
> +	normal = 0,
> +	horz_interpol_sat,
> +	horz_interpol
> +};
> +
> +enum vdf_cuda {
> +	whole_line_correct,
> +	upper_disable
> +};
> +
> +enum dfc_mwr {
> +	write_complete,
> +	write_reg
> +};
> +
> +enum dfc_mrd {
> +	read_complete,
> +	read_reg
> +};
> +
> +enum dfc_ma_rst {
> +	incr_addr,
> +	clr_addr
> +};
> +
> +enum dfc_mclr {
> +	clear_complete,
> +	clear
> +};
> +
> +struct dft_corr_ctl_s {
> +	enum vdf_csl vdfcsl;
> +	enum vdf_cuda vdfcuda;
> +	unsigned int vdflsft;
> +};
> +
> +struct dft_corr_mem_ctl_s {
> +	enum dfc_mwr dfcmwr;
> +	enum dfc_mrd dfcmrd;
> +	enum dfc_ma_rst dfcmarst;
> +	enum dfc_mclr dfcmclr;
> +};
> +
> +/*
> + * Main Structure for vertical defect correction. Vertical defect
> + * correction can correct upto 16 defects if defects less than 16
> + * then pad the rest with 0
> + */
> +struct vertical_dft_s {
> +	unsigned char ver_dft_en;
> +	unsigned char gen_dft_en;
> +	unsigned int saturation_ctl;
> +	struct dft_corr_ctl_s dft_corr_ctl;
> +	struct dft_corr_mem_ctl_s dft_corr_mem_ctl;
> +	unsigned int dft_corr_horz[16];
> +	unsigned int dft_corr_vert[16];
> +	unsigned int dft_corr_sub1[16];
> +	unsigned int dft_corr_sub2[16];
> +	unsigned int dft_corr_sub3[16];
> +};
> +
> +struct data_offset {
> +	unsigned char horz_offset;
> +	unsigned char vert_offset;
> +};
> +
> +/*
> + * Structure for CCDC configuration parameters for raw capture mode passed
> + * by application
> + */
> +struct ccdc_config_params_raw {
> +	/* data shift to be applied before storing */
> +	enum ccdc_datasft datasft;
> +	/* data size value from 8 to 16 bits */
> +	enum data_size data_sz;
> +	/* median filter for sdram */
> +	enum ccdc_mfilt1 mfilt1;
> +	enum ccdc_mfilt2 mfilt2;
> +	/* median filter for ipipe */
> +	/* low pass filter enable/disable */
> +	unsigned char lpf_enable;
> +	unsigned char horz_flip_enable;
> +	/* offset value to be applied to data,  Range is 0 to 1023 */
> +	unsigned int ccdc_offset;
> +	/* Threshold of median filter */
> +	int med_filt_thres;
> +	/* enable to store the image in inverse */
> +	unsigned char image_invert_enable;
> +	/* horz and vertical data offset */
> +	struct data_offset data_offset_s;
> +	/* Structure for Optional A-Law */
> +	struct ccdc_a_law alaw;
> +	/* Structure for Optical Black Clamp */
> +	struct ccdc_black_clamp blk_clamp;
> +	/* Structure for Black Compensation */
> +	struct black_compensation blk_comp;
> +	/* struture for vertical Defect Correction Module Configuration */
> +	struct vertical_dft_s vertical_dft;
> +	/* structure for lens shading Correction Module Configuration */
> +	struct lens_shading_corr lens_sh_corr;
> +	/* structure for data formatter Module Configuration */
> +	struct data_formatter data_formatter_r;
> +	/* structure for color space converter Module Configuration */
> +	struct color_space_converter color_space_con;
> +	/* color patters for bayer capture */
> +	struct ccdc_col_pat col_pat_field0;
> +	struct ccdc_col_pat col_pat_field1;
> +};
> +
> +#ifdef __KERNEL__
> +#include <linux/io.h>
> +
> +/*
> + * CCDC specific controls for Bayer capture. The CIDs
> + * listed here should match with that in davinci_vpfe.h
> + */
> +
> +/* White balance on Bayer RGB. U11Q8 */
> +#define CCDC_CID_R_GAIN		(V4L2_CID_PRIVATE_BASE + 0)
> +#define CCDC_CID_GR_GAIN	(V4L2_CID_PRIVATE_BASE + 1)
> +#define CCDC_CID_GB_GAIN 	(V4L2_CID_PRIVATE_BASE + 2)
> +#define CCDC_CID_B_GAIN 	(V4L2_CID_PRIVATE_BASE + 3)
> +/* Offsets */
> +#define CCDC_CID_OFFSET 	(V4L2_CID_PRIVATE_BASE + 4)
> +#define CCDC_CID_MAX		(V4L2_CID_PRIVATE_BASE + 5)
> +#define CCDC_MAX_CONTROLS 5
> +
> +struct ccdc_imgwin {
> +	unsigned int top;
> +	unsigned int left;
> +	unsigned int width;
> +	unsigned int height;
> +};

Why don't you use v4l2_rect ?

> +
> +struct ccdc_params_ycbcr {
> +	/* pixel format */
> +	enum ccdc_pixfmt pix_fmt;
> +	/* progressive or interlaced frame */
> +	enum ccdc_frmfmt frm_fmt;
> +	/* video window */
> +	struct ccdc_imgwin win;
> +	/* field id polarity */
> +	enum vpfe_pin_pol fid_pol;
> +	/* vertical sync polarity */
> +	enum vpfe_pin_pol vd_pol;
> +	/* horizontal sync polarity */
> +	enum vpfe_pin_pol hd_pol;
> +	/* enable BT.656 embedded sync mode */
> +	int bt656_enable;
> +	/* cb:y:cr:y or y:cb:y:cr in memory */
> +	enum ccdc_pixorder pix_order;
> +	/* interleaved or separated fields  */
> +	enum ccdc_buftype buf_type;
> +};
> +
> +/* Gain applied to Raw Bayer data */
> +struct ccdc_gain {
> +	unsigned short r_ye;
> +	unsigned short gr_cy;
> +	unsigned short gb_g;
> +	unsigned short b_mg;
> +};
> +
> +/* Structure for CCDC configuration parameters for raw capture mode */
> +struct ccdc_params_raw {
> +	/* pixel format */
> +	enum ccdc_pixfmt pix_fmt;
> +	/* progressive or interlaced frame */
> +	enum ccdc_frmfmt frm_fmt;
> +	/* video window */
> +	struct ccdc_imgwin win;
> +	/* field id polarity */
> +	enum vpfe_pin_pol fid_pol;
> +	/* vertical sync polarity */
> +	enum vpfe_pin_pol vd_pol;
> +	/* horizontal sync polarity */
> +	enum vpfe_pin_pol hd_pol;
> +	/* interleaved or separated fields */
> +	enum ccdc_buftype buf_type;
> +	/*data shift to be applied before storing */
> +	enum ccdc_datasft datasft;
> +	/*median filter for sdram */
> +	enum ccdc_mfilt1 mfilt1;
> +	/*median filter for ipipe */
> +	enum ccdc_mfilt2 mfilt2;
> +	/*low pass filter enable/disable */
> +	unsigned char lpf_enable;
> +	unsigned char horz_flip_enable;
> +	/*offset value to be applied to data, Range is 0 to 1023 */
> +	unsigned int ccdc_offset;
> +	/* Gain values */
> +	struct ccdc_gain gain;
> +	/* Threshold of median filter */
> +	int med_filt_thres;
> +	/*
> +	 * enable to store the image in inverse order in memory
> +	 * (bottom to top)
> +	 */
> +	unsigned char image_invert_enable;
> +	/* data size value from 8 to 16 bits */
> +	enum data_size data_sz;
> +	/* Structure for Optional A-Law */
> +	struct ccdc_a_law alaw;
> +	/* horz and vertical data offset */
> +	struct data_offset data_offset_s;
> +	/* Structure for Optical Black Clamp */
> +	struct ccdc_black_clamp blk_clamp;
> +	/* Structure for Black Compensation */
> +	struct black_compensation blk_comp;
> +	/* struture for vertical Defect Correction Module Configuration */
> +	struct vertical_dft_s vertical_dft;
> +	/* structure for lens shading Correction Module Configuration */
> +	struct lens_shading_corr lens_sh_corr;
> +	/* structure for data formatter Module Configuration */
> +	struct data_formatter data_formatter_r;
> +	/* structure for color space converter Module Configuration */
> +	struct color_space_converter color_space_con;
> +	/* color patters for bayer capture */
> +	struct ccdc_col_pat col_pat_field0;
> +	struct ccdc_col_pat col_pat_field1;
> +};
> +
> +#endif
> +#endif				/* DM355_CCDC_H */

Best regards,

Laurent Pinchart

