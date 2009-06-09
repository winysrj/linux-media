Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42156 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZFISsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 14:48:51 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n59ImmfF016289
	for <linux-media@vger.kernel.org>; Tue, 9 Jun 2009 13:48:53 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 3/10 - v2] dm355 ccdc module for vpfe capture driver
Date: Tue,  9 Jun 2009 14:48:46 -0400
Message-Id: <1244573327-20463-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

DM355 CCDC hw module

Adds ccdc hw module for DM355 CCDC. This registers with the bridge
driver a set of hw_ops for configuring the CCDC for a specific
decoder device connected to vpfe.

Following are some of the major comments addressed :-
	1) removed vpss configration from this module to a standalone
	   vpss module that can be used by other video drivers as well
	2) replaced magic numbers with #defines
	3) cleaned up and refractored ccdc_config_raw()
	4) embedded config part of the variables inside
	   ccdc_params_raw to help in memcpy.
	5) avoided generic names for ccdc types in include file by
	   prefixing with  ccdc_

Reviewed By "Hans Verkuil". 
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/dm355_ccdc.c      | 1161 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm355_ccdc_regs.h |  310 +++++++
 include/media/davinci/dm355_ccdc.h            |  336 +++++++
 3 files changed, 1807 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm355_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm355_ccdc_regs.h
 create mode 100644 include/media/davinci/dm355_ccdc.h

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
new file mode 100644
index 0000000..1e7152e
--- /dev/null
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -0,0 +1,1161 @@
+/*
+ * Copyright (C) 2005-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * CCDC hardware module for DM355
+ * ------------------------------
+ *
+ * This module is for configuring DM355 CCD controller of VPFE to capture
+ * Raw yuv or Bayer RGB data from a decoder. CCDC has several modules
+ * such as Defect Pixel Correction, Color Space Conversion etc to
+ * pre-process the Bayer RGB data, before writing it to SDRAM. This
+ * module also allows application to configure individual
+ * module parameters through VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL.
+ * To do so, application include dm355_ccdc.h and vpfe_capture.h header
+ * files. The setparams() API is called by vpfe_capture driver
+ * to configure module parameters
+ *
+ * TODO: 1) Raw bayer parameter settings and bayer capture
+ * 	 2) Split module parameter structure to module specific ioctl structs
+ *	 3) add support for lense shading correction
+ *	 4) investigate if enum used for user space type definition
+ * 	    to be replaced by #defines or integer
+ */
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+#include <media/davinci/dm355_ccdc.h>
+#include <media/davinci/vpss.h>
+#include "dm355_ccdc_regs.h"
+#include "ccdc_hw_device.h"
+
+static struct device *dev;
+
+/* Object for CCDC raw mode */
+static struct ccdc_params_raw ccdc_hw_params_raw = {
+	.pix_fmt = CCDC_PIXFMT_RAW,
+	.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
+	.win = CCDC_WIN_VGA,
+	.fid_pol = VPFE_PINPOL_POSITIVE,
+	.vd_pol = VPFE_PINPOL_POSITIVE,
+	.hd_pol = VPFE_PINPOL_POSITIVE,
+	.gain = {
+		.r_ye = 256,
+		.gb_g = 256,
+		.gr_cy = 256,
+		.b_mg = 256
+	},
+	.config_params = {
+		.datasft = 2,
+		.data_sz = CCDC_DATA_10BITS,
+		.mfilt1 = CCDC_NO_MEDIAN_FILTER1,
+		.mfilt2 = CCDC_NO_MEDIAN_FILTER2,
+		.alaw = {
+			.gama_wd = 2,
+		},
+		.blk_clamp = {
+			.sample_pixel = 1,
+			.dc_sub = 25
+		},
+		.col_pat_field0 = {
+			.olop = CCDC_GREEN_BLUE,
+			.olep = CCDC_BLUE,
+			.elop = CCDC_RED,
+			.elep = CCDC_GREEN_RED
+		},
+		.col_pat_field1 = {
+			.olop = CCDC_GREEN_BLUE,
+			.olep = CCDC_BLUE,
+			.elop = CCDC_RED,
+			.elep = CCDC_GREEN_RED
+		},
+	},
+};
+
+
+/* Object for CCDC ycbcr mode */
+static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
+	.win = CCDC_WIN_PAL,
+	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
+	.frm_fmt = CCDC_FRMFMT_INTERLACED,
+	.fid_pol = VPFE_PINPOL_POSITIVE,
+	.vd_pol = VPFE_PINPOL_POSITIVE,
+	.hd_pol = VPFE_PINPOL_POSITIVE,
+	.bt656_enable = 1,
+	.pix_order = CCDC_PIXORDER_CBYCRY,
+	.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
+};
+
+static struct v4l2_queryctrl ccdc_control_info[] = {
+	{
+		.id = CCDC_CID_R_GAIN,
+		.name = "R/Ye WB Gain",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 2047,
+		.step = 1,
+		.default_value = 256
+	},
+	{
+		.id = CCDC_CID_GR_GAIN,
+		.name = "Gr/Cy WB Gain",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 2047,
+		.step = 1,
+		.default_value = 256
+	},
+	{
+		.id = CCDC_CID_GB_GAIN,
+		.name = "Gb/G WB Gain",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 2047,
+		.step = 1,
+		.default_value = 256
+	},
+	{
+		.id = CCDC_CID_B_GAIN,
+		.name = "B/Mg WB Gain",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 2047,
+		.step = 1,
+		.default_value = 256
+	},
+	{
+		.id = CCDC_CID_OFFSET,
+		.name = "Offset",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 1023,
+		.step = 1,
+		.default_value = 0
+	}
+};
+
+static enum vpfe_hw_if_type ccdc_if_type;
+static void *__iomem ccdc_base_addr;
+static int ccdc_addr_size;
+
+/* Raw Bayer formats */
+static u32 ccdc_raw_bayer_pix_formats[] =
+		{V4L2_PIX_FMT_SBGGR8, V4L2_PIX_FMT_SBGGR16};
+
+/* Raw YUV formats */
+static u32 ccdc_raw_yuv_pix_formats[] =
+		{V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};
+
+/* register access routines */
+static inline u32 regr(u32 offset)
+{
+	return __raw_readl(ccdc_base_addr + offset);
+}
+
+static inline void regw(u32 val, u32 offset)
+{
+	__raw_writel(val, ccdc_base_addr + offset);
+}
+
+static void ccdc_set_ccdc_base(void *addr, int size)
+{
+	ccdc_base_addr = addr;
+	ccdc_addr_size = size;
+}
+
+static void ccdc_enable(int en)
+{
+	unsigned int temp;
+	temp = regr(SYNCEN);
+	temp &= (~CCDC_SYNCEN_VDHDEN_MASK);
+	temp |= (en & CCDC_SYNCEN_VDHDEN_MASK);
+	regw(temp, SYNCEN);
+}
+
+static void ccdc_enable_output_to_sdram(int en)
+{
+	unsigned int temp;
+	temp = regr(SYNCEN);
+	temp &= (~(CCDC_SYNCEN_WEN_MASK));
+	temp |= ((en << CCDC_SYNCEN_WEN_SHIFT) & CCDC_SYNCEN_WEN_MASK);
+	regw(temp, SYNCEN);
+}
+
+static void ccdc_config_gain_offset(void)
+{
+	/* configure gain */
+	regw(ccdc_hw_params_raw.gain.r_ye, RYEGAIN);
+	regw(ccdc_hw_params_raw.gain.gr_cy, GRCYGAIN);
+	regw(ccdc_hw_params_raw.gain.gb_g, GBGGAIN);
+	regw(ccdc_hw_params_raw.gain.b_mg, BMGGAIN);
+	/* configure offset */
+	regw(ccdc_hw_params_raw.ccdc_offset, OFFSET);
+}
+
+/* Query control. Only applicable for Bayer capture */
+static int ccdc_queryctrl(struct v4l2_queryctrl *qctrl)
+{
+	struct v4l2_queryctrl *control = NULL;
+	int i, id;
+
+	dev_dbg(dev, "ccdc_queryctrl: start\n");
+
+	if (VPFE_RAW_BAYER != ccdc_if_type) {
+		dev_dbg(dev,
+		       "ccdc_queryctrl : Not doing Raw Bayer Capture\n");
+		return -EINVAL;
+	}
+
+	id = qctrl->id;
+	memset(qctrl, 0, sizeof(struct v4l2_queryctrl));
+	for (i = 0; i < ARRAY_SIZE(ccdc_control_info); i++) {
+		control = &ccdc_control_info[i];
+		if (control->id == id)
+			break;
+	}
+	if (i == ARRAY_SIZE(ccdc_control_info)) {
+		dev_dbg(dev, "ccdc_queryctrl : Invalid control ID\n");
+		return -EINVAL;
+	}
+	memcpy(qctrl, control, sizeof(*qctrl));
+	dev_dbg(dev, "ccdc_queryctrl: end\n");
+	return 0;
+}
+
+static int ccdc_set_control(struct v4l2_control *ctrl)
+{
+	int i;
+	struct v4l2_queryctrl *control = NULL;
+	struct ccdc_gain *gain =
+	    &ccdc_hw_params_raw.gain;
+
+	if (ccdc_if_type != VPFE_RAW_BAYER) {
+		dev_dbg(dev,
+		       "ccdc_set_control: Not doing Raw Bayer Capture\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ccdc_control_info); i++) {
+		control = &ccdc_control_info[i];
+		if (control->id == ctrl->id)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(ccdc_control_info)) {
+		dev_dbg(dev, "ccdc_queryctrl : Invalid control ID, 0x%x\n",
+		       control->id);
+		return -EINVAL;
+	}
+
+	if (ctrl->value > control->maximum ||
+	    ctrl->value < control->minimum) {
+		dev_dbg(dev, "ccdc_queryctrl : Invalid control value\n");
+		return -EINVAL;
+	}
+
+	switch (ctrl->id) {
+	case CCDC_CID_R_GAIN:
+		gain->r_ye = ctrl->value & CCDC_GAIN_MASK;
+		regw(gain->r_ye, RYEGAIN);
+		break;
+	case CCDC_CID_GR_GAIN:
+		gain->gr_cy = ctrl->value & CCDC_GAIN_MASK;
+		regw(gain->gr_cy, GRCYGAIN);
+		break;
+	case CCDC_CID_GB_GAIN:
+		gain->gb_g = ctrl->value  & CCDC_GAIN_MASK;
+		regw(gain->gb_g, GBGGAIN);
+		break;
+	case CCDC_CID_B_GAIN:
+		gain->b_mg = ctrl->value  & CCDC_GAIN_MASK;
+		regw(gain->b_mg, BMGGAIN);
+		break;
+	default:
+		/*
+		 * Since we validate the control ids earlier, the default
+		 * will be offset
+		 */
+		ccdc_hw_params_raw.ccdc_offset = ctrl->value & CCDC_OFFSET_MASK;
+		regw(ccdc_hw_params_raw.ccdc_offset, OFFSET);
+	}
+	return 0;
+}
+
+static int ccdc_get_control(struct v4l2_control *ctrl)
+{
+	int i;
+	struct v4l2_queryctrl *control = NULL;
+
+	if (ccdc_if_type != VPFE_RAW_BAYER) {
+		dev_dbg(dev,
+		       "ccdc_get_control: Not doing Raw Bayer Capture\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ccdc_control_info); i++) {
+		control = &ccdc_control_info[i];
+		if (control->id == ctrl->id)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(ccdc_control_info)) {
+		dev_dbg(dev, "ccdc_get_control: Invalid control ID\n");
+		return -EINVAL;
+	}
+
+	switch (ctrl->id) {
+	case CCDC_CID_R_GAIN:
+		ctrl->value = ccdc_hw_params_raw.gain.r_ye;
+		break;
+	case CCDC_CID_GR_GAIN:
+		ctrl->value = ccdc_hw_params_raw.gain.gr_cy;
+		break;
+	case CCDC_CID_GB_GAIN:
+		ctrl->value = ccdc_hw_params_raw.gain.gb_g;
+		break;
+	case CCDC_CID_B_GAIN:
+		ctrl->value = ccdc_hw_params_raw.gain.b_mg;
+		break;
+	default:
+		/*
+		 * Since we validate the control ids earlier, the default
+		 * will be offset
+		 */
+		ctrl->value = ccdc_hw_params_raw.ccdc_offset;
+	}
+	return 0;
+}
+
+/*
+ * ccdc_restore_defaults()
+ * This function restore power on defaults in the ccdc registers
+ */
+static int ccdc_restore_defaults(void)
+{
+	int i;
+
+	dev_dbg(dev, "\nstarting ccdc_restore_defaults...");
+	/* set all registers to zero */
+	for (i = 0; i <= CCDC_REG_LAST; i += 4)
+		regw(0, i);
+
+	/* now override the values with power on defaults in registers */
+	regw(MODESET_DEFAULT, MODESET);
+	/* no culling support */
+	regw(CULH_DEFAULT, CULH);
+	regw(CULV_DEFAULT, CULV);
+	/* Set default Gain and Offset */
+	ccdc_hw_params_raw.gain.r_ye = GAIN_DEFAULT;
+	ccdc_hw_params_raw.gain.gb_g = GAIN_DEFAULT;
+	ccdc_hw_params_raw.gain.gr_cy = GAIN_DEFAULT;
+	ccdc_hw_params_raw.gain.b_mg = GAIN_DEFAULT;
+	ccdc_config_gain_offset();
+	regw(OUTCLIP_DEFAULT, OUTCLIP);
+	regw(LSCCFG2_DEFAULT, LSCCFG2);
+	/* select ccdc input */
+	if (vpss_select_ccdc_source(VPSS_CCDCIN)) {
+		dev_dbg(dev, "\ncouldn't select ccdc input source");
+		return -EFAULT;
+	}
+	/* select ccdc clock */
+	if (vpss_enable_clock(VPSS_CCDC_CLOCK, 1) < 0) {
+		dev_dbg(dev, "\ncouldn't enable ccdc clock");
+		return -EFAULT;
+	}
+	dev_dbg(dev, "\nEnd of ccdc_restore_defaults...");
+	return 0;
+}
+
+static int ccdc_open(struct device *device)
+{
+	dev = device;
+	return ccdc_restore_defaults();
+}
+
+static int ccdc_close(struct device *device)
+{
+	/* disable clock */
+	vpss_enable_clock(VPSS_CCDC_CLOCK, 0);
+	/* do nothing for now */
+	return 0;
+}
+/*
+ * ccdc_setwin()
+ * This function will configure the window size to
+ * be capture in CCDC reg.
+ */
+static void ccdc_setwin(struct v4l2_rect *image_win,
+			enum ccdc_frmfmt frm_fmt, int ppc)
+{
+	int horz_start, horz_nr_pixels;
+	int vert_start, vert_nr_lines;
+	int mid_img = 0;
+
+	dev_dbg(dev, "\nStarting ccdc_setwin...");
+
+	/*
+	 * ppc - per pixel count. indicates how many pixels per cell
+	 * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
+	 * raw capture this is 1
+	 */
+	horz_start = image_win->left << (ppc - 1);
+	horz_nr_pixels = ((image_win->width) << (ppc - 1)) - 1;
+
+	/* Writing the horizontal info into the registers */
+	regw(horz_start, SPH);
+	regw(horz_nr_pixels, NPH);
+	vert_start = image_win->top;
+
+	if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		vert_nr_lines = (image_win->height >> 1) - 1;
+		vert_start >>= 1;
+		/* Since first line doesn't have any data */
+		vert_start += 1;
+		/* configure VDINT0 and VDINT1 */
+		regw(vert_start, VDINT0);
+	} else {
+		/* Since first line doesn't have any data */
+		vert_start += 1;
+		vert_nr_lines = image_win->height - 1;
+		/* configure VDINT0 and VDINT1 */
+		mid_img = vert_start + (image_win->height / 2);
+		regw(vert_start, VDINT0);
+		regw(mid_img, VDINT1);
+	}
+	regw(vert_start & CCDC_START_VER_ONE_MASK, SLV0);
+	regw(vert_start & CCDC_START_VER_TWO_MASK, SLV1);
+	regw(vert_nr_lines & CCDC_NUM_LINES_VER, NLV);
+	dev_dbg(dev, "\nEnd of ccdc_setwin...");
+}
+
+static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
+{
+	if (ccdcparam->datasft < CCDC_DATA_NO_SHIFT ||
+	    ccdcparam->datasft > CCDC_DATA_SHIFT_6BIT) {
+		dev_dbg(dev, "Invalid value of data shift\n");
+		return -EINVAL;
+	}
+
+	if (ccdcparam->mfilt1 < CCDC_NO_MEDIAN_FILTER1 ||
+	    ccdcparam->mfilt1 > CCDC_MEDIAN_FILTER1) {
+		dev_dbg(dev, "Invalid value of median filter1\n");
+		return -EINVAL;
+	}
+
+	if (ccdcparam->mfilt2 < CCDC_NO_MEDIAN_FILTER2 ||
+	    ccdcparam->mfilt2 > CCDC_MEDIAN_FILTER2) {
+		dev_dbg(dev, "Invalid value of median filter2\n");
+		return -EINVAL;
+	}
+
+	if ((ccdcparam->med_filt_thres < 0) ||
+	   (ccdcparam->med_filt_thres > CCDC_MED_FILT_THRESH)) {
+		dev_dbg(dev, "Invalid value of median filter thresold\n");
+		return -EINVAL;
+	}
+
+	if (ccdcparam->data_sz < CCDC_DATA_16BITS ||
+	    ccdcparam->data_sz > CCDC_DATA_8BITS) {
+		dev_dbg(dev, "Invalid value of data size\n");
+		return -EINVAL;
+	}
+
+	if (ccdcparam->alaw.enable) {
+		if (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_13_4 ||
+		    ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) {
+			dev_dbg(dev, "Invalid value of ALAW\n");
+			return -EINVAL;
+		}
+	}
+
+	if (ccdcparam->blk_clamp.b_clamp_enable) {
+		if (ccdcparam->blk_clamp.sample_pixel < CCDC_SAMPLE_1PIXELS ||
+		    ccdcparam->blk_clamp.sample_pixel > CCDC_SAMPLE_16PIXELS) {
+			dev_dbg(dev, "Invalid value of sample pixel\n");
+			return -EINVAL;
+		}
+		if (ccdcparam->blk_clamp.sample_ln < CCDC_SAMPLE_1LINES ||
+		    ccdcparam->blk_clamp.sample_ln > CCDC_SAMPLE_16LINES) {
+			dev_dbg(dev, "Invalid value of sample lines\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* Parameter operations */
+static int ccdc_set_params(void __user *params)
+{
+	struct ccdc_config_params_raw ccdc_raw_params;
+	int x;
+
+	/* only raw module parameters can be set through the IOCTL */
+	if (ccdc_if_type != VPFE_RAW_BAYER)
+		return -EINVAL;
+
+	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
+	if (x) {
+		dev_dbg(dev, "ccdc_set_params: error in copying ccdc"
+			"params, %d\n", x);
+		return -EFAULT;
+	}
+
+	if (!validate_ccdc_param(&ccdc_raw_params)) {
+		memcpy(&ccdc_hw_params_raw.config_params,
+			&ccdc_raw_params,
+			sizeof(ccdc_raw_params));
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* This function will configure CCDC for YCbCr video capture */
+static void ccdc_config_ycbcr(void)
+{
+	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
+	u32 temp;
+
+	/* first set the CCDC power on defaults values in all registers */
+	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
+	ccdc_restore_defaults();
+
+	/* configure pixel format & video frame format */
+	temp = (((params->pix_fmt & CCDC_INPUT_MODE_MASK) <<
+		CCDC_INPUT_MODE_SHIFT) |
+		((params->frm_fmt & CCDC_FRM_FMT_MASK) <<
+		CCDC_FRM_FMT_SHIFT));
+
+	/* setup BT.656 sync mode */
+	if (params->bt656_enable) {
+		regw(CCDC_REC656IF_BT656_EN, REC656IF);
+		/*
+		 * configure the FID, VD, HD pin polarity fld,hd pol positive,
+		 * vd negative, 8-bit pack mode
+		 */
+		temp |= CCDC_VD_POL_NEGATIVE;
+	} else {		/* y/c external sync mode */
+		temp |= (((params->fid_pol & CCDC_FID_POL_MASK) <<
+			CCDC_FID_POL_SHIFT) |
+			((params->hd_pol & CCDC_HD_POL_MASK) <<
+			CCDC_HD_POL_SHIFT) |
+			((params->vd_pol & CCDC_VD_POL_MASK) <<
+			CCDC_VD_POL_SHIFT));
+	}
+
+	/* pack the data to 8-bit */
+	temp |= CCDC_DATA_PACK_ENABLE;
+
+	regw(temp, MODESET);
+
+	/* configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, 2);
+
+	/* configure the order of y cb cr in SD-RAM */
+	temp = (params->pix_order << CCDC_Y8POS_SHIFT);
+	temp |= CCDC_LATCH_ON_VSYNC_DISABLE | CCDC_CCDCFG_FIDMD_NO_LATCH_VSYNC;
+	regw(temp, CCDCFG);
+
+	/*
+	 * configure the horizontal line offset. This is done by rounding up
+	 * width to a multiple of 16 pixels and multiply by two to account for
+	 * y:cb:cr 4:2:2 data
+	 */
+	regw(((params->win.width * 2 + 31) >> 5), HSIZE);
+
+	/* configure the memory line offset */
+	if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED) {
+		/* two fields are interleaved in memory */
+		regw(CCDC_SDOFST_FIELD_INTERLEAVED, SDOFST);
+	}
+
+	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
+}
+
+/*
+ * ccdc_config_black_clamp()
+ * configure parameters for Optical Black Clamp
+ */
+static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
+{
+	u32 val;
+
+	if (!bclamp->b_clamp_enable) {
+		/* configure DCSub */
+		regw(bclamp->dc_sub & CCDC_BLK_DC_SUB_MASK, DCSUB);
+		regw(0x0000, CLAMP);
+		return;
+	}
+	/* Enable the Black clamping, set sample lines and pixels */
+	val = (bclamp->start_pixel & CCDC_BLK_ST_PXL_MASK) |
+	      ((bclamp->sample_pixel & CCDC_BLK_SAMPLE_LN_MASK) <<
+		CCDC_BLK_SAMPLE_LN_SHIFT) | CCDC_BLK_CLAMP_ENABLE;
+	regw(val, CLAMP);
+
+	/* If Black clamping is enable then make dcsub 0 */
+	val = (bclamp->sample_ln & CCDC_NUM_LINE_CALC_MASK)
+			<< CCDC_NUM_LINE_CALC_SHIFT;
+	regw(val, DCSUB);
+}
+
+/*
+ * ccdc_config_black_compense()
+ * configure parameters for Black Compensation
+ */
+static void ccdc_config_black_compense(struct ccdc_black_compensation *bcomp)
+{
+	u32 val;
+
+	val = (bcomp->b & CCDC_BLK_COMP_MASK) |
+		((bcomp->gb & CCDC_BLK_COMP_MASK) <<
+		CCDC_BLK_COMP_GB_COMP_SHIFT);
+	regw(val, BLKCMP1);
+
+	val = ((bcomp->gr & CCDC_BLK_COMP_MASK) <<
+		CCDC_BLK_COMP_GR_COMP_SHIFT) |
+		((bcomp->r & CCDC_BLK_COMP_MASK) <<
+		CCDC_BLK_COMP_R_COMP_SHIFT);
+	regw(val, BLKCMP0);
+}
+
+/*
+ * ccdc_write_dfc_entry()
+ * write an entry in the dfc table.
+ */
+int ccdc_write_dfc_entry(int index, struct ccdc_vertical_dft *dfc)
+{
+/* TODO This is to be re-visited and adjusted */
+#define DFC_WRITE_WAIT_COUNT	1000
+	u32 val, count = DFC_WRITE_WAIT_COUNT;
+
+	regw(dfc->dft_corr_vert[index], DFCMEM0);
+	regw(dfc->dft_corr_horz[index], DFCMEM1);
+	regw(dfc->dft_corr_sub1[index], DFCMEM2);
+	regw(dfc->dft_corr_sub2[index], DFCMEM3);
+	regw(dfc->dft_corr_sub3[index], DFCMEM4);
+	/* set WR bit to write */
+	val = regr(DFCMEMCTL) | CCDC_DFCMEMCTL_DFCMWR_MASK;
+	regw(val, DFCMEMCTL);
+
+	/*
+	 * Assume, it is very short. If we get an error, we need to
+	 * adjust this value
+	 */
+	while (regr(DFCMEMCTL) & CCDC_DFCMEMCTL_DFCMWR_MASK)
+		count--;
+	/*
+	 * TODO We expect the count to be non-zero to be successful. Adjust
+	 * the count if write requires more time
+	 */
+
+	if (count) {
+		dev_err(dev, "defect table write timeout !!!\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * ccdc_config_vdfc()
+ * configure parameters for Vertical Defect Correction
+ */
+static int ccdc_config_vdfc(struct ccdc_vertical_dft *dfc)
+{
+	u32 val;
+	int i;
+
+	/* Configure General Defect Correction. The table used is from IPIPE */
+	val = dfc->gen_dft_en & CCDC_DFCCTL_GDFCEN_MASK;
+
+	/* Configure Vertical Defect Correction if needed */
+	if (!dfc->ver_dft_en) {
+		/* Enable only General Defect Correction */
+		regw(val, DFCCTL);
+		return 0;
+	}
+
+	if (dfc->table_size > CCDC_DFT_TABLE_SIZE)
+		return -EINVAL;
+
+	val |= CCDC_DFCCTL_VDFC_DISABLE;
+	val |= (dfc->dft_corr_ctl.vdfcsl & CCDC_DFCCTL_VDFCSL_MASK) <<
+		CCDC_DFCCTL_VDFCSL_SHIFT;
+	val |= (dfc->dft_corr_ctl.vdfcuda & CCDC_DFCCTL_VDFCUDA_MASK) <<
+		CCDC_DFCCTL_VDFCUDA_SHIFT;
+	val |= (dfc->dft_corr_ctl.vdflsft & CCDC_DFCCTL_VDFLSFT_MASK) <<
+		CCDC_DFCCTL_VDFLSFT_SHIFT;
+	regw(val , DFCCTL);
+
+	/* clear address ptr to offset 0 */
+	val = CCDC_DFCMEMCTL_DFCMARST_MASK << CCDC_DFCMEMCTL_DFCMARST_SHIFT;
+
+	/* write defect table entries */
+	for (i = 0; i < dfc->table_size; i++) {
+		/* increment address for non zero index */
+		if (i != 0)
+			val = CCDC_DFCMEMCTL_INC_ADDR;
+		regw(val, DFCMEMCTL);
+		if (ccdc_write_dfc_entry(i, dfc) < 0)
+			return -EFAULT;
+	}
+
+	/* update saturation level and enable dfc */
+	regw(dfc->saturation_ctl & CCDC_VDC_DFCVSAT_MASK, DFCVSAT);
+	val = regr(DFCCTL) | (CCDC_DFCCTL_VDFCEN_MASK <<
+			CCDC_DFCCTL_VDFCEN_SHIFT);
+	regw(val, DFCCTL);
+	return 0;
+}
+
+/*
+ * ccdc_config_csc()
+ * configure parameters for color space conversion
+ * Each register CSCM0-7 has two values in S8Q5 format.
+ */
+static void ccdc_config_csc(struct ccdc_csc *csc)
+{
+	u32 val1, val2;
+	int i;
+
+	if (!csc->enable)
+		return;
+
+	/* Enable the CSC sub-module */
+	regw(CCDC_CSC_ENABLE, CSCCTL);
+
+	/* Converting the co-eff as per the format of the register */
+	for (i = 0; i < CCDC_CSC_COEFF_TABLE_SIZE; i++) {
+		if ((i % 2) == 0) {
+			/* CSCM - LSB */
+			val1 = (csc->coeff[i].integer &
+				CCDC_CSC_COEF_INTEG_MASK)
+				<< CCDC_CSC_COEF_INTEG_SHIFT;
+			/*
+			 * convert decimal part to binary. Use 2 decimal
+			 * precision, user values range from .00 - 0.99
+			 */
+			val1 |= (((csc->coeff[i].decimal &
+				CCDC_CSC_COEF_DECIMAL_MASK) *
+				CCDC_CSC_DEC_MAX) / 100);
+		} else {
+
+			/* CSCM - MSB */
+			val2 = (csc->coeff[i].integer &
+				CCDC_CSC_COEF_INTEG_MASK)
+				<< CCDC_CSC_COEF_INTEG_SHIFT;
+			val2 |= (((csc->coeff[i].decimal &
+				 CCDC_CSC_COEF_DECIMAL_MASK) *
+				 CCDC_CSC_DEC_MAX) / 100);
+			val2 <<= CCDC_CSCM_MSB_SHIFT;
+			val2 |= val1;
+			regw(val2, (CSCM0 + ((i - 1) << 1)));
+		}
+	}
+}
+
+/*
+ * ccdc_config_color_patterns()
+ * configure parameters for color patterns
+ */
+static void ccdc_config_color_patterns(struct ccdc_col_pat *pat0,
+				       struct ccdc_col_pat *pat1)
+{
+	u32 val;
+
+	val = (pat0->olop | (pat0->olep << 2) | (pat0->elop << 4) |
+		(pat0->elep << 6) | (pat1->olop << 8) | (pat1->olep << 10) |
+		(pat1->elop << 12) | (pat1->elep << 14));
+	regw(val, COLPTN);
+}
+
+/* This function will configure CCDC for Raw mode image capture */
+static int ccdc_config_raw(void)
+{
+	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int val;
+
+	dev_dbg(dev, "\nStarting ccdc_config_raw...");
+
+	/* restore power on defaults to register */
+	ccdc_restore_defaults();
+
+	/* CCDCFG register:
+	 * set CCD Not to swap input since input is RAW data
+	 * set FID detection function to Latch at V-Sync
+	 * set WENLOG - ccdc valid area to AND
+	 * set TRGSEL to WENBIT
+	 * set EXTRG to DISABLE
+	 * disable latching function on VSYNC - shadowed registers
+	 */
+	regw(CCDC_YCINSWP_RAW | CCDC_CCDCFG_FIDMD_LATCH_VSYNC |
+	     CCDC_CCDCFG_WENLOG_AND | CCDC_CCDCFG_TRGSEL_WEN |
+	     CCDC_CCDCFG_EXTRG_DISABLE | CCDC_LATCH_ON_VSYNC_DISABLE, CCDCFG);
+
+	/*
+	 * Set VDHD direction to input,  input type to raw input
+	 * normal data polarity, do not use external WEN
+	 */
+	val = (CCDC_VDHDOUT_INPUT | CCDC_RAW_IP_MODE | CCDC_DATAPOL_NORMAL |
+		CCDC_EXWEN_DISABLE);
+
+	/*
+	 * Configure the vertical sync polarity (MODESET.VDPOL), horizontal
+	 * sync polarity (MODESET.HDPOL), field id polarity (MODESET.FLDPOL),
+	 * frame format(progressive or interlace), & pixel format (Input mode)
+	 */
+	val |= (((params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT) |
+		((params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT) |
+		((params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT) |
+		((params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT) |
+		((params->pix_fmt & CCDC_PIX_FMT_MASK) << CCDC_PIX_FMT_SHIFT));
+
+	/* set pack for alaw compression */
+	if ((config_params->data_sz == CCDC_DATA_8BITS) ||
+	     config_params->alaw.enable)
+		val |= CCDC_DATA_PACK_ENABLE;
+
+	/* Configure for LPF */
+	if (config_params->lpf_enable)
+		val |= (config_params->lpf_enable & CCDC_LPF_MASK) <<
+			CCDC_LPF_SHIFT;
+
+	/* Configure the data shift */
+	val |= (config_params->datasft & CCDC_DATASFT_MASK) <<
+		CCDC_DATASFT_SHIFT;
+	regw(val , MODESET);
+	dev_dbg(dev, "\nWriting 0x%x to MODESET...\n", val);
+
+	/* Configure the Median Filter threshold */
+	regw((config_params->med_filt_thres) & CCDC_MED_FILT_THRESH, MEDFILT);
+
+	/* Configure GAMMAWD register. defaur 11-2, and Mosaic cfa pattern */
+	val = CCDC_GAMMA_BITS_11_2 << CCDC_GAMMAWD_INPUT_SHIFT |
+		CCDC_CFA_MOSAIC;
+
+	/* Enable and configure aLaw register if needed */
+	if (config_params->alaw.enable) {
+		val |= (CCDC_ALAW_ENABLE |
+			((config_params->alaw.gama_wd &
+			CCDC_ALAW_GAMA_WD_MASK) <<
+			CCDC_GAMMAWD_INPUT_SHIFT));
+	}
+
+	/* Configure Median filter1 & filter2 */
+	val |= ((config_params->mfilt1 << CCDC_MFILT1_SHIFT) |
+		(config_params->mfilt2 << CCDC_MFILT2_SHIFT));
+
+	regw(val, GAMMAWD);
+	dev_dbg(dev, "\nWriting 0x%x to GAMMAWD...\n", val);
+
+	/* configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, 1);
+
+	/* Optical Clamp Averaging */
+	ccdc_config_black_clamp(&config_params->blk_clamp);
+
+	/* Black level compensation */
+	ccdc_config_black_compense(&config_params->blk_comp);
+
+	/* Vertical Defect Correction if needed */
+	if (ccdc_config_vdfc(&config_params->vertical_dft) < 0)
+		return -EFAULT;
+
+	/* color space conversion */
+	ccdc_config_csc(&config_params->csc);
+
+	/* color pattern */
+	ccdc_config_color_patterns(&config_params->col_pat_field0,
+				   &config_params->col_pat_field1);
+
+	/* Configure the Gain  & offset control */
+	ccdc_config_gain_offset();
+
+	dev_dbg(dev, "\nWriting %x to COLPTN...\n", val);
+
+	/* Configure DATAOFST  register */
+	val = (config_params->data_offset.horz_offset & CCDC_DATAOFST_MASK) <<
+		CCDC_DATAOFST_H_SHIFT;
+	val |= (config_params->data_offset.vert_offset & CCDC_DATAOFST_MASK) <<
+		CCDC_DATAOFST_V_SHIFT;
+	regw(val, DATAOFST);
+
+	/* configuring HSIZE register */
+	val = (params->horz_flip_enable & CCDC_HSIZE_FLIP_MASK) <<
+		CCDC_HSIZE_FLIP_SHIFT;
+
+	/* If pack 8 is enable then 1 pixel will take 1 byte */
+	if ((config_params->data_sz == CCDC_DATA_8BITS) ||
+	     config_params->alaw.enable) {
+		val |= (((params->win.width) + 31) >> 5) &
+			CCDC_HSIZE_VAL_MASK;
+
+		/* adjust to multiple of 32 */
+		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
+		       (((params->win.width) + 31) >> 5) &
+			CCDC_HSIZE_VAL_MASK);
+	} else {
+		/* else one pixel will take 2 byte */
+		val |= (((params->win.width * 2) + 31) >> 5) &
+			CCDC_HSIZE_VAL_MASK;
+
+		dev_dbg(dev, "\nWriting 0x%x to HSIZE...\n",
+		       (((params->win.width * 2) + 31) >> 5) &
+			CCDC_HSIZE_VAL_MASK);
+	}
+	regw(val, HSIZE);
+
+	/* Configure SDOFST register */
+	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		if (params->image_invert_enable) {
+			/* For interlace inverse mode */
+			regw(CCDC_SDOFST_INTERLACE_INVERSE, SDOFST);
+			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
+				CCDC_SDOFST_INTERLACE_INVERSE);
+		} else {
+			/* For interlace non inverse mode */
+			regw(CCDC_SDOFST_INTERLACE_NORMAL, SDOFST);
+			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
+				CCDC_SDOFST_INTERLACE_NORMAL);
+		}
+	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
+		if (params->image_invert_enable) {
+			/* For progessive inverse mode */
+			regw(CCDC_SDOFST_PROGRESSIVE_INVERSE, SDOFST);
+			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
+				CCDC_SDOFST_PROGRESSIVE_INVERSE);
+		} else {
+			/* For progessive non inverse mode */
+			regw(CCDC_SDOFST_PROGRESSIVE_NORMAL, SDOFST);
+			dev_dbg(dev, "\nWriting %x to SDOFST...\n",
+				CCDC_SDOFST_PROGRESSIVE_NORMAL);
+		}
+	}
+	dev_dbg(dev, "\nend of ccdc_config_raw...");
+	return 0;
+}
+
+static int ccdc_configure(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		return ccdc_config_raw();
+	else
+		ccdc_config_ycbcr();
+	return 0;
+}
+
+static int ccdc_set_buftype(enum ccdc_buftype buf_type)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.buf_type = buf_type;
+	else
+		ccdc_hw_params_ycbcr.buf_type = buf_type;
+	return 0;
+}
+static enum ccdc_buftype ccdc_get_buftype(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		return ccdc_hw_params_raw.buf_type;
+	return ccdc_hw_params_ycbcr.buf_type;
+}
+
+static int ccdc_enum_pix(u32 *pix, int i)
+{
+	int ret = -EINVAL;
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if (i < ARRAY_SIZE(ccdc_raw_bayer_pix_formats)) {
+			*pix = ccdc_raw_bayer_pix_formats[i];
+			ret = 0;
+		}
+	} else {
+		if (i < ARRAY_SIZE(ccdc_raw_yuv_pix_formats)) {
+			*pix = ccdc_raw_yuv_pix_formats[i];
+			ret = 0;
+		}
+	}
+	return ret;
+}
+
+static int ccdc_set_pixel_format(u32 pixfmt)
+{
+	struct ccdc_a_law *alaw =
+		&ccdc_hw_params_raw.config_params.alaw;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
+		if (pixfmt == V4L2_PIX_FMT_SBGGR8)
+			alaw->enable = 1;
+		else if (pixfmt != V4L2_PIX_FMT_SBGGR16)
+			return -EINVAL;
+	} else {
+		if (pixfmt == V4L2_PIX_FMT_YUYV)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
+		else if (pixfmt == V4L2_PIX_FMT_UYVY)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		else
+			return -EINVAL;
+	}
+	return 0;
+}
+static u32 ccdc_get_pixel_format(void)
+{
+	struct ccdc_a_law *alaw =
+		&ccdc_hw_params_raw.config_params.alaw;
+	u32 pixfmt;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		if (alaw->enable)
+			pixfmt = V4L2_PIX_FMT_SBGGR8;
+		else
+			pixfmt = V4L2_PIX_FMT_SBGGR16;
+	else {
+		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
+			pixfmt = V4L2_PIX_FMT_YUYV;
+		else
+			pixfmt = V4L2_PIX_FMT_UYVY;
+	}
+	return pixfmt;
+}
+static int ccdc_set_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.win = *win;
+	else
+		ccdc_hw_params_ycbcr.win = *win;
+	return 0;
+}
+
+static void ccdc_get_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		*win = ccdc_hw_params_raw.win;
+	else
+		*win = ccdc_hw_params_ycbcr.win;
+}
+
+static unsigned int ccdc_get_line_length(void)
+{
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int len;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if ((config_params->alaw.enable) ||
+		    (config_params->data_sz == CCDC_DATA_8BITS))
+			len = ccdc_hw_params_raw.win.width;
+		else
+			len = ccdc_hw_params_raw.win.width * 2;
+	} else
+		len = ccdc_hw_params_ycbcr.win.width * 2;
+	return ALIGN(len, 32);
+}
+
+static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.frm_fmt = frm_fmt;
+	else
+		ccdc_hw_params_ycbcr.frm_fmt = frm_fmt;
+	return 0;
+}
+
+static enum ccdc_frmfmt ccdc_get_frame_format(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		return ccdc_hw_params_raw.frm_fmt;
+	else
+		return ccdc_hw_params_ycbcr.frm_fmt;
+}
+
+static int ccdc_getfid(void)
+{
+	return  (regr(MODESET) >> 15) & 1;
+}
+
+/* misc operations */
+static inline void ccdc_setfbaddr(unsigned long addr)
+{
+	regw((addr >> 21) & 0x007f, STADRH);
+	regw((addr >> 5) & 0x0ffff, STADRL);
+}
+
+static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
+{
+	ccdc_if_type = params->if_type;
+
+	switch (params->if_type) {
+	case VPFE_BT656:
+	case VPFE_YCBCR_SYNC_16:
+	case VPFE_YCBCR_SYNC_8:
+		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
+		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
+		break;
+	default:
+		/* TODO add support for raw bayer here */
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct ccdc_hw_device ccdc_hw_dev = {
+	.name = "DM355 CCDC",
+	.owner = THIS_MODULE,
+	.hw_ops = {
+		.open = ccdc_open,
+		.close = ccdc_close,
+		.set_ccdc_base = ccdc_set_ccdc_base,
+		.enable = ccdc_enable,
+		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
+		.set_hw_if_params = ccdc_set_hw_if_params,
+		.set_params = ccdc_set_params,
+		.configure = ccdc_configure,
+		.set_buftype = ccdc_set_buftype,
+		.get_buftype = ccdc_get_buftype,
+		.enum_pix = ccdc_enum_pix,
+		.set_pixel_format = ccdc_set_pixel_format,
+		.get_pixel_format = ccdc_get_pixel_format,
+		.set_frame_format = ccdc_set_frame_format,
+		.get_frame_format = ccdc_get_frame_format,
+		.set_image_window = ccdc_set_image_window,
+		.get_image_window = ccdc_get_image_window,
+		.get_line_length = ccdc_get_line_length,
+		.queryctrl = ccdc_queryctrl,
+		.set_control = ccdc_set_control,
+		.get_control = ccdc_get_control,
+		.setfbaddr = ccdc_setfbaddr,
+		.getfid = ccdc_getfid,
+	},
+};
+
+static int dm355_ccdc_init(void)
+{
+	printk(KERN_NOTICE "dm355_ccdc_init\n");
+	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
+		return -1;
+	printk(KERN_NOTICE "%s is registered with vpfe.\n",
+		ccdc_hw_dev.name);
+	return 0;
+}
+
+static void dm355_ccdc_exit(void)
+{
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+}
+
+module_init(dm355_ccdc_init);
+module_exit(dm355_ccdc_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/davinci/dm355_ccdc_regs.h b/drivers/media/video/davinci/dm355_ccdc_regs.h
new file mode 100644
index 0000000..d6d2ef0
--- /dev/null
+++ b/drivers/media/video/davinci/dm355_ccdc_regs.h
@@ -0,0 +1,310 @@
+/*
+ * Copyright (C) 2005-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _DM355_CCDC_REGS_H
+#define _DM355_CCDC_REGS_H
+
+/**************************************************************************\
+* Register OFFSET Definitions
+\**************************************************************************/
+#define SYNCEN				0x00
+#define MODESET				0x04
+#define HDWIDTH				0x08
+#define VDWIDTH				0x0c
+#define PPLN				0x10
+#define LPFR				0x14
+#define SPH				0x18
+#define NPH				0x1c
+#define SLV0				0x20
+#define SLV1				0x24
+#define NLV				0x28
+#define CULH				0x2c
+#define CULV				0x30
+#define HSIZE				0x34
+#define SDOFST				0x38
+#define STADRH				0x3c
+#define STADRL				0x40
+#define CLAMP				0x44
+#define DCSUB				0x48
+#define COLPTN				0x4c
+#define BLKCMP0				0x50
+#define BLKCMP1				0x54
+#define MEDFILT				0x58
+#define RYEGAIN				0x5c
+#define GRCYGAIN			0x60
+#define GBGGAIN				0x64
+#define BMGGAIN				0x68
+#define OFFSET				0x6c
+#define OUTCLIP				0x70
+#define VDINT0				0x74
+#define VDINT1				0x78
+#define RSV0				0x7c
+#define GAMMAWD				0x80
+#define REC656IF			0x84
+#define CCDCFG				0x88
+#define FMTCFG				0x8c
+#define FMTPLEN				0x90
+#define FMTSPH				0x94
+#define FMTLNH				0x98
+#define FMTSLV				0x9c
+#define FMTLNV				0xa0
+#define FMTRLEN				0xa4
+#define FMTHCNT				0xa8
+#define FMT_ADDR_PTR_B			0xac
+#define FMT_ADDR_PTR(i)			(FMT_ADDR_PTR_B + (i * 4))
+#define FMTPGM_VF0			0xcc
+#define FMTPGM_VF1			0xd0
+#define FMTPGM_AP0			0xd4
+#define FMTPGM_AP1			0xd8
+#define FMTPGM_AP2			0xdc
+#define FMTPGM_AP3                      0xe0
+#define FMTPGM_AP4                      0xe4
+#define FMTPGM_AP5                      0xe8
+#define FMTPGM_AP6                      0xec
+#define FMTPGM_AP7                      0xf0
+#define LSCCFG1                         0xf4
+#define LSCCFG2                         0xf8
+#define LSCH0                           0xfc
+#define LSCV0                           0x100
+#define LSCKH                           0x104
+#define LSCKV                           0x108
+#define LSCMEMCTL                       0x10c
+#define LSCMEMD                         0x110
+#define LSCMEMQ                         0x114
+#define DFCCTL                          0x118
+#define DFCVSAT                         0x11c
+#define DFCMEMCTL                       0x120
+#define DFCMEM0                         0x124
+#define DFCMEM1                         0x128
+#define DFCMEM2                         0x12c
+#define DFCMEM3                         0x130
+#define DFCMEM4                         0x134
+#define CSCCTL                          0x138
+#define CSCM0                           0x13c
+#define CSCM1                           0x140
+#define CSCM2                           0x144
+#define CSCM3                           0x148
+#define CSCM4                           0x14c
+#define CSCM5                           0x150
+#define CSCM6                           0x154
+#define CSCM7                           0x158
+#define DATAOFST			0x15c
+#define CCDC_REG_LAST			DATAOFST
+/**************************************************************
+*	Define for various register bit mask and shifts for CCDC
+*
+**************************************************************/
+#define CCDC_RAW_IP_MODE			0
+#define CCDC_VDHDOUT_INPUT			0
+#define CCDC_YCINSWP_RAW			(0 << 4)
+#define CCDC_EXWEN_DISABLE 			0
+#define CCDC_DATAPOL_NORMAL			0
+#define CCDC_CCDCFG_FIDMD_LATCH_VSYNC		0
+#define CCDC_CCDCFG_FIDMD_NO_LATCH_VSYNC	(1 << 6)
+#define CCDC_CCDCFG_WENLOG_AND			0
+#define CCDC_CCDCFG_TRGSEL_WEN			0
+#define CCDC_CCDCFG_EXTRG_DISABLE		0
+#define CCDC_CFA_MOSAIC				0
+#define CCDC_Y8POS_SHIFT			11
+
+#define CCDC_VDC_DFCVSAT_MASK			0x3fff
+#define CCDC_DATAOFST_MASK			0x0ff
+#define CCDC_DATAOFST_H_SHIFT			0
+#define CCDC_DATAOFST_V_SHIFT			8
+#define CCDC_GAMMAWD_CFA_MASK			1
+#define CCDC_GAMMAWD_CFA_SHIFT			5
+#define CCDC_GAMMAWD_INPUT_SHIFT		2
+#define CCDC_FID_POL_MASK			1
+#define CCDC_FID_POL_SHIFT			4
+#define CCDC_HD_POL_MASK			1
+#define CCDC_HD_POL_SHIFT			3
+#define CCDC_VD_POL_MASK			1
+#define CCDC_VD_POL_SHIFT			2
+#define CCDC_VD_POL_NEGATIVE			(1 << 2)
+#define CCDC_FRM_FMT_MASK			1
+#define CCDC_FRM_FMT_SHIFT			7
+#define CCDC_DATA_SZ_MASK			7
+#define CCDC_DATA_SZ_SHIFT			8
+#define CCDC_VDHDOUT_MASK			1
+#define CCDC_VDHDOUT_SHIFT			0
+#define CCDC_EXWEN_MASK				1
+#define CCDC_EXWEN_SHIFT			5
+#define CCDC_INPUT_MODE_MASK			3
+#define CCDC_INPUT_MODE_SHIFT			12
+#define CCDC_PIX_FMT_MASK			3
+#define CCDC_PIX_FMT_SHIFT			12
+#define CCDC_DATAPOL_MASK			1
+#define CCDC_DATAPOL_SHIFT			6
+#define CCDC_WEN_ENABLE				(1 << 1)
+#define CCDC_VDHDEN_ENABLE			(1 << 16)
+#define CCDC_LPF_ENABLE				(1 << 14)
+#define CCDC_ALAW_ENABLE			1
+#define CCDC_ALAW_GAMA_WD_MASK			7
+#define CCDC_REC656IF_BT656_EN			3
+
+#define CCDC_FMTCFG_FMTMODE_MASK 		3
+#define CCDC_FMTCFG_FMTMODE_SHIFT		1
+#define CCDC_FMTCFG_LNUM_MASK			3
+#define CCDC_FMTCFG_LNUM_SHIFT			4
+#define CCDC_FMTCFG_ADDRINC_MASK		7
+#define CCDC_FMTCFG_ADDRINC_SHIFT		8
+
+#define CCDC_CCDCFG_FIDMD_SHIFT			6
+#define	CCDC_CCDCFG_WENLOG_SHIFT		8
+#define CCDC_CCDCFG_TRGSEL_SHIFT		9
+#define CCDC_CCDCFG_EXTRG_SHIFT			10
+#define CCDC_CCDCFG_MSBINVI_SHIFT		13
+
+#define CCDC_HSIZE_FLIP_SHIFT			12
+#define CCDC_HSIZE_FLIP_MASK			1
+#define CCDC_HSIZE_VAL_MASK			0xFFF
+#define CCDC_SDOFST_FIELD_INTERLEAVED		0x249
+#define CCDC_SDOFST_INTERLACE_INVERSE		0x4B6D
+#define CCDC_SDOFST_INTERLACE_NORMAL		0x0B6D
+#define CCDC_SDOFST_PROGRESSIVE_INVERSE		0x4000
+#define CCDC_SDOFST_PROGRESSIVE_NORMAL		0
+#define CCDC_START_PX_HOR_MASK			0x7FFF
+#define CCDC_NUM_PX_HOR_MASK			0x7FFF
+#define CCDC_START_VER_ONE_MASK			0x7FFF
+#define CCDC_START_VER_TWO_MASK			0x7FFF
+#define CCDC_NUM_LINES_VER			0x7FFF
+
+#define CCDC_BLK_CLAMP_ENABLE			(1 << 15)
+#define CCDC_BLK_SGAIN_MASK			0x1F
+#define CCDC_BLK_ST_PXL_MASK			0x1FFF
+#define CCDC_BLK_SAMPLE_LN_MASK			3
+#define CCDC_BLK_SAMPLE_LN_SHIFT		13
+
+#define CCDC_NUM_LINE_CALC_MASK			3
+#define CCDC_NUM_LINE_CALC_SHIFT		14
+
+#define CCDC_BLK_DC_SUB_MASK			0x3FFF
+#define CCDC_BLK_COMP_MASK			0xFF
+#define CCDC_BLK_COMP_GB_COMP_SHIFT		8
+#define CCDC_BLK_COMP_GR_COMP_SHIFT		0
+#define CCDC_BLK_COMP_R_COMP_SHIFT		8
+#define CCDC_LATCH_ON_VSYNC_DISABLE		(1 << 15)
+#define CCDC_LATCH_ON_VSYNC_ENABLE		(0 << 15)
+#define CCDC_FPC_ENABLE				(1 << 15)
+#define CCDC_FPC_FPC_NUM_MASK 			0x7FFF
+#define CCDC_DATA_PACK_ENABLE			(1 << 11)
+#define CCDC_FMT_HORZ_FMTLNH_MASK		0x1FFF
+#define CCDC_FMT_HORZ_FMTSPH_MASK		0x1FFF
+#define CCDC_FMT_HORZ_FMTSPH_SHIFT		16
+#define CCDC_FMT_VERT_FMTLNV_MASK		0x1FFF
+#define CCDC_FMT_VERT_FMTSLV_MASK		0x1FFF
+#define CCDC_FMT_VERT_FMTSLV_SHIFT		16
+#define CCDC_VP_OUT_VERT_NUM_MASK		0x3FFF
+#define CCDC_VP_OUT_VERT_NUM_SHIFT		17
+#define CCDC_VP_OUT_HORZ_NUM_MASK		0x1FFF
+#define CCDC_VP_OUT_HORZ_NUM_SHIFT		4
+#define CCDC_VP_OUT_HORZ_ST_MASK		0xF
+
+#define CCDC_CSC_COEF_INTEG_MASK		7
+#define CCDC_CSC_COEF_DECIMAL_MASK		0x1f
+#define CCDC_CSC_COEF_INTEG_SHIFT		5
+#define CCDC_CSCM_MSB_SHIFT			8
+#define CCDC_CSC_ENABLE				1
+#define CCDC_CSC_DEC_MAX			32
+
+#define CCDC_MFILT1_SHIFT			10
+#define CCDC_MFILT2_SHIFT			8
+#define CCDC_MED_FILT_THRESH			0x3FFF
+#define CCDC_LPF_MASK				1
+#define CCDC_LPF_SHIFT				14
+#define CCDC_OFFSET_MASK			0x3FF
+#define CCDC_DATASFT_MASK			7
+#define CCDC_DATASFT_SHIFT			8
+
+#define CCDC_DF_ENABLE				1
+
+#define CCDC_FMTPLEN_P0_MASK			0xF
+#define CCDC_FMTPLEN_P1_MASK			0xF
+#define CCDC_FMTPLEN_P2_MASK			7
+#define CCDC_FMTPLEN_P3_MASK			7
+#define CCDC_FMTPLEN_P0_SHIFT			0
+#define CCDC_FMTPLEN_P1_SHIFT			4
+#define CCDC_FMTPLEN_P2_SHIFT			8
+#define CCDC_FMTPLEN_P3_SHIFT			12
+
+#define CCDC_FMTSPH_MASK			0x1FFF
+#define CCDC_FMTLNH_MASK			0x1FFF
+#define CCDC_FMTSLV_MASK			0x1FFF
+#define CCDC_FMTLNV_MASK			0x7FFF
+#define CCDC_FMTRLEN_MASK			0x1FFF
+#define CCDC_FMTHCNT_MASK			0x1FFF
+
+#define CCDC_ADP_INIT_MASK			0x1FFF
+#define CCDC_ADP_LINE_SHIFT			13
+#define CCDC_ADP_LINE_MASK			3
+#define CCDC_FMTPGN_APTR_MASK			7
+
+#define CCDC_DFCCTL_GDFCEN_MASK			1
+#define CCDC_DFCCTL_VDFCEN_MASK			1
+#define CCDC_DFCCTL_VDFC_DISABLE		(0 << 4)
+#define CCDC_DFCCTL_VDFCEN_SHIFT		4
+#define CCDC_DFCCTL_VDFCSL_MASK			3
+#define CCDC_DFCCTL_VDFCSL_SHIFT		5
+#define CCDC_DFCCTL_VDFCUDA_MASK		1
+#define CCDC_DFCCTL_VDFCUDA_SHIFT		7
+#define CCDC_DFCCTL_VDFLSFT_MASK		3
+#define CCDC_DFCCTL_VDFLSFT_SHIFT		8
+#define CCDC_DFCMEMCTL_DFCMARST_MASK		1
+#define CCDC_DFCMEMCTL_DFCMARST_SHIFT		2
+#define CCDC_DFCMEMCTL_DFCMWR_MASK		1
+#define CCDC_DFCMEMCTL_DFCMWR_SHIFT		0
+#define CCDC_DFCMEMCTL_INC_ADDR			(0 << 2)
+
+#define CCDC_LSCCFG_GFTSF_MASK			7
+#define CCDC_LSCCFG_GFTSF_SHIFT			1
+#define CCDC_LSCCFG_GFTINV_MASK			0xf
+#define CCDC_LSCCFG_GFTINV_SHIFT		4
+#define CCDC_LSC_GFTABLE_SEL_MASK		3
+#define CCDC_LSC_GFTABLE_EPEL_SHIFT		8
+#define CCDC_LSC_GFTABLE_OPEL_SHIFT		10
+#define CCDC_LSC_GFTABLE_EPOL_SHIFT		12
+#define CCDC_LSC_GFTABLE_OPOL_SHIFT		14
+#define CCDC_LSC_GFMODE_MASK			3
+#define CCDC_LSC_GFMODE_SHIFT			4
+#define CCDC_LSC_DISABLE			0
+#define CCDC_LSC_ENABLE				1
+#define CCDC_LSC_TABLE1_SLC			0
+#define CCDC_LSC_TABLE2_SLC			1
+#define CCDC_LSC_TABLE3_SLC			2
+#define CCDC_LSC_MEMADDR_RESET			(1 << 2)
+#define CCDC_LSC_MEMADDR_INCR			(0 << 2)
+#define CCDC_LSC_FRAC_MASK_T1			0xFF
+#define CCDC_LSC_INT_MASK			3
+#define CCDC_LSC_FRAC_MASK			0x3FFF
+#define CCDC_LSC_CENTRE_MASK			0x3FFF
+#define CCDC_LSC_COEF_MASK			0xff
+#define CCDC_LSC_COEFL_SHIFT			0
+#define CCDC_LSC_COEFU_SHIFT			8
+#define CCDC_GAIN_MASK				0x7FF
+#define CCDC_SYNCEN_VDHDEN_MASK			(1 << 0)
+#define CCDC_SYNCEN_WEN_MASK			(1 << 1)
+#define CCDC_SYNCEN_WEN_SHIFT			1
+
+/* Power on Defaults in hardware */
+#define MODESET_DEFAULT				0x200
+#define CULH_DEFAULT				0xFFFF
+#define CULV_DEFAULT				0xFF
+#define GAIN_DEFAULT				256
+#define OUTCLIP_DEFAULT				0x3FFF
+#define LSCCFG2_DEFAULT				0xE
+
+#endif
diff --git a/include/media/davinci/dm355_ccdc.h b/include/media/davinci/dm355_ccdc.h
new file mode 100644
index 0000000..b0ce1af
--- /dev/null
+++ b/include/media/davinci/dm355_ccdc.h
@@ -0,0 +1,336 @@
+/*
+ * Copyright (C) 2005-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _DM355_CCDC_H
+#define _DM355_CCDC_H
+#include <media/davinci/ccdc_types.h>
+#include <media/davinci/vpfe_types.h>
+
+/* enum for No of pixel per line to be avg. in Black Clamping */
+enum ccdc_sample_length {
+	CCDC_SAMPLE_1PIXELS,
+	CCDC_SAMPLE_2PIXELS,
+	CCDC_SAMPLE_4PIXELS,
+	CCDC_SAMPLE_8PIXELS,
+	CCDC_SAMPLE_16PIXELS
+};
+
+/* enum for No of lines in Black Clamping */
+enum ccdc_sample_line {
+	CCDC_SAMPLE_1LINES,
+	CCDC_SAMPLE_2LINES,
+	CCDC_SAMPLE_4LINES,
+	CCDC_SAMPLE_8LINES,
+	CCDC_SAMPLE_16LINES
+};
+
+/* enum for Alaw gama width */
+enum ccdc_gamma_width {
+	CCDC_GAMMA_BITS_13_4,
+	CCDC_GAMMA_BITS_12_3,
+	CCDC_GAMMA_BITS_11_2,
+	CCDC_GAMMA_BITS_10_1,
+	CCDC_GAMMA_BITS_09_0
+};
+
+enum ccdc_colpats {
+	CCDC_RED,
+	CCDC_GREEN_RED,
+	CCDC_GREEN_BLUE,
+	CCDC_BLUE
+};
+
+struct ccdc_col_pat {
+	enum ccdc_colpats olop;
+	enum ccdc_colpats olep;
+	enum ccdc_colpats elop;
+	enum ccdc_colpats elep;
+};
+
+enum ccdc_datasft {
+	CCDC_DATA_NO_SHIFT,
+	CCDC_DATA_SHIFT_1BIT,
+	CCDC_DATA_SHIFT_2BIT,
+	CCDC_DATA_SHIFT_3BIT,
+	CCDC_DATA_SHIFT_4BIT,
+	CCDC_DATA_SHIFT_5BIT,
+	CCDC_DATA_SHIFT_6BIT
+};
+
+enum ccdc_data_size {
+	CCDC_DATA_16BITS,
+	CCDC_DATA_15BITS,
+	CCDC_DATA_14BITS,
+	CCDC_DATA_13BITS,
+	CCDC_DATA_12BITS,
+	CCDC_DATA_11BITS,
+	CCDC_DATA_10BITS,
+	CCDC_DATA_8BITS
+};
+enum ccdc_mfilt1 {
+	CCDC_NO_MEDIAN_FILTER1,
+	CCDC_AVERAGE_FILTER1,
+	CCDC_MEDIAN_FILTER1
+};
+
+enum ccdc_mfilt2 {
+	CCDC_NO_MEDIAN_FILTER2,
+	CCDC_AVERAGE_FILTER2,
+	CCDC_MEDIAN_FILTER2
+};
+
+/* structure for ALaw */
+struct ccdc_a_law {
+	/* Enable/disable A-Law */
+	unsigned char enable;
+	/* Gama Width Input */
+	enum ccdc_gamma_width gama_wd;
+};
+
+/* structure for Black Clamping */
+struct ccdc_black_clamp {
+	/* only if bClampEnable is TRUE */
+	unsigned char b_clamp_enable;
+	/* only if bClampEnable is TRUE */
+	enum ccdc_sample_length sample_pixel;
+	/* only if bClampEnable is TRUE */
+	enum ccdc_sample_line sample_ln;
+	/* only if bClampEnable is TRUE */
+	unsigned short start_pixel;
+	/* only if bClampEnable is FALSE */
+	unsigned short sgain;
+	unsigned short dc_sub;
+};
+
+/* structure for Black Level Compensation */
+struct ccdc_black_compensation {
+	/* Constant value to subtract from Red component */
+	unsigned char r;
+	/* Constant value to subtract from Gr component */
+	unsigned char gr;
+	/* Constant value to subtract from Blue component */
+	unsigned char b;
+	/* Constant value to subtract from Gb component */
+	unsigned char gb;
+};
+
+struct ccdc_float {
+	int integer;
+	unsigned int decimal;
+};
+
+#define CCDC_CSC_COEFF_TABLE_SIZE	16
+/* structure for color space converter */
+struct ccdc_csc {
+	unsigned char enable;
+	/*
+	 * S8Q5. Use 2 decimal precision, user values range from -3.00 to 3.99.
+	 * example - to use 1.03, set integer part as 1, and decimal part as 3
+	 * to use -1.03, set integer part as -1 and decimal part as 3
+	 */
+	struct ccdc_float coeff[CCDC_CSC_COEFF_TABLE_SIZE];
+};
+
+/* Structures for Vertical Defect Correction*/
+enum ccdc_vdf_csl {
+	CCDC_VDF_NORMAL,
+	CCDC_VDF_HORZ_INTERPOL_SAT,
+	CCDC_VDF_HORZ_INTERPOL
+};
+
+enum ccdc_vdf_cuda {
+	CCDC_VDF_WHOLE_LINE_CORRECT,
+	CCDC_VDF_UPPER_DISABLE
+};
+
+enum ccdc_dfc_mwr {
+	CCDC_DFC_MWR_WRITE_COMPLETE,
+	CCDC_DFC_WRITE_REG
+};
+
+enum ccdc_dfc_mrd {
+	CCDC_DFC_READ_COMPLETE,
+	CCDC_DFC_READ_REG
+};
+
+enum ccdc_dfc_ma_rst {
+	CCDC_DFC_INCR_ADDR,
+	CCDC_DFC_CLR_ADDR
+};
+
+enum ccdc_dfc_mclr {
+	CCDC_DFC_CLEAR_COMPLETE,
+	CCDC_DFC_CLEAR
+};
+
+struct ccdc_dft_corr_ctl {
+	enum ccdc_vdf_csl vdfcsl;
+	enum ccdc_vdf_cuda vdfcuda;
+	unsigned int vdflsft;
+};
+
+struct ccdc_dft_corr_mem_ctl {
+	enum ccdc_dfc_mwr dfcmwr;
+	enum ccdc_dfc_mrd dfcmrd;
+	enum ccdc_dfc_ma_rst dfcmarst;
+	enum ccdc_dfc_mclr dfcmclr;
+};
+
+#define CCDC_DFT_TABLE_SIZE	16
+/*
+ * Main Structure for vertical defect correction. Vertical defect
+ * correction can correct upto 16 defects if defects less than 16
+ * then pad the rest with 0
+ */
+struct ccdc_vertical_dft {
+	unsigned char ver_dft_en;
+	unsigned char gen_dft_en;
+	unsigned int saturation_ctl;
+	struct ccdc_dft_corr_ctl dft_corr_ctl;
+	struct ccdc_dft_corr_mem_ctl dft_corr_mem_ctl;
+	int table_size;
+	unsigned int dft_corr_horz[CCDC_DFT_TABLE_SIZE];
+	unsigned int dft_corr_vert[CCDC_DFT_TABLE_SIZE];
+	unsigned int dft_corr_sub1[CCDC_DFT_TABLE_SIZE];
+	unsigned int dft_corr_sub2[CCDC_DFT_TABLE_SIZE];
+	unsigned int dft_corr_sub3[CCDC_DFT_TABLE_SIZE];
+};
+
+struct ccdc_data_offset {
+	unsigned char horz_offset;
+	unsigned char vert_offset;
+};
+
+/*
+ * Structure for CCDC configuration parameters for raw capture mode passed
+ * by application
+ */
+struct ccdc_config_params_raw {
+	/* data shift to be applied before storing */
+	enum ccdc_datasft datasft;
+	/* data size value from 8 to 16 bits */
+	enum ccdc_data_size data_sz;
+	/* median filter for sdram */
+	enum ccdc_mfilt1 mfilt1;
+	enum ccdc_mfilt2 mfilt2;
+	/* low pass filter enable/disable */
+	unsigned char lpf_enable;
+	/* Threshold of median filter */
+	int med_filt_thres;
+	/*
+	 * horz and vertical data offset. Appliable for defect correction
+	 * and lsc
+	 */
+	struct ccdc_data_offset data_offset;
+	/* Structure for Optional A-Law */
+	struct ccdc_a_law alaw;
+	/* Structure for Optical Black Clamp */
+	struct ccdc_black_clamp blk_clamp;
+	/* Structure for Black Compensation */
+	struct ccdc_black_compensation blk_comp;
+	/* struture for vertical Defect Correction Module Configuration */
+	struct ccdc_vertical_dft vertical_dft;
+	/* structure for color space converter Module Configuration */
+	struct ccdc_csc csc;
+	/* color patters for bayer capture */
+	struct ccdc_col_pat col_pat_field0;
+	struct ccdc_col_pat col_pat_field1;
+};
+
+#ifdef __KERNEL__
+#include <linux/io.h>
+
+#define CCDC_WIN_PAL	{0, 0, 720, 576}
+#define CCDC_WIN_VGA	{0, 0, 640, 480}
+
+/*
+ * CCDC specific controls for Bayer capture. The CIDs
+ * listed here should match with that in davinci_vpfe.h
+ */
+
+/* White balance on Bayer RGB. U11Q8 */
+#define CCDC_CID_R_GAIN		(V4L2_CID_PRIVATE_BASE + 0)
+#define CCDC_CID_GR_GAIN	(V4L2_CID_PRIVATE_BASE + 1)
+#define CCDC_CID_GB_GAIN 	(V4L2_CID_PRIVATE_BASE + 2)
+#define CCDC_CID_B_GAIN 	(V4L2_CID_PRIVATE_BASE + 3)
+/* Offsets */
+#define CCDC_CID_OFFSET 	(V4L2_CID_PRIVATE_BASE + 4)
+#define CCDC_CID_MAX		(V4L2_CID_PRIVATE_BASE + 5)
+#define CCDC_MAX_CONTROLS 5
+
+struct ccdc_params_ycbcr {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct v4l2_rect win;
+	/* field id polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* vertical sync polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* horizontal sync polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* enable BT.656 embedded sync mode */
+	int bt656_enable;
+	/* cb:y:cr:y or y:cb:y:cr in memory */
+	enum ccdc_pixorder pix_order;
+	/* interleaved or separated fields  */
+	enum ccdc_buftype buf_type;
+};
+
+/* Gain applied to Raw Bayer data */
+struct ccdc_gain {
+	unsigned short r_ye;
+	unsigned short gr_cy;
+	unsigned short gb_g;
+	unsigned short b_mg;
+};
+
+/* Structure for CCDC configuration parameters for raw capture mode */
+struct ccdc_params_raw {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct v4l2_rect win;
+	/* field id polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* vertical sync polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* horizontal sync polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* interleaved or separated fields */
+	enum ccdc_buftype buf_type;
+	/* Gain values */
+	struct ccdc_gain gain;
+	/* offset */
+	unsigned int ccdc_offset;
+	/* horizontal flip enable */
+	unsigned char horz_flip_enable;
+	/*
+	 * enable to store the image in inverse order in memory
+	 * (bottom to top)
+	 */
+	unsigned char image_invert_enable;
+	/* Configurable part of raw data */
+	struct ccdc_config_params_raw config_params;
+};
+
+#endif
+#endif				/* DM355_CCDC_H */
-- 
1.6.0.4

