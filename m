Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C954DC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 19:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F95120811
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 19:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfBGTJS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:09:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:56686 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfBGTJR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 14:09:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 11:09:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,345,1544515200"; 
   d="scan'208";a="114484754"
Received: from pflykt-mobl3.ger.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.252.130.145])
  by orsmga006.jf.intel.com with ESMTP; 07 Feb 2019 11:09:11 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] media: ipu3-imgu: Prefix functions with imgu_* instead of ipu3_*
Date:   Thu,  7 Feb 2019 13:08:55 -0600
Message-Id: <1549566535-5880-1-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This addresses the below TODO item, no function related changes:

- Prefix imgu for all public APIs, i.e. change ipu3_v4l2_register() to
  imgu_v4l2_register(). (Sakari)

The changes were obtained by applying the following perl script
to driver code under drivers/staging/media/ipu3/.

perl -pi.back -e 's/ipu3_(?!uapi)/imgu_/g;'

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/staging/media/ipu3/TODO              |   3 -
 drivers/staging/media/ipu3/ipu3-css-fw.c     |  18 +-
 drivers/staging/media/ipu3/ipu3-css-fw.h     |   8 +-
 drivers/staging/media/ipu3/ipu3-css-params.c | 270 ++++++++--------
 drivers/staging/media/ipu3/ipu3-css-params.h |   8 +-
 drivers/staging/media/ipu3/ipu3-css-pool.c   |  32 +-
 drivers/staging/media/ipu3/ipu3-css-pool.h   |  30 +-
 drivers/staging/media/ipu3/ipu3-css.c        | 454 +++++++++++++--------------
 drivers/staging/media/ipu3/ipu3-css.h        |  92 +++---
 drivers/staging/media/ipu3/ipu3-dmamap.c     |  42 +--
 drivers/staging/media/ipu3/ipu3-dmamap.h     |  14 +-
 drivers/staging/media/ipu3/ipu3-mmu.c        | 120 +++----
 drivers/staging/media/ipu3/ipu3-mmu.h        |  18 +-
 drivers/staging/media/ipu3/ipu3-tables.c     |  50 +--
 drivers/staging/media/ipu3/ipu3-tables.h     |  54 ++--
 drivers/staging/media/ipu3/ipu3-v4l2.c       | 290 ++++++++---------
 drivers/staging/media/ipu3/ipu3.c            |  86 ++---
 drivers/staging/media/ipu3/ipu3.h            |  18 +-
 18 files changed, 802 insertions(+), 805 deletions(-)

diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 0dc9a2e79978..8b95e74e43a0 100644
--- a/drivers/staging/media/ipu3/TODO
+++ b/drivers/staging/media/ipu3/TODO
@@ -8,9 +8,6 @@ staging directory.
 - Using ENABLED and IMMUTABLE link flags for the links where those are
   relevant. (Sakari)
 
-- Prefix imgu for all public APIs, i.e. change ipu3_v4l2_register() to
-  imgu_v4l2_register(). (Sakari)
-
 - IPU3 driver documentation (Laurent)
   Add diagram in driver rst to describe output capability.
   Comments on configuring v4l2 subdevs for CIO2 and ImgU.
diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.c b/drivers/staging/media/ipu3/ipu3-css-fw.c
index 55861aa8fb03..4122d4e42db6 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.c
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.c
@@ -10,7 +10,7 @@
 #include "ipu3-css-fw.h"
 #include "ipu3-dmamap.h"
 
-static void ipu3_css_fw_show_binary(struct device *dev, struct imgu_fw_info *bi,
+static void imgu_css_fw_show_binary(struct device *dev, struct imgu_fw_info *bi,
 				    const char *name)
 {
 	unsigned int i;
@@ -54,7 +54,7 @@ static void ipu3_css_fw_show_binary(struct device *dev, struct imgu_fw_info *bi,
 	dev_dbg(dev, "\n");
 }
 
-unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi)
+unsigned int imgu_css_fw_obgrid_size(const struct imgu_fw_info *bi)
 {
 	unsigned int width = DIV_ROUND_UP(bi->info.isp.sp.internal.max_width,
 					  IMGU_OBGRID_TILE_SIZE * 2) + 1;
@@ -69,7 +69,7 @@ unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi)
 	return obgrid_size;
 }
 
-void *ipu3_css_fw_pipeline_params(struct ipu3_css *css, unsigned int pipe,
+void *imgu_css_fw_pipeline_params(struct imgu_css *css, unsigned int pipe,
 				  enum imgu_abi_param_class cls,
 				  enum imgu_abi_memories mem,
 				  struct imgu_fw_isp_parameter *par,
@@ -91,7 +91,7 @@ void *ipu3_css_fw_pipeline_params(struct ipu3_css *css, unsigned int pipe,
 	return binary_params + par->offset;
 }
 
-void ipu3_css_fw_cleanup(struct ipu3_css *css)
+void imgu_css_fw_cleanup(struct imgu_css *css)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 
@@ -99,7 +99,7 @@ void ipu3_css_fw_cleanup(struct ipu3_css *css)
 		unsigned int i;
 
 		for (i = 0; i < css->fwp->file_header.binary_nr; i++)
-			ipu3_dmamap_free(imgu, &css->binary[i]);
+			imgu_dmamap_free(imgu, &css->binary[i]);
 		kfree(css->binary);
 	}
 	if (css->fw)
@@ -109,7 +109,7 @@ void ipu3_css_fw_cleanup(struct ipu3_css *css)
 	css->fw = NULL;
 }
 
-int ipu3_css_fw_init(struct ipu3_css *css)
+int imgu_css_fw_init(struct imgu_css *css)
 {
 	static const u32 BLOCK_MAX = 65536;
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
@@ -227,7 +227,7 @@ int ipu3_css_fw_init(struct ipu3_css *css)
 		    css->fw->size)
 			goto bad_fw;
 
-		ipu3_css_fw_show_binary(dev, bi, name);
+		imgu_css_fw_show_binary(dev, bi, name);
 	}
 
 	if (css->fw_bl == -1 || css->fw_sp[0] == -1 || css->fw_sp[1] == -1)
@@ -246,7 +246,7 @@ int ipu3_css_fw_init(struct ipu3_css *css)
 		void *blob = (void *)css->fwp + bi->blob.offset;
 		size_t size = bi->blob.size;
 
-		if (!ipu3_dmamap_alloc(imgu, &css->binary[i], size)) {
+		if (!imgu_dmamap_alloc(imgu, &css->binary[i], size)) {
 			r = -ENOMEM;
 			goto error_out;
 		}
@@ -260,6 +260,6 @@ int ipu3_css_fw_init(struct ipu3_css *css)
 	r = -ENODEV;
 
 error_out:
-	ipu3_css_fw_cleanup(css);
+	imgu_css_fw_cleanup(css);
 	return r;
 }
diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.h b/drivers/staging/media/ipu3/ipu3-css-fw.h
index 07d8bb8b25f3..79ffa7045139 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.h
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.h
@@ -175,11 +175,11 @@ struct imgu_fw_header {
 
 /******************* Firmware functions *******************/
 
-int ipu3_css_fw_init(struct ipu3_css *css);
-void ipu3_css_fw_cleanup(struct ipu3_css *css);
+int imgu_css_fw_init(struct imgu_css *css);
+void imgu_css_fw_cleanup(struct imgu_css *css);
 
-unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi);
-void *ipu3_css_fw_pipeline_params(struct ipu3_css *css, unsigned int pipe,
+unsigned int imgu_css_fw_obgrid_size(const struct imgu_fw_info *bi);
+void *imgu_css_fw_pipeline_params(struct imgu_css *css, unsigned int pipe,
 				  enum imgu_abi_param_class cls,
 				  enum imgu_abi_memories mem,
 				  struct imgu_fw_isp_parameter *par,
diff --git a/drivers/staging/media/ipu3/ipu3-css-params.c b/drivers/staging/media/ipu3/ipu3-css-params.c
index 053edce54b71..4533dacad4be 100644
--- a/drivers/staging/media/ipu3/ipu3-css-params.c
+++ b/drivers/staging/media/ipu3/ipu3-css-params.c
@@ -14,7 +14,7 @@
 #define IPU3_UAPI_ANR_MAX_RESET		((1 << 12) - 1)
 #define IPU3_UAPI_ANR_MIN_RESET		(((-1) << 12) + 1)
 
-struct ipu3_css_scaler_info {
+struct imgu_css_scaler_info {
 	unsigned int phase_step;	/* Same for luma/chroma */
 	int exp_shift;
 
@@ -25,7 +25,7 @@ struct ipu3_css_scaler_info {
 	int crop_top;
 };
 
-static unsigned int ipu3_css_scaler_get_exp(unsigned int counter,
+static unsigned int imgu_css_scaler_get_exp(unsigned int counter,
 					    unsigned int divider)
 {
 	int i = fls(divider) - fls(counter);
@@ -41,13 +41,13 @@ static unsigned int ipu3_css_scaler_get_exp(unsigned int counter,
 
 /* Set up the CSS scaler look up table */
 static void
-ipu3_css_scaler_setup_lut(unsigned int taps, unsigned int input_width,
+imgu_css_scaler_setup_lut(unsigned int taps, unsigned int input_width,
 			  unsigned int output_width, int phase_step_correction,
 			  const int *coeffs, unsigned int coeffs_size,
-			  s8 coeff_lut[], struct ipu3_css_scaler_info *info)
+			  s8 coeff_lut[], struct imgu_css_scaler_info *info)
 {
 	int tap, phase, phase_sum_left, phase_sum_right;
-	int exponent = ipu3_css_scaler_get_exp(output_width, input_width);
+	int exponent = imgu_css_scaler_get_exp(output_width, input_width);
 	int mantissa = (1 << exponent) * output_width;
 	unsigned int phase_step;
 
@@ -114,8 +114,8 @@ ipu3_css_scaler_setup_lut(unsigned int taps, unsigned int input_width,
  * (must be perfectly aligned with hardware).
  */
 static unsigned int
-ipu3_css_scaler_calc_scaled_output(unsigned int input,
-				   struct ipu3_css_scaler_info *info)
+imgu_css_scaler_calc_scaled_output(unsigned int input,
+				   struct imgu_css_scaler_info *info)
 {
 	unsigned int arg1 = input * info->phase_step +
 			(1 - IMGU_SCALER_TAPS_Y / 2) * IMGU_SCALER_FIR_PHASES -
@@ -133,10 +133,10 @@ ipu3_css_scaler_calc_scaled_output(unsigned int input,
  * and chroma details of a scaler
  */
 static void
-ipu3_css_scaler_calc(u32 input_width, u32 input_height, u32 target_width,
+imgu_css_scaler_calc(u32 input_width, u32 input_height, u32 target_width,
 		     u32 target_height, struct imgu_abi_osys_config *cfg,
-		     struct ipu3_css_scaler_info *info_luma,
-		     struct ipu3_css_scaler_info *info_chroma,
+		     struct imgu_css_scaler_info *info_luma,
+		     struct imgu_css_scaler_info *info_chroma,
 		     unsigned int *output_width, unsigned int *output_height,
 		     unsigned int *procmode)
 {
@@ -165,24 +165,24 @@ ipu3_css_scaler_calc(u32 input_width, u32 input_height, u32 target_width,
 	do {
 		phase_step_correction++;
 
-		ipu3_css_scaler_setup_lut(IMGU_SCALER_TAPS_Y,
+		imgu_css_scaler_setup_lut(IMGU_SCALER_TAPS_Y,
 					  input_width, target_width,
 					  phase_step_correction,
-					  ipu3_css_downscale_4taps,
+					  imgu_css_downscale_4taps,
 					  IMGU_SCALER_DOWNSCALE_4TAPS_LEN,
 					  cfg->scaler_coeffs_luma, info_luma);
 
-		ipu3_css_scaler_setup_lut(IMGU_SCALER_TAPS_UV,
+		imgu_css_scaler_setup_lut(IMGU_SCALER_TAPS_UV,
 					  input_width, target_width,
 					  phase_step_correction,
-					  ipu3_css_downscale_2taps,
+					  imgu_css_downscale_2taps,
 					  IMGU_SCALER_DOWNSCALE_2TAPS_LEN,
 					  cfg->scaler_coeffs_chroma,
 					  info_chroma);
 
-		out_width = ipu3_css_scaler_calc_scaled_output(input_width,
+		out_width = imgu_css_scaler_calc_scaled_output(input_width,
 							       info_luma);
-		out_height = ipu3_css_scaler_calc_scaled_output(input_height,
+		out_height = imgu_css_scaler_calc_scaled_output(input_height,
 								info_luma);
 	} while ((out_width < target_width || out_height < target_height ||
 		 !IS_ALIGNED(out_height, height_alignment)) &&
@@ -194,7 +194,7 @@ ipu3_css_scaler_calc(u32 input_width, u32 input_height, u32 target_width,
 
 /********************** Osys routines for scaler****************************/
 
-static void ipu3_css_osys_set_format(enum imgu_abi_frame_format host_format,
+static void imgu_css_osys_set_format(enum imgu_abi_frame_format host_format,
 				     unsigned int *osys_format,
 				     unsigned int *osys_tiling)
 {
@@ -231,7 +231,7 @@ static void ipu3_css_osys_set_format(enum imgu_abi_frame_format host_format,
  * Function calculates input frame stripe offset, based
  * on output frame stripe offset and filter parameters.
  */
-static int ipu3_css_osys_calc_stripe_offset(int stripe_offset_out,
+static int imgu_css_osys_calc_stripe_offset(int stripe_offset_out,
 					    int fir_phases, int phase_init,
 					    int phase_step, int pad_left)
 {
@@ -245,12 +245,12 @@ static int ipu3_css_osys_calc_stripe_offset(int stripe_offset_out,
  * Calculate input frame phase, given the output frame
  * stripe offset and filter parameters
  */
-static int ipu3_css_osys_calc_stripe_phase_init(int stripe_offset_out,
+static int imgu_css_osys_calc_stripe_phase_init(int stripe_offset_out,
 						int fir_phases, int phase_init,
 						int phase_step, int pad_left)
 {
 	int stripe_offset_inp =
-		ipu3_css_osys_calc_stripe_offset(stripe_offset_out,
+		imgu_css_osys_calc_stripe_offset(stripe_offset_out,
 						 fir_phases, phase_init,
 						 phase_step, pad_left);
 
@@ -262,7 +262,7 @@ static int ipu3_css_osys_calc_stripe_phase_init(int stripe_offset_out,
  * This function calculates input frame stripe width,
  * based on output frame stripe offset and filter parameters
  */
-static int ipu3_css_osys_calc_inp_stripe_width(int stripe_width_out,
+static int imgu_css_osys_calc_inp_stripe_width(int stripe_width_out,
 					       int fir_phases, int phase_init,
 					       int phase_step, int fir_taps,
 					       int pad_left, int pad_right)
@@ -279,7 +279,7 @@ static int ipu3_css_osys_calc_inp_stripe_width(int stripe_width_out,
  * This function calculates output frame stripe width, basedi
  * on output frame stripe offset and filter parameters
  */
-static int ipu3_css_osys_out_stripe_width(int stripe_width_inp, int fir_phases,
+static int imgu_css_osys_out_stripe_width(int stripe_width_inp, int fir_phases,
 					  int phase_init, int phase_step,
 					  int fir_taps, int pad_left,
 					  int pad_right, int column_offset)
@@ -292,7 +292,7 @@ static int ipu3_css_osys_out_stripe_width(int stripe_width_inp, int fir_phases,
 	return stripe_width_out - (fir_taps - 1);
 }
 
-struct ipu3_css_reso {
+struct imgu_css_reso {
 	unsigned int input_width;
 	unsigned int input_height;
 	enum imgu_abi_frame_format input_format;
@@ -306,7 +306,7 @@ struct ipu3_css_reso {
 	int block_width;
 };
 
-struct ipu3_css_frame_params {
+struct imgu_css_frame_params {
 	/* Output pins */
 	unsigned int enable;
 	unsigned int format;
@@ -322,7 +322,7 @@ struct ipu3_css_frame_params {
 	unsigned int crop_top;
 };
 
-struct ipu3_css_stripe_params {
+struct imgu_css_stripe_params {
 	unsigned int processing_mode;
 	unsigned int phase_step;
 	unsigned int exp_shift;
@@ -359,20 +359,20 @@ struct ipu3_css_stripe_params {
  * frame_params - size IMGU_ABI_OSYS_PINS
  * stripe_params - size IPU3_UAPI_MAX_STRIPES
  */
-static int ipu3_css_osys_calc_frame_and_stripe_params(
-		struct ipu3_css *css, unsigned int stripes,
+static int imgu_css_osys_calc_frame_and_stripe_params(
+		struct imgu_css *css, unsigned int stripes,
 		struct imgu_abi_osys_config *osys,
-		struct ipu3_css_scaler_info *scaler_luma,
-		struct ipu3_css_scaler_info *scaler_chroma,
-		struct ipu3_css_frame_params frame_params[],
-		struct ipu3_css_stripe_params stripe_params[],
+		struct imgu_css_scaler_info *scaler_luma,
+		struct imgu_css_scaler_info *scaler_chroma,
+		struct imgu_css_frame_params frame_params[],
+		struct imgu_css_stripe_params stripe_params[],
 		unsigned int pipe)
 {
-	struct ipu3_css_reso reso;
+	struct imgu_css_reso reso;
 	unsigned int output_width, pin, s;
 	u32 input_width, input_height, target_width, target_height;
 	unsigned int procmode = 0;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	input_width = css_pipe->rect[IPU3_CSS_RECT_GDC].width;
 	input_height = css_pipe->rect[IPU3_CSS_RECT_GDC].height;
@@ -464,7 +464,7 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 					scaled = 1;
 				}
 			}
-			ipu3_css_osys_set_format(reso.pin_format[pin], &format,
+			imgu_css_osys_set_format(reso.pin_format[pin], &format,
 						 &tiling);
 		} else {
 			enable = 0;
@@ -476,7 +476,7 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 		frame_params[pin].scaled = scaled;
 	}
 
-	ipu3_css_scaler_calc(input_width, input_height, target_width,
+	imgu_css_scaler_calc(input_width, input_height, target_width,
 			     target_height, osys, scaler_luma, scaler_chroma,
 			     &reso.pin_width[IMGU_ABI_OSYS_PIN_VF],
 			     &reso.pin_height[IMGU_ABI_OSYS_PIN_VF], &procmode);
@@ -581,14 +581,14 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 				stripe_offset_out_uv = stripe_offset_out_y /
 						IMGU_LUMA_TO_CHROMA_RATIO;
 				stripe_offset_inp_y =
-					ipu3_css_osys_calc_stripe_offset(
+					imgu_css_osys_calc_stripe_offset(
 						stripe_offset_out_y,
 						IMGU_OSYS_FIR_PHASES,
 						scaler_luma->phase_init,
 						scaler_luma->phase_step,
 						scaler_luma->pad_left);
 				stripe_offset_inp_uv =
-					ipu3_css_osys_calc_stripe_offset(
+					imgu_css_osys_calc_stripe_offset(
 						stripe_offset_out_uv,
 						IMGU_OSYS_FIR_PHASES,
 						scaler_chroma->phase_init,
@@ -597,14 +597,14 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 
 				/* Calculate stripe phase init */
 				stripe_phase_init_y =
-					ipu3_css_osys_calc_stripe_phase_init(
+					imgu_css_osys_calc_stripe_phase_init(
 						stripe_offset_out_y,
 						IMGU_OSYS_FIR_PHASES,
 						scaler_luma->phase_init,
 						scaler_luma->phase_step,
 						scaler_luma->pad_left);
 				stripe_phase_init_uv =
-					ipu3_css_osys_calc_stripe_phase_init(
+					imgu_css_osys_calc_stripe_phase_init(
 						stripe_offset_out_uv,
 						IMGU_OSYS_FIR_PHASES,
 						scaler_chroma->phase_init,
@@ -708,7 +708,7 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 						IMGU_LUMA_TO_CHROMA_RATIO;
 			/* Calculate input stripe width */
 			stripe_input_width_y = stripe_offset_col_y +
-				ipu3_css_osys_calc_inp_stripe_width(
+				imgu_css_osys_calc_inp_stripe_width(
 						stripe_output_width_y,
 						IMGU_OSYS_FIR_PHASES,
 						stripe_phase_init_y,
@@ -718,7 +718,7 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 						stripe_pad_right_y);
 
 			stripe_input_width_uv = stripe_offset_col_uv +
-				ipu3_css_osys_calc_inp_stripe_width(
+				imgu_css_osys_calc_inp_stripe_width(
 						stripe_output_width_uv,
 						IMGU_OSYS_FIR_PHASES,
 						stripe_phase_init_uv,
@@ -753,7 +753,7 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 			 */
 			stripe_input_width_y = ALIGN(stripe_input_width_y, 8);
 			stripe_output_width_y =
-				ipu3_css_osys_out_stripe_width(
+				imgu_css_osys_out_stripe_width(
 						stripe_input_width_y,
 						IMGU_OSYS_FIR_PHASES,
 						stripe_phase_init_y,
@@ -847,23 +847,23 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
  * This function configures the Output Formatter System, given the number of
  * stripes, scaler luma and chrome parameters
  */
-static int ipu3_css_osys_calc(struct ipu3_css *css, unsigned int pipe,
+static int imgu_css_osys_calc(struct imgu_css *css, unsigned int pipe,
 			      unsigned int stripes,
 			      struct imgu_abi_osys_config *osys,
-			      struct ipu3_css_scaler_info *scaler_luma,
-			      struct ipu3_css_scaler_info *scaler_chroma,
+			      struct imgu_css_scaler_info *scaler_luma,
+			      struct imgu_css_scaler_info *scaler_chroma,
 			      struct imgu_abi_stripes block_stripes[])
 {
-	struct ipu3_css_frame_params frame_params[IMGU_ABI_OSYS_PINS];
-	struct ipu3_css_stripe_params stripe_params[IPU3_UAPI_MAX_STRIPES];
+	struct imgu_css_frame_params frame_params[IMGU_ABI_OSYS_PINS];
+	struct imgu_css_stripe_params stripe_params[IPU3_UAPI_MAX_STRIPES];
 	struct imgu_abi_osys_formatter_params *param;
 	unsigned int pin, s;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	memset(osys, 0, sizeof(*osys));
 
 	/* Compute the frame and stripe params */
-	if (ipu3_css_osys_calc_frame_and_stripe_params(css, stripes, osys,
+	if (imgu_css_osys_calc_frame_and_stripe_params(css, stripes, osys,
 						       scaler_luma,
 						       scaler_chroma,
 						       frame_params,
@@ -1252,7 +1252,7 @@ static int ipu3_css_osys_calc(struct ipu3_css *css, unsigned int pipe,
  */
 
 static int
-ipu3_css_shd_ops_calc(struct imgu_abi_shd_intra_frame_operations_data *ops,
+imgu_css_shd_ops_calc(struct imgu_abi_shd_intra_frame_operations_data *ops,
 		      const struct ipu3_uapi_shd_grid_config *grid,
 		      unsigned int image_height)
 {
@@ -1496,7 +1496,7 @@ struct process_lines {
 
 /* Helper to config intra_frame_operations_data. */
 static int
-ipu3_css_acc_process_lines(const struct process_lines *pl,
+imgu_css_acc_process_lines(const struct process_lines *pl,
 			   struct imgu_abi_acc_operation *p_op,
 			   struct imgu_abi_acc_process_lines_cmd_data *p_pl,
 			   struct imgu_abi_acc_transfer_op_data *p_tr)
@@ -1633,12 +1633,12 @@ ipu3_css_acc_process_lines(const struct process_lines *pl,
 	return 0;
 }
 
-static int ipu3_css_af_ops_calc(struct ipu3_css *css, unsigned int pipe,
+static int imgu_css_af_ops_calc(struct imgu_css *css, unsigned int pipe,
 				struct imgu_abi_af_config *af_config)
 {
 	struct imgu_abi_af_intra_frame_operations_data *to =
 		&af_config->operations_data;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
 
@@ -1656,17 +1656,17 @@ static int ipu3_css_af_ops_calc(struct ipu3_css *css, unsigned int pipe,
 		.acc_enable = bi->info.isp.sp.enable.af,
 	};
 
-	return ipu3_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
+	return imgu_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
 					  NULL);
 }
 
 static int
-ipu3_css_awb_fr_ops_calc(struct ipu3_css *css, unsigned int pipe,
+imgu_css_awb_fr_ops_calc(struct imgu_css *css, unsigned int pipe,
 			 struct imgu_abi_awb_fr_config *awb_fr_config)
 {
 	struct imgu_abi_awb_fr_intra_frame_operations_data *to =
 		&awb_fr_config->operations_data;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
 	struct process_lines pl = {
@@ -1683,16 +1683,16 @@ ipu3_css_awb_fr_ops_calc(struct ipu3_css *css, unsigned int pipe,
 		.acc_enable = bi->info.isp.sp.enable.awb_fr_acc,
 	};
 
-	return ipu3_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
+	return imgu_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
 					  NULL);
 }
 
-static int ipu3_css_awb_ops_calc(struct ipu3_css *css, unsigned int pipe,
+static int imgu_css_awb_ops_calc(struct imgu_css *css, unsigned int pipe,
 				 struct imgu_abi_awb_config *awb_config)
 {
 	struct imgu_abi_awb_intra_frame_operations_data *to =
 		&awb_config->operations_data;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
 
@@ -1709,33 +1709,33 @@ static int ipu3_css_awb_ops_calc(struct ipu3_css *css, unsigned int pipe,
 		.acc_enable = bi->info.isp.sp.enable.awb_acc,
 	};
 
-	return ipu3_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
+	return imgu_css_acc_process_lines(&pl, to->ops, to->process_lines_data,
 					  to->transfer_data);
 }
 
-static u16 ipu3_css_grid_end(u16 start, u8 width, u8 block_width_log2)
+static u16 imgu_css_grid_end(u16 start, u8 width, u8 block_width_log2)
 {
 	return (start & IPU3_UAPI_GRID_START_MASK) +
 		(width << block_width_log2) - 1;
 }
 
-static void ipu3_css_grid_end_calc(struct ipu3_uapi_grid_config *grid_cfg)
+static void imgu_css_grid_end_calc(struct ipu3_uapi_grid_config *grid_cfg)
 {
-	grid_cfg->x_end = ipu3_css_grid_end(grid_cfg->x_start, grid_cfg->width,
+	grid_cfg->x_end = imgu_css_grid_end(grid_cfg->x_start, grid_cfg->width,
 					    grid_cfg->block_width_log2);
-	grid_cfg->y_end = ipu3_css_grid_end(grid_cfg->y_start, grid_cfg->height,
+	grid_cfg->y_end = imgu_css_grid_end(grid_cfg->y_start, grid_cfg->height,
 					    grid_cfg->block_height_log2);
 }
 
 /****************** config computation *****************************/
 
-static int ipu3_css_cfg_acc_stripe(struct ipu3_css *css, unsigned int pipe,
+static int imgu_css_cfg_acc_stripe(struct imgu_css *css, unsigned int pipe,
 				   struct imgu_abi_acc_param *acc)
 {
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
-	struct ipu3_css_scaler_info scaler_luma, scaler_chroma;
+	struct imgu_css_scaler_info scaler_luma, scaler_chroma;
 	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
 	const unsigned int f = IPU3_UAPI_ISP_VEC_ELEMS * 2;
 	unsigned int bds_ds, i;
@@ -1744,7 +1744,7 @@ static int ipu3_css_cfg_acc_stripe(struct ipu3_css *css, unsigned int pipe,
 
 	/* acc_param: osys_config */
 
-	if (ipu3_css_osys_calc(css, pipe, stripes, &acc->osys, &scaler_luma,
+	if (imgu_css_osys_calc(css, pipe, stripes, &acc->osys, &scaler_luma,
 			       &scaler_chroma, acc->stripe.block_stripes))
 		return -EINVAL;
 
@@ -1901,12 +1901,12 @@ static int ipu3_css_cfg_acc_stripe(struct ipu3_css *css, unsigned int pipe,
 	return 0;
 }
 
-static void ipu3_css_cfg_acc_dvs(struct ipu3_css *css,
+static void imgu_css_cfg_acc_dvs(struct imgu_css *css,
 				 struct imgu_abi_acc_param *acc,
 				 unsigned int pipe)
 {
 	unsigned int i;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	/* Disable DVS statistics */
 	acc->dvs_stat.operations_data.process_lines_data[0].lines =
@@ -1920,11 +1920,11 @@ static void ipu3_css_cfg_acc_dvs(struct ipu3_css *css,
 		acc->dvs_stat.cfg.grd_config[i].enable = 0;
 }
 
-static void acc_bds_per_stripe_data(struct ipu3_css *css,
+static void acc_bds_per_stripe_data(struct imgu_css *css,
 				    struct imgu_abi_acc_param *acc,
 				    const int i, unsigned int pipe)
 {
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	acc->bds.per_stripe.aligned_data[i].data.crop.hor_crop_en = 0;
 	acc->bds.per_stripe.aligned_data[i].data.crop.hor_crop_start = 0;
@@ -1945,13 +1945,13 @@ static void acc_bds_per_stripe_data(struct ipu3_css *css,
  * telling which fields to take from the old values (or generate if it is NULL)
  * and which to take from the new user values.
  */
-int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_acc(struct imgu_css *css, unsigned int pipe,
 		     struct ipu3_uapi_flags *use,
 		     struct imgu_abi_acc_param *acc,
 		     struct imgu_abi_acc_param *acc_old,
 		     struct ipu3_uapi_acc_param *acc_user)
 {
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
 	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
@@ -1960,7 +1960,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 	const unsigned int min_overlap = 10;
 	const struct v4l2_pix_format_mplane *pixm =
 		&css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix;
-	const struct ipu3_css_bds_config *cfg_bds;
+	const struct imgu_css_bds_config *cfg_bds;
 	struct imgu_abi_input_feeder_data *feeder_data;
 
 	unsigned int bds_ds, ofs_x, ofs_y, i, width, height;
@@ -1968,7 +1968,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 	/* Update stripe using chroma and luma */
 
-	if (ipu3_css_cfg_acc_stripe(css, pipe, acc))
+	if (imgu_css_cfg_acc_stripe(css, pipe, acc))
 		return -EINVAL;
 
 	/* acc_param: input_feeder_config */
@@ -2022,7 +2022,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->bnr = acc_old->bnr;
 	} else {
 		/* Calculate from scratch */
-		acc->bnr = ipu3_css_bnr_defaults;
+		acc->bnr = imgu_css_bnr_defaults;
 	}
 
 	acc->bnr.column_size = tnr_frame_width;
@@ -2050,7 +2050,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->dm = acc_old->dm;
 	} else {
 		/* Calculate from scratch */
-		acc->dm = ipu3_css_dm_defaults;
+		acc->dm = imgu_css_dm_defaults;
 	}
 
 	acc->dm.frame_width = tnr_frame_width;
@@ -2065,7 +2065,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->ccm = acc_old->ccm;
 	} else {
 		/* Calculate from scratch */
-		acc->ccm = ipu3_css_ccm_defaults;
+		acc->ccm = imgu_css_ccm_defaults;
 	}
 
 	/* acc_param: gamma_config */
@@ -2079,7 +2079,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 	} else {
 		/* Calculate from scratch */
 		acc->gamma.gc_ctrl.enable = 1;
-		acc->gamma.gc_lut = ipu3_css_gamma_lut;
+		acc->gamma.gc_lut = imgu_css_gamma_lut;
 	}
 
 	/* acc_param: csc_mat_config */
@@ -2092,7 +2092,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->csc = acc_old->csc;
 	} else {
 		/* Calculate from scratch */
-		acc->csc = ipu3_css_csc_defaults;
+		acc->csc = imgu_css_csc_defaults;
 	}
 
 	/* acc_param: cds_params */
@@ -2105,7 +2105,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->cds = acc_old->cds;
 	} else {
 		/* Calculate from scratch */
-		acc->cds = ipu3_css_cds_defaults;
+		acc->cds = imgu_css_cds_defaults;
 	}
 
 	/* acc_param: shd_config */
@@ -2120,7 +2120,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->shd.shd_lut = acc_old->shd.shd_lut;
 	} else {
 		/* Calculate from scratch */
-		acc->shd.shd = ipu3_css_shd_defaults;
+		acc->shd.shd = imgu_css_shd_defaults;
 		memset(&acc->shd.shd_lut, 0, sizeof(acc->shd.shd_lut));
 	}
 
@@ -2138,12 +2138,12 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 				 acc->shd.shd.grid.block_height_log2) %
 				acc->shd.shd.grid.grid_height_per_slice;
 
-	if (ipu3_css_shd_ops_calc(&acc->shd.shd_ops, &acc->shd.shd.grid,
+	if (imgu_css_shd_ops_calc(&acc->shd.shd_ops, &acc->shd.shd.grid,
 				  css_pipe->rect[IPU3_CSS_RECT_BDS].height))
 		return -EINVAL;
 
 	/* acc_param: dvs_stat_config */
-	ipu3_css_cfg_acc_dvs(css, acc, pipe);
+	imgu_css_cfg_acc_dvs(css, acc, pipe);
 
 	/* acc_param: yuvp1_iefd_config */
 
@@ -2155,7 +2155,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->iefd = acc_old->iefd;
 	} else {
 		/* Calculate from scratch */
-		acc->iefd = ipu3_css_iefd_defaults;
+		acc->iefd = imgu_css_iefd_defaults;
 	}
 
 	/* acc_param: yuvp1_yds_config yds_c0 */
@@ -2168,7 +2168,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->yds_c0 = acc_old->yds_c0;
 	} else {
 		/* Calculate from scratch */
-		acc->yds_c0 = ipu3_css_yds_defaults;
+		acc->yds_c0 = imgu_css_yds_defaults;
 	}
 
 	/* acc_param: yuvp1_chnr_config chnr_c0 */
@@ -2181,7 +2181,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->chnr_c0 = acc_old->chnr_c0;
 	} else {
 		/* Calculate from scratch */
-		acc->chnr_c0 = ipu3_css_chnr_defaults;
+		acc->chnr_c0 = imgu_css_chnr_defaults;
 	}
 
 	/* acc_param: yuvp1_y_ee_nr_config */
@@ -2194,7 +2194,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->y_ee_nr = acc_old->y_ee_nr;
 	} else {
 		/* Calculate from scratch */
-		acc->y_ee_nr = ipu3_css_y_ee_nr_defaults;
+		acc->y_ee_nr = imgu_css_y_ee_nr_defaults;
 	}
 
 	/* acc_param: yuvp1_yds_config yds */
@@ -2207,7 +2207,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->yds = acc_old->yds;
 	} else {
 		/* Calculate from scratch */
-		acc->yds = ipu3_css_yds_defaults;
+		acc->yds = imgu_css_yds_defaults;
 	}
 
 	/* acc_param: yuvp1_chnr_config chnr */
@@ -2220,7 +2220,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->chnr = acc_old->chnr;
 	} else {
 		/* Calculate from scratch */
-		acc->chnr = ipu3_css_chnr_defaults;
+		acc->chnr = imgu_css_chnr_defaults;
 	}
 
 	/* acc_param: yuvp2_y_tm_lut_static_config */
@@ -2239,7 +2239,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->yds2 = acc_old->yds2;
 	} else {
 		/* Calculate from scratch */
-		acc->yds2 = ipu3_css_yds_defaults;
+		acc->yds2 = imgu_css_yds_defaults;
 	}
 
 	/* acc_param: yuvp2_tcc_static_config */
@@ -2271,8 +2271,8 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		for (i = 7; i < IPU3_UAPI_YUVP2_TCC_INV_Y_LUT_ELEMENTS; i++)
 			acc->tcc.inv_y_lut.entries[i] = 1024 >> (i - 6);
 
-		acc->tcc.gain_pcwl = ipu3_css_tcc_gain_pcwl_lut;
-		acc->tcc.r_sqr_lut = ipu3_css_tcc_r_sqr_lut;
+		acc->tcc.gain_pcwl = imgu_css_tcc_gain_pcwl_lut;
+		acc->tcc.r_sqr_lut = imgu_css_tcc_r_sqr_lut;
 	}
 
 	/* acc_param: dpc_config */
@@ -2288,10 +2288,10 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 	bds_ds = (css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height *
 		  IMGU_BDS_GRANULARITY) / css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	if (bds_ds < IMGU_BDS_MIN_SF_INV ||
-	    bds_ds - IMGU_BDS_MIN_SF_INV >= ARRAY_SIZE(ipu3_css_bds_configs))
+	    bds_ds - IMGU_BDS_MIN_SF_INV >= ARRAY_SIZE(imgu_css_bds_configs))
 		return -EINVAL;
 
-	cfg_bds = &ipu3_css_bds_configs[bds_ds - IMGU_BDS_MIN_SF_INV];
+	cfg_bds = &imgu_css_bds_configs[bds_ds - IMGU_BDS_MIN_SF_INV];
 	acc->bds.hor.hor_ctrl1.hor_crop_en = 0;
 	acc->bds.hor.hor_ctrl1.hor_crop_start = 0;
 	acc->bds.hor.hor_ctrl1.hor_crop_end = 0;
@@ -2340,7 +2340,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		       sizeof(acc->anr.stitch.pyramid));
 	} else {
 		/* Calculate from scratch */
-		acc->anr = ipu3_css_anr_defaults;
+		acc->anr = imgu_css_anr_defaults;
 	}
 
 	/* Always enabled */
@@ -2378,10 +2378,10 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->awb_fr.config = acc_old->awb_fr.config;
 	} else {
 		/* Set from scratch */
-		acc->awb_fr.config = ipu3_css_awb_fr_defaults;
+		acc->awb_fr.config = imgu_css_awb_fr_defaults;
 	}
 
-	ipu3_css_grid_end_calc(&acc->awb_fr.config.grid_cfg);
+	imgu_css_grid_end_calc(&acc->awb_fr.config.grid_cfg);
 
 	if (acc->awb_fr.config.grid_cfg.width <= 0)
 		return -EINVAL;
@@ -2416,7 +2416,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			acc->awb_fr.stripes[0].grid_cfg.width;
 
 		b_w_log2 = acc->awb_fr.stripes[0].grid_cfg.block_width_log2;
-		end = ipu3_css_grid_end(acc->awb_fr.stripes[0].grid_cfg.x_start,
+		end = imgu_css_grid_end(acc->awb_fr.stripes[0].grid_cfg.x_start,
 					acc->awb_fr.stripes[0].grid_cfg.width,
 					b_w_log2);
 		acc->awb_fr.stripes[0].grid_cfg.x_end = end;
@@ -2426,7 +2426,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			 acc->stripe.down_scaled_stripes[1].offset) &
 			IPU3_UAPI_GRID_START_MASK;
 		b_w_log2 = acc->awb_fr.stripes[1].grid_cfg.block_width_log2;
-		end = ipu3_css_grid_end(acc->awb_fr.stripes[1].grid_cfg.x_start,
+		end = imgu_css_grid_end(acc->awb_fr.stripes[1].grid_cfg.x_start,
 					acc->awb_fr.stripes[1].grid_cfg.width,
 					b_w_log2);
 		acc->awb_fr.stripes[1].grid_cfg.x_end = end;
@@ -2440,7 +2440,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			acc->awb_fr.stripes[i].grid_cfg.height_per_slice = 1;
 	}
 
-	if (ipu3_css_awb_fr_ops_calc(css, pipe, &acc->awb_fr))
+	if (imgu_css_awb_fr_ops_calc(css, pipe, &acc->awb_fr))
 		return -EINVAL;
 
 	/* acc_param: ae_config */
@@ -2462,18 +2462,18 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		static const struct ipu3_uapi_ae_weight_elem
 			weight_def = { 1, 1, 1, 1, 1, 1, 1, 1 };
 
-		acc->ae.grid_cfg = ipu3_css_ae_grid_defaults;
-		acc->ae.ae_ccm = ipu3_css_ae_ccm_defaults;
+		acc->ae.grid_cfg = imgu_css_ae_grid_defaults;
+		acc->ae.ae_ccm = imgu_css_ae_ccm_defaults;
 		for (i = 0; i < IPU3_UAPI_AE_WEIGHTS; i++)
 			acc->ae.weights[i] = weight_def;
 	}
 
 	b_w_log2 = acc->ae.grid_cfg.block_width_log2;
-	acc->ae.grid_cfg.x_end = ipu3_css_grid_end(acc->ae.grid_cfg.x_start,
+	acc->ae.grid_cfg.x_end = imgu_css_grid_end(acc->ae.grid_cfg.x_start,
 						   acc->ae.grid_cfg.width,
 						   b_w_log2);
 	b_w_log2 = acc->ae.grid_cfg.block_height_log2;
-	acc->ae.grid_cfg.y_end = ipu3_css_grid_end(acc->ae.grid_cfg.y_start,
+	acc->ae.grid_cfg.y_end = imgu_css_grid_end(acc->ae.grid_cfg.y_start,
 						   acc->ae.grid_cfg.height,
 						   b_w_log2);
 
@@ -2502,7 +2502,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 		b_w_log2 = acc->ae.stripes[0].grid.block_width_log2;
 		acc->ae.stripes[0].grid.x_end =
-			ipu3_css_grid_end(acc->ae.stripes[0].grid.x_start,
+			imgu_css_grid_end(acc->ae.stripes[0].grid.x_start,
 					  acc->ae.stripes[0].grid.width,
 					  b_w_log2);
 
@@ -2512,7 +2512,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			IPU3_UAPI_GRID_START_MASK;
 		b_w_log2 = acc->ae.stripes[1].grid.block_width_log2;
 		acc->ae.stripes[1].grid.x_end =
-			ipu3_css_grid_end(acc->ae.stripes[1].grid.x_start,
+			imgu_css_grid_end(acc->ae.stripes[1].grid.x_start,
 					  acc->ae.stripes[1].grid.width,
 					  b_w_log2);
 	}
@@ -2529,11 +2529,11 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 	} else {
 		/* Set from scratch */
 		acc->af.config.filter_config =
-				ipu3_css_af_defaults.filter_config;
-		acc->af.config.grid_cfg = ipu3_css_af_defaults.grid_cfg;
+				imgu_css_af_defaults.filter_config;
+		acc->af.config.grid_cfg = imgu_css_af_defaults.grid_cfg;
 	}
 
-	ipu3_css_grid_end_calc(&acc->af.config.grid_cfg);
+	imgu_css_grid_end_calc(&acc->af.config.grid_cfg);
 
 	if (acc->af.config.grid_cfg.width <= 0)
 		return -EINVAL;
@@ -2579,7 +2579,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 		b_w_log2 = acc->af.stripes[0].grid_cfg.block_width_log2;
 		acc->af.stripes[0].grid_cfg.x_end =
-			ipu3_css_grid_end(acc->af.stripes[0].grid_cfg.x_start,
+			imgu_css_grid_end(acc->af.stripes[0].grid_cfg.x_start,
 					  acc->af.stripes[0].grid_cfg.width,
 					  b_w_log2);
 
@@ -2590,7 +2590,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 		b_w_log2 = acc->af.stripes[1].grid_cfg.block_width_log2;
 		acc->af.stripes[1].grid_cfg.x_end =
-			ipu3_css_grid_end(acc->af.stripes[1].grid_cfg.x_start,
+			imgu_css_grid_end(acc->af.stripes[1].grid_cfg.x_start,
 					  acc->af.stripes[1].grid_cfg.width,
 					  b_w_log2);
 
@@ -2602,7 +2602,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			acc->af.stripes[i].grid_cfg.height_per_slice = 1;
 	}
 
-	if (ipu3_css_af_ops_calc(css, pipe, &acc->af))
+	if (imgu_css_af_ops_calc(css, pipe, &acc->af))
 		return -EINVAL;
 
 	/* acc_param: awb_config */
@@ -2615,7 +2615,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 		acc->awb.config = acc_old->awb.config;
 	} else {
 		/* Set from scratch */
-		acc->awb.config = ipu3_css_awb_defaults;
+		acc->awb.config = imgu_css_awb_defaults;
 	}
 
 	if (acc->awb.config.grid.width <= 0)
@@ -2623,7 +2623,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 	acc->awb.config.grid.height_per_slice =
 		IMGU_ABI_AWB_MAX_CELLS_PER_SET / acc->awb.config.grid.width,
-	ipu3_css_grid_end_calc(&acc->awb.config.grid);
+	imgu_css_grid_end_calc(&acc->awb.config.grid);
 
 	for (i = 0; i < stripes; i++)
 		acc->awb.stripes[i] = acc->awb.config;
@@ -2648,7 +2648,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 		b_w_log2 = acc->awb.stripes[0].grid.block_width_log2;
 		acc->awb.stripes[0].grid.x_end =
-			ipu3_css_grid_end(acc->awb.stripes[0].grid.x_start,
+			imgu_css_grid_end(acc->awb.stripes[0].grid.x_start,
 					  acc->awb.stripes[0].grid.width,
 					  b_w_log2);
 
@@ -2659,7 +2659,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 
 		b_w_log2 = acc->awb.stripes[1].grid.block_width_log2;
 		acc->awb.stripes[1].grid.x_end =
-			ipu3_css_grid_end(acc->awb.stripes[1].grid.x_start,
+			imgu_css_grid_end(acc->awb.stripes[1].grid.x_start,
 					  acc->awb.stripes[1].grid.width,
 					  b_w_log2);
 
@@ -2671,7 +2671,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
 			acc->awb.stripes[i].grid.height_per_slice = 1;
 	}
 
-	if (ipu3_css_awb_ops_calc(css, pipe, &acc->awb))
+	if (imgu_css_awb_ops_calc(css, pipe, &acc->awb))
 		return -EINVAL;
 
 	return 0;
@@ -2686,7 +2686,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
  * to the structure inside `new_binary_params'. In that case the caller
  * should calculate and fill the structure from scratch.
  */
-static void *ipu3_css_cfg_copy(struct ipu3_css *css,
+static void *imgu_css_cfg_copy(struct imgu_css *css,
 			       unsigned int pipe, bool use_user,
 			       void *user_setting, void *old_binary_params,
 			       void *new_binary_params,
@@ -2697,7 +2697,7 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css,
 	const enum imgu_abi_param_class c = IMGU_ABI_PARAM_CLASS_PARAM;
 	void *new_setting, *old_setting;
 
-	new_setting = ipu3_css_fw_pipeline_params(css, pipe, c, m, par,
+	new_setting = imgu_css_fw_pipeline_params(css, pipe, c, m, par,
 						  par_size, new_binary_params);
 	if (!new_setting)
 		return ERR_PTR(-EPROTO);	/* Corrupted firmware */
@@ -2707,7 +2707,7 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css,
 		memcpy(new_setting, user_setting, par_size);
 	} else if (old_binary_params) {
 		/* Take previous value */
-		old_setting = ipu3_css_fw_pipeline_params(css, pipe, c, m, par,
+		old_setting = imgu_css_fw_pipeline_params(css, pipe, c, m, par,
 							  par_size,
 							  old_binary_params);
 		if (!old_setting)
@@ -2723,7 +2723,7 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css,
 /*
  * Configure VMEM0 parameters (late binding parameters).
  */
-int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_vmem0(struct imgu_css *css, unsigned int pipe,
 		       struct ipu3_uapi_flags *use,
 		       void *vmem0, void *vmem0_old,
 		       struct ipu3_uapi_params *user)
@@ -2745,7 +2745,7 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
 
 	/* Configure Linearization VMEM0 parameters */
 
-	lin_vmem = ipu3_css_cfg_copy(css, pipe, use && use->lin_vmem_params,
+	lin_vmem = imgu_css_cfg_copy(css, pipe, use && use->lin_vmem_params,
 				     &user->lin_vmem_params, vmem0_old, vmem0,
 				     m, &pofs->vmem.lin, sizeof(*lin_vmem));
 	if (!IS_ERR_OR_NULL(lin_vmem)) {
@@ -2765,7 +2765,7 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
 
 	/* Configure TNR3 VMEM parameters */
 	if (css->pipes[pipe].pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		tnr_vmem = ipu3_css_cfg_copy(css, pipe,
+		tnr_vmem = imgu_css_cfg_copy(css, pipe,
 					     use && use->tnr3_vmem_params,
 					     &user->tnr3_vmem_params,
 					     vmem0_old, vmem0, m,
@@ -2781,17 +2781,17 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
 
 	/* Configure XNR3 VMEM parameters */
 
-	xnr_vmem = ipu3_css_cfg_copy(css, pipe, use && use->xnr3_vmem_params,
+	xnr_vmem = imgu_css_cfg_copy(css, pipe, use && use->xnr3_vmem_params,
 				     &user->xnr3_vmem_params, vmem0_old, vmem0,
 				     m, &pofs->vmem.xnr3, sizeof(*xnr_vmem));
 	if (!IS_ERR_OR_NULL(xnr_vmem)) {
-		xnr_vmem->x[i] = ipu3_css_xnr3_vmem_defaults.x
+		xnr_vmem->x[i] = imgu_css_xnr3_vmem_defaults.x
 			[i % IMGU_XNR3_VMEM_LUT_LEN];
-		xnr_vmem->a[i] = ipu3_css_xnr3_vmem_defaults.a
+		xnr_vmem->a[i] = imgu_css_xnr3_vmem_defaults.a
 			[i % IMGU_XNR3_VMEM_LUT_LEN];
-		xnr_vmem->b[i] = ipu3_css_xnr3_vmem_defaults.b
+		xnr_vmem->b[i] = imgu_css_xnr3_vmem_defaults.b
 			[i % IMGU_XNR3_VMEM_LUT_LEN];
-		xnr_vmem->c[i] = ipu3_css_xnr3_vmem_defaults.c
+		xnr_vmem->c[i] = imgu_css_xnr3_vmem_defaults.c
 			[i % IMGU_XNR3_VMEM_LUT_LEN];
 	}
 
@@ -2802,12 +2802,12 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
 /*
  * Configure DMEM0 parameters (late binding parameters).
  */
-int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_dmem0(struct imgu_css *css, unsigned int pipe,
 		       struct ipu3_uapi_flags *use,
 		       void *dmem0, void *dmem0_old,
 		       struct ipu3_uapi_params *user)
 {
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
 		&css->fwp->binary_header[css_pipe->bindex];
 	struct imgu_fw_param_memory_offsets *pofs = (void *)css->fwp +
@@ -2825,7 +2825,7 @@ int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
 
 	/* Configure TNR3 DMEM0 parameters */
 	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		tnr_dmem = ipu3_css_cfg_copy(css, pipe,
+		tnr_dmem = imgu_css_cfg_copy(css, pipe,
 					     use && use->tnr3_dmem_params,
 					     &user->tnr3_dmem_params,
 					     dmem0_old, dmem0, m,
@@ -2840,7 +2840,7 @@ int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
 
 	/* Configure XNR3 DMEM0 parameters */
 
-	xnr_dmem = ipu3_css_cfg_copy(css, pipe, use && use->xnr3_dmem_params,
+	xnr_dmem = imgu_css_cfg_copy(css, pipe, use && use->xnr3_dmem_params,
 				     &user->xnr3_dmem_params, dmem0_old, dmem0,
 				     m, &pofs->dmem.xnr3, sizeof(*xnr_dmem));
 	if (!IS_ERR_OR_NULL(xnr_dmem)) {
@@ -2854,7 +2854,7 @@ int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
 }
 
 /* Generate unity morphing table without morphing effect */
-void ipu3_css_cfg_gdc_table(struct imgu_abi_gdc_warp_param *gdc,
+void imgu_css_cfg_gdc_table(struct imgu_abi_gdc_warp_param *gdc,
 			    int frame_in_x, int frame_in_y,
 			    int frame_out_x, int frame_out_y,
 			    int env_w, int env_h)
diff --git a/drivers/staging/media/ipu3/ipu3-css-params.h b/drivers/staging/media/ipu3/ipu3-css-params.h
index f3a0a47117a4..ffaec6b7d5cc 100644
--- a/drivers/staging/media/ipu3/ipu3-css-params.h
+++ b/drivers/staging/media/ipu3/ipu3-css-params.h
@@ -4,23 +4,23 @@
 #ifndef __IPU3_PARAMS_H
 #define __IPU3_PARAMS_H
 
-int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_acc(struct imgu_css *css, unsigned int pipe,
 		     struct ipu3_uapi_flags *use,
 		     struct imgu_abi_acc_param *acc,
 		     struct imgu_abi_acc_param *acc_old,
 		     struct ipu3_uapi_acc_param *acc_user);
 
-int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_vmem0(struct imgu_css *css, unsigned int pipe,
 		       struct ipu3_uapi_flags *use,
 		       void *vmem0, void *vmem0_old,
 		       struct ipu3_uapi_params *user);
 
-int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_cfg_dmem0(struct imgu_css *css, unsigned int pipe,
 		       struct ipu3_uapi_flags *use,
 		       void *dmem0, void *dmem0_old,
 		       struct ipu3_uapi_params *user);
 
-void ipu3_css_cfg_gdc_table(struct imgu_abi_gdc_warp_param *gdc,
+void imgu_css_cfg_gdc_table(struct imgu_abi_gdc_warp_param *gdc,
 			    int frame_in_x, int frame_in_y,
 			    int frame_out_x, int frame_out_y,
 			    int env_w, int env_h);
diff --git a/drivers/staging/media/ipu3/ipu3-css-pool.c b/drivers/staging/media/ipu3/ipu3-css-pool.c
index 6f271f81669b..fa5b7d3acef2 100644
--- a/drivers/staging/media/ipu3/ipu3-css-pool.c
+++ b/drivers/staging/media/ipu3/ipu3-css-pool.c
@@ -7,30 +7,30 @@
 #include "ipu3-css-pool.h"
 #include "ipu3-dmamap.h"
 
-int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
-			       struct ipu3_css_map *map, size_t size)
+int imgu_css_dma_buffer_resize(struct imgu_device *imgu,
+			       struct imgu_css_map *map, size_t size)
 {
 	if (map->size < size && map->vaddr) {
 		dev_warn(&imgu->pci_dev->dev, "dma buf resized from %zu to %zu",
 			 map->size, size);
 
-		ipu3_dmamap_free(imgu, map);
-		if (!ipu3_dmamap_alloc(imgu, map, size))
+		imgu_dmamap_free(imgu, map);
+		if (!imgu_dmamap_alloc(imgu, map, size))
 			return -ENOMEM;
 	}
 
 	return 0;
 }
 
-void ipu3_css_pool_cleanup(struct imgu_device *imgu, struct ipu3_css_pool *pool)
+void imgu_css_pool_cleanup(struct imgu_device *imgu, struct imgu_css_pool *pool)
 {
 	unsigned int i;
 
 	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
-		ipu3_dmamap_free(imgu, &pool->entry[i].param);
+		imgu_dmamap_free(imgu, &pool->entry[i].param);
 }
 
-int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
+int imgu_css_pool_init(struct imgu_device *imgu, struct imgu_css_pool *pool,
 		       size_t size)
 {
 	unsigned int i;
@@ -42,7 +42,7 @@ int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
 			continue;
 		}
 
-		if (!ipu3_dmamap_alloc(imgu, &pool->entry[i].param, size))
+		if (!imgu_dmamap_alloc(imgu, &pool->entry[i].param, size))
 			goto fail;
 	}
 
@@ -51,14 +51,14 @@ int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
 	return 0;
 
 fail:
-	ipu3_css_pool_cleanup(imgu, pool);
+	imgu_css_pool_cleanup(imgu, pool);
 	return -ENOMEM;
 }
 
 /*
  * Allocate a new parameter via recycling the oldest entry in the pool.
  */
-void ipu3_css_pool_get(struct ipu3_css_pool *pool)
+void imgu_css_pool_get(struct imgu_css_pool *pool)
 {
 	/* Get the oldest entry */
 	u32 n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
@@ -70,25 +70,25 @@ void ipu3_css_pool_get(struct ipu3_css_pool *pool)
 /*
  * Undo, for all practical purposes, the effect of pool_get().
  */
-void ipu3_css_pool_put(struct ipu3_css_pool *pool)
+void imgu_css_pool_put(struct imgu_css_pool *pool)
 {
 	pool->entry[pool->last].valid = false;
 	pool->last = (pool->last + IPU3_CSS_POOL_SIZE - 1) % IPU3_CSS_POOL_SIZE;
 }
 
 /**
- * ipu3_css_pool_last - Retrieve the nth pool entry from last
+ * imgu_css_pool_last - Retrieve the nth pool entry from last
  *
- * @pool: a pointer to &struct ipu3_css_pool.
+ * @pool: a pointer to &struct imgu_css_pool.
  * @n: the distance to the last index.
  *
  * Returns:
  *  The nth entry from last or null map to indicate no frame stored.
  */
-const struct ipu3_css_map *
-ipu3_css_pool_last(struct ipu3_css_pool *pool, unsigned int n)
+const struct imgu_css_map *
+imgu_css_pool_last(struct imgu_css_pool *pool, unsigned int n)
 {
-	static const struct ipu3_css_map null_map = { 0 };
+	static const struct imgu_css_map null_map = { 0 };
 	int i = (pool->last + IPU3_CSS_POOL_SIZE - n) % IPU3_CSS_POOL_SIZE;
 
 	WARN_ON(n >= IPU3_CSS_POOL_SIZE);
diff --git a/drivers/staging/media/ipu3/ipu3-css-pool.h b/drivers/staging/media/ipu3/ipu3-css-pool.h
index 2657c39a4d71..f4a60b41401b 100644
--- a/drivers/staging/media/ipu3/ipu3-css-pool.h
+++ b/drivers/staging/media/ipu3/ipu3-css-pool.h
@@ -10,15 +10,15 @@ struct imgu_device;
 #define IPU3_CSS_POOL_SIZE		4
 
 /**
- * ipu3_css_map - store DMA mapping info for buffer
+ * imgu_css_map - store DMA mapping info for buffer
  *
  * @size:		size of the buffer in bytes.
  * @vaddr:		kernel virtual address.
  * @daddr:		iova dma address to access IPU3.
  * @vma:		private, a pointer to &struct vm_struct,
- *			used for ipu3_dmamap_free.
+ *			used for imgu_dmamap_free.
  */
-struct ipu3_css_map {
+struct imgu_css_map {
 	size_t size;
 	void *vaddr;
 	dma_addr_t daddr;
@@ -26,30 +26,30 @@ struct ipu3_css_map {
 };
 
 /**
- * ipu3_css_pool - circular buffer pool definition
+ * imgu_css_pool - circular buffer pool definition
  *
  * @entry:		array with IPU3_CSS_POOL_SIZE elements.
- * @entry.param:	a &struct ipu3_css_map for storing the mem mapping.
+ * @entry.param:	a &struct imgu_css_map for storing the mem mapping.
  * @entry.valid:	used to mark if the entry has valid data.
  * @last:		write pointer, initialized to IPU3_CSS_POOL_SIZE.
  */
-struct ipu3_css_pool {
+struct imgu_css_pool {
 	struct {
-		struct ipu3_css_map param;
+		struct imgu_css_map param;
 		bool valid;
 	} entry[IPU3_CSS_POOL_SIZE];
 	u32 last;
 };
 
-int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
-			       struct ipu3_css_map *map, size_t size);
-void ipu3_css_pool_cleanup(struct imgu_device *imgu,
-			   struct ipu3_css_pool *pool);
-int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
+int imgu_css_dma_buffer_resize(struct imgu_device *imgu,
+			       struct imgu_css_map *map, size_t size);
+void imgu_css_pool_cleanup(struct imgu_device *imgu,
+			   struct imgu_css_pool *pool);
+int imgu_css_pool_init(struct imgu_device *imgu, struct imgu_css_pool *pool,
 		       size_t size);
-void ipu3_css_pool_get(struct ipu3_css_pool *pool);
-void ipu3_css_pool_put(struct ipu3_css_pool *pool);
-const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
+void imgu_css_pool_get(struct imgu_css_pool *pool);
+void imgu_css_pool_put(struct imgu_css_pool *pool);
+const struct imgu_css_map *imgu_css_pool_last(struct imgu_css_pool *pool,
 					      u32 last);
 
 #endif
diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 44c55639389a..5ce4ed2031db 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -46,7 +46,7 @@
 			IPU3_CSS_QUEUE_TO_FLAGS(IPU3_CSS_QUEUE_VF)
 
 /* Formats supported by IPU3 Camera Sub System */
-static const struct ipu3_css_format ipu3_css_formats[] = {
+static const struct imgu_css_format imgu_css_formats[] = {
 	{
 		.pixelformat = V4L2_PIX_FMT_NV12,
 		.colorspace = V4L2_COLORSPACE_SRGB,
@@ -100,7 +100,7 @@ static const struct ipu3_css_format ipu3_css_formats[] = {
 static const struct {
 	enum imgu_abi_queue_id qid;
 	size_t ptr_ofs;
-} ipu3_css_queues[IPU3_CSS_QUEUES] = {
+} imgu_css_queues[IPU3_CSS_QUEUES] = {
 	[IPU3_CSS_QUEUE_IN] = {
 		IMGU_ABI_QUEUE_C_ID,
 		offsetof(struct imgu_abi_buffer, payload.frame.frame_data)
@@ -120,7 +120,7 @@ static const struct {
 };
 
 /* Initialize queue based on given format, adjust format as needed */
-static int ipu3_css_queue_init(struct ipu3_css_queue *queue,
+static int imgu_css_queue_init(struct imgu_css_queue *queue,
 			       struct v4l2_pix_format_mplane *fmt, u32 flags)
 {
 	struct v4l2_pix_format_mplane *const f = &queue->fmt.mpix;
@@ -133,11 +133,11 @@ static int ipu3_css_queue_init(struct ipu3_css_queue *queue,
 	if (!fmt)
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(ipu3_css_formats); i++) {
-		if (!(ipu3_css_formats[i].flags & flags))
+	for (i = 0; i < ARRAY_SIZE(imgu_css_formats); i++) {
+		if (!(imgu_css_formats[i].flags & flags))
 			continue;
-		queue->css_fmt = &ipu3_css_formats[i];
-		if (ipu3_css_formats[i].pixelformat == fmt->pixelformat)
+		queue->css_fmt = &imgu_css_formats[i];
+		if (imgu_css_formats[i].pixelformat == fmt->pixelformat)
 			break;
 	}
 	if (!queue->css_fmt)
@@ -178,7 +178,7 @@ static int ipu3_css_queue_init(struct ipu3_css_queue *queue,
 	return 0;
 }
 
-static bool ipu3_css_queue_enabled(struct ipu3_css_queue *q)
+static bool imgu_css_queue_enabled(struct imgu_css_queue *q)
 {
 	return q->css_fmt;
 }
@@ -200,7 +200,7 @@ static inline void writes(const void *mem, ssize_t count, void __iomem *addr)
 }
 
 /* Wait until register `reg', masked with `mask', becomes `cmp' */
-static int ipu3_hw_wait(void __iomem *base, int reg, u32 mask, u32 cmp)
+static int imgu_hw_wait(void __iomem *base, int reg, u32 mask, u32 cmp)
 {
 	u32 val;
 
@@ -210,7 +210,7 @@ static int ipu3_hw_wait(void __iomem *base, int reg, u32 mask, u32 cmp)
 
 /* Initialize the IPU3 CSS hardware and associated h/w blocks */
 
-int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
+int imgu_css_set_powerup(struct device *dev, void __iomem *base)
 {
 	static const unsigned int freq = 450;
 	u32 pm_ctrl, state, val;
@@ -221,7 +221,7 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 	writel(0, base + IMGU_REG_GP_BUSY);
 
 	/* Wait for idle signal */
-	if (ipu3_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+	if (imgu_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
 			 IMGU_STATE_IDLE_STS)) {
 		dev_err(dev, "failed to set CSS idle\n");
 		goto fail;
@@ -245,7 +245,7 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 	if (state & IMGU_STATE_POWER_DOWN) {
 		writel(IMGU_PM_CTRL_RACE_TO_HALT | IMGU_PM_CTRL_START,
 		       base + IMGU_REG_PM_CTRL);
-		if (ipu3_hw_wait(base, IMGU_REG_PM_CTRL,
+		if (imgu_hw_wait(base, IMGU_REG_PM_CTRL,
 				 IMGU_PM_CTRL_START, 0)) {
 			dev_err(dev, "failed to power up CSS\n");
 			goto fail;
@@ -263,7 +263,7 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 	val = pm_ctrl & ~(IMGU_PM_CTRL_CSS_PWRDN | IMGU_PM_CTRL_RST_AT_EOF);
 	writel(val, base + IMGU_REG_PM_CTRL);
 	writel(0, base + IMGU_REG_GP_BUSY);
-	if (ipu3_hw_wait(base, IMGU_REG_STATE,
+	if (imgu_hw_wait(base, IMGU_REG_STATE,
 			 IMGU_STATE_PWRDNM_FSM_MASK, 0)) {
 		dev_err(dev, "failed to pwrdn CSS\n");
 		goto fail;
@@ -273,7 +273,7 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 	writel(1, base + IMGU_REG_GP_BUSY);
 	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_FORCE_HALT,
 	       base + IMGU_REG_PM_CTRL);
-	if (ipu3_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_HALT_STS,
+	if (imgu_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_HALT_STS,
 			 IMGU_STATE_HALT_STS)) {
 		dev_err(dev, "failed to halt CSS\n");
 		goto fail;
@@ -281,7 +281,7 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 
 	writel(readl(base + IMGU_REG_PM_CTRL) | IMGU_PM_CTRL_START,
 	       base + IMGU_REG_PM_CTRL);
-	if (ipu3_hw_wait(base, IMGU_REG_PM_CTRL, IMGU_PM_CTRL_START, 0)) {
+	if (imgu_hw_wait(base, IMGU_REG_PM_CTRL, IMGU_PM_CTRL_START, 0)) {
 		dev_err(dev, "failed to start CSS\n");
 		goto fail;
 	}
@@ -296,26 +296,26 @@ int ipu3_css_set_powerup(struct device *dev, void __iomem *base)
 	return 0;
 
 fail:
-	ipu3_css_set_powerdown(dev, base);
+	imgu_css_set_powerdown(dev, base);
 	return -EIO;
 }
 
-void ipu3_css_set_powerdown(struct device *dev, void __iomem *base)
+void imgu_css_set_powerdown(struct device *dev, void __iomem *base)
 {
 	dev_dbg(dev, "%s\n", __func__);
 	/* wait for cio idle signal */
-	if (ipu3_hw_wait(base, IMGU_REG_CIO_GATE_BURST_STATE,
+	if (imgu_hw_wait(base, IMGU_REG_CIO_GATE_BURST_STATE,
 			 IMGU_CIO_GATE_BURST_MASK, 0))
 		dev_warn(dev, "wait cio gate idle timeout");
 
 	/* wait for css idle signal */
-	if (ipu3_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+	if (imgu_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
 			 IMGU_STATE_IDLE_STS))
 		dev_warn(dev, "wait css idle timeout\n");
 
 	/* do halt-halted handshake with css */
 	writel(1, base + IMGU_REG_GP_HALT);
-	if (ipu3_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_HALT_STS,
+	if (imgu_hw_wait(base, IMGU_REG_STATE, IMGU_STATE_HALT_STS,
 			 IMGU_STATE_HALT_STS))
 		dev_warn(dev, "failed to halt css");
 
@@ -323,7 +323,7 @@ void ipu3_css_set_powerdown(struct device *dev, void __iomem *base)
 	writel(0, base + IMGU_REG_GP_BUSY);
 }
 
-static void ipu3_css_hw_enable_irq(struct ipu3_css *css)
+static void imgu_css_hw_enable_irq(struct imgu_css *css)
 {
 	void __iomem *const base = css->base;
 	u32 val, i;
@@ -371,7 +371,7 @@ static void ipu3_css_hw_enable_irq(struct ipu3_css *css)
 	}
 }
 
-static int ipu3_css_hw_init(struct ipu3_css *css)
+static int imgu_css_hw_init(struct imgu_css *css)
 {
 	/* For checking that streaming monitor statuses are valid */
 	static const struct {
@@ -463,11 +463,11 @@ static int ipu3_css_hw_init(struct ipu3_css *css)
 
 	/* Initialize GDC with default values */
 
-	for (i = 0; i < ARRAY_SIZE(ipu3_css_gdc_lut[0]); i++) {
-		u32 val0 = ipu3_css_gdc_lut[0][i] & IMGU_GDC_LUT_MASK;
-		u32 val1 = ipu3_css_gdc_lut[1][i] & IMGU_GDC_LUT_MASK;
-		u32 val2 = ipu3_css_gdc_lut[2][i] & IMGU_GDC_LUT_MASK;
-		u32 val3 = ipu3_css_gdc_lut[3][i] & IMGU_GDC_LUT_MASK;
+	for (i = 0; i < ARRAY_SIZE(imgu_css_gdc_lut[0]); i++) {
+		u32 val0 = imgu_css_gdc_lut[0][i] & IMGU_GDC_LUT_MASK;
+		u32 val1 = imgu_css_gdc_lut[1][i] & IMGU_GDC_LUT_MASK;
+		u32 val2 = imgu_css_gdc_lut[2][i] & IMGU_GDC_LUT_MASK;
+		u32 val3 = imgu_css_gdc_lut[3][i] & IMGU_GDC_LUT_MASK;
 
 		writel(val0 | (val1 << 16),
 		       base + IMGU_REG_GDC_LUT_BASE + i * 8);
@@ -479,7 +479,7 @@ static int ipu3_css_hw_init(struct ipu3_css *css)
 }
 
 /* Boot the given IPU3 CSS SP */
-static int ipu3_css_hw_start_sp(struct ipu3_css *css, int sp)
+static int imgu_css_hw_start_sp(struct imgu_css *css, int sp)
 {
 	void __iomem *const base = css->base;
 	struct imgu_fw_info *bi = &css->fwp->binary_header[css->fw_sp[sp]];
@@ -501,7 +501,7 @@ static int ipu3_css_hw_start_sp(struct ipu3_css *css, int sp)
 	writel(readl(base + IMGU_REG_SP_CTRL(sp))
 		| IMGU_CTRL_START | IMGU_CTRL_RUN, base + IMGU_REG_SP_CTRL(sp));
 
-	if (ipu3_hw_wait(css->base, IMGU_REG_SP_DMEM_BASE(sp)
+	if (imgu_hw_wait(css->base, IMGU_REG_SP_DMEM_BASE(sp)
 			 + bi->info.sp.sw_state,
 			 ~0, IMGU_ABI_SP_SWSTATE_INITIALIZED))
 		return -EIO;
@@ -510,7 +510,7 @@ static int ipu3_css_hw_start_sp(struct ipu3_css *css, int sp)
 }
 
 /* Start the IPU3 CSS ImgU (Imaging Unit) and all the SPs */
-static int ipu3_css_hw_start(struct ipu3_css *css)
+static int imgu_css_hw_start(struct imgu_css *css)
 {
 	static const u32 event_mask =
 		((1 << IMGU_ABI_EVTTYPE_OUT_FRAME_DONE) |
@@ -560,7 +560,7 @@ static int ipu3_css_hw_start(struct ipu3_css *css)
 
 	writel(readl(base + IMGU_REG_ISP_CTRL)
 		| IMGU_CTRL_START | IMGU_CTRL_RUN, base + IMGU_REG_ISP_CTRL);
-	if (ipu3_hw_wait(css->base, IMGU_REG_ISP_DMEM_BASE
+	if (imgu_hw_wait(css->base, IMGU_REG_ISP_DMEM_BASE
 			 + bl->info.bl.sw_state, ~0,
 			 IMGU_ABI_BL_SWSTATE_OK)) {
 		dev_err(css->dev, "failed to start bootloader\n");
@@ -581,7 +581,7 @@ static int ipu3_css_hw_start(struct ipu3_css *css)
 	       base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.sw_state);
 	writel(1, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.invalidate_tlb);
 
-	if (ipu3_css_hw_start_sp(css, 0))
+	if (imgu_css_hw_start_sp(css, 0))
 		return -EIO;
 
 	writel(0, base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.isp_started);
@@ -608,7 +608,7 @@ static int ipu3_css_hw_start(struct ipu3_css *css)
 	writel(IMGU_ABI_SP_SWSTATE_TERMINATED,
 	       base + IMGU_REG_SP_DMEM_BASE(1) + bi->info.sp.sw_state);
 
-	if (ipu3_css_hw_start_sp(css, 1))
+	if (imgu_css_hw_start_sp(css, 1))
 		return -EIO;
 
 	writel(IMGU_ABI_SP_COMM_COMMAND_READY, base + IMGU_REG_SP_DMEM_BASE(1)
@@ -617,7 +617,7 @@ static int ipu3_css_hw_start(struct ipu3_css *css)
 	return 0;
 }
 
-static void ipu3_css_hw_stop(struct ipu3_css *css)
+static void imgu_css_hw_stop(struct imgu_css *css)
 {
 	void __iomem *const base = css->base;
 	struct imgu_fw_info *bi = &css->fwp->binary_header[css->fw_sp[0]];
@@ -626,18 +626,18 @@ static void ipu3_css_hw_stop(struct ipu3_css *css)
 	writel(IMGU_ABI_SP_COMM_COMMAND_TERMINATE,
 	       base + IMGU_REG_SP_DMEM_BASE(0) +
 	       bi->info.sp.host_sp_com + IMGU_ABI_SP_COMM_COMMAND);
-	if (ipu3_hw_wait(css->base, IMGU_REG_SP_CTRL(0),
+	if (imgu_hw_wait(css->base, IMGU_REG_SP_CTRL(0),
 			 IMGU_CTRL_IDLE, IMGU_CTRL_IDLE))
 		dev_err(css->dev, "wait sp0 idle timeout.\n");
 	if (readl(base + IMGU_REG_SP_DMEM_BASE(0) + bi->info.sp.sw_state) !=
 		  IMGU_ABI_SP_SWSTATE_TERMINATED)
 		dev_err(css->dev, "sp0 is not terminated.\n");
-	if (ipu3_hw_wait(css->base, IMGU_REG_ISP_CTRL,
+	if (imgu_hw_wait(css->base, IMGU_REG_ISP_CTRL,
 			 IMGU_CTRL_IDLE, IMGU_CTRL_IDLE))
 		dev_err(css->dev, "wait isp idle timeout\n");
 }
 
-static void ipu3_css_hw_cleanup(struct ipu3_css *css)
+static void imgu_css_hw_cleanup(struct imgu_css *css)
 {
 	void __iomem *const base = css->base;
 
@@ -648,7 +648,7 @@ static void ipu3_css_hw_cleanup(struct ipu3_css *css)
 	writel(0, base + IMGU_REG_GP_BUSY);
 
 	/* Wait for idle signal */
-	if (ipu3_hw_wait(css->base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
+	if (imgu_hw_wait(css->base, IMGU_REG_STATE, IMGU_STATE_IDLE_STS,
 			 IMGU_STATE_IDLE_STS))
 		dev_err(css->dev, "failed to shut down hw cleanly\n");
 
@@ -659,19 +659,19 @@ static void ipu3_css_hw_cleanup(struct ipu3_css *css)
 	usleep_range(200, 300);
 }
 
-static void ipu3_css_pipeline_cleanup(struct ipu3_css *css, unsigned int pipe)
+static void imgu_css_pipeline_cleanup(struct imgu_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i;
 
-	ipu3_css_pool_cleanup(imgu,
+	imgu_css_pool_cleanup(imgu,
 			      &css->pipes[pipe].pool.parameter_set_info);
-	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.acc);
-	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.gdc);
-	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.obgrid);
+	imgu_css_pool_cleanup(imgu, &css->pipes[pipe].pool.acc);
+	imgu_css_pool_cleanup(imgu, &css->pipes[pipe].pool.gdc);
+	imgu_css_pool_cleanup(imgu, &css->pipes[pipe].pool.obgrid);
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-		ipu3_css_pool_cleanup(imgu,
+		imgu_css_pool_cleanup(imgu,
 				      &css->pipes[pipe].pool.binary_params_p[i]);
 }
 
@@ -679,7 +679,7 @@ static void ipu3_css_pipeline_cleanup(struct ipu3_css *css, unsigned int pipe)
  * This function initializes various stages of the
  * IPU3 CSS ISP pipeline
  */
-static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
+static int imgu_css_pipeline_init(struct imgu_css *css, unsigned int pipe)
 {
 	static const int BYPC = 2;	/* Bytes per component */
 	static const struct imgu_abi_buffer_sp buffer_sp_init = {
@@ -697,7 +697,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	const int stage = 0;
 	unsigned int i, j;
 
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
 			&css->fwp->binary_header[css_pipe->bindex];
 	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
@@ -725,7 +725,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 
 	/* Configure iterator */
 
-	cfg_iter = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+	cfg_iter = imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 					       &cofs->dmem.iterator,
 					       sizeof(*cfg_iter), vaddr);
 	if (!cfg_iter)
@@ -791,7 +791,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 
 	/* Configure reference (delay) frames */
 
-	cfg_ref = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+	cfg_ref = imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 					      &cofs->dmem.ref,
 					      sizeof(*cfg_ref), vaddr);
 	if (!cfg_ref)
@@ -821,7 +821,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 
 	/* Configure DVS (digital video stabilization) */
 
-	cfg_dvs = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+	cfg_dvs = imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 					      &cofs->dmem.dvs, sizeof(*cfg_dvs),
 					      vaddr);
 	if (!cfg_dvs)
@@ -837,7 +837,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	/* Configure TNR (temporal noise reduction) */
 
 	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		cfg_tnr = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+		cfg_tnr = imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 						      &cofs->dmem.tnr3,
 						      sizeof(*cfg_tnr),
 						      vaddr);
@@ -868,7 +868,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	cfg = IMGU_ABI_PARAM_CLASS_STATE;
 	vaddr = css_pipe->binary_params_cs[cfg - 1][m0].vaddr;
 
-	cfg_ref_state = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+	cfg_ref_state = imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 						    &sofs->dmem.ref,
 						    sizeof(*cfg_ref_state),
 						    vaddr);
@@ -881,7 +881,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	/* Configure tnr dmem state parameters */
 	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
 		cfg_tnr_state =
-			ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+			imgu_css_fw_pipeline_params(css, pipe, cfg, m0,
 						    &sofs->dmem.tnr3,
 						    sizeof(*cfg_tnr_state),
 						    vaddr);
@@ -1068,21 +1068,21 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 
 	/* Initialize parameter pools */
 
-	if (ipu3_css_pool_init(imgu, &css_pipe->pool.parameter_set_info,
+	if (imgu_css_pool_init(imgu, &css_pipe->pool.parameter_set_info,
 			       sizeof(struct imgu_abi_parameter_set_info)) ||
-	    ipu3_css_pool_init(imgu, &css_pipe->pool.acc,
+	    imgu_css_pool_init(imgu, &css_pipe->pool.acc,
 			       sizeof(struct imgu_abi_acc_param)) ||
-	    ipu3_css_pool_init(imgu, &css_pipe->pool.gdc,
+	    imgu_css_pool_init(imgu, &css_pipe->pool.gdc,
 			       sizeof(struct imgu_abi_gdc_warp_param) *
 			       3 * cfg_dvs->num_horizontal_blocks / 2 *
 			       cfg_dvs->num_vertical_blocks) ||
-	    ipu3_css_pool_init(imgu, &css_pipe->pool.obgrid,
-			       ipu3_css_fw_obgrid_size(
+	    imgu_css_pool_init(imgu, &css_pipe->pool.obgrid,
+			       imgu_css_fw_obgrid_size(
 			       &css->fwp->binary_header[css_pipe->bindex])))
 		goto out_of_memory;
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-		if (ipu3_css_pool_init(imgu,
+		if (imgu_css_pool_init(imgu,
 				       &css_pipe->pool.binary_params_p[i],
 				       bi->info.isp.sp.mem_initializers.params
 				       [IMGU_ABI_PARAM_CLASS_PARAM][i].size))
@@ -1091,15 +1091,15 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	return 0;
 
 bad_firmware:
-	ipu3_css_pipeline_cleanup(css, pipe);
+	imgu_css_pipeline_cleanup(css, pipe);
 	return -EPROTO;
 
 out_of_memory:
-	ipu3_css_pipeline_cleanup(css, pipe);
+	imgu_css_pipeline_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
-static u8 ipu3_css_queue_pos(struct ipu3_css *css, int queue, int thread)
+static u8 imgu_css_queue_pos(struct imgu_css *css, int queue, int thread)
 {
 	static const unsigned int sp;
 	void __iomem *const base = css->base;
@@ -1112,7 +1112,7 @@ static u8 ipu3_css_queue_pos(struct ipu3_css *css, int queue, int thread)
 }
 
 /* Sent data to sp using given buffer queue, or if queue < 0, event queue. */
-static int ipu3_css_queue_data(struct ipu3_css *css,
+static int imgu_css_queue_data(struct imgu_css *css,
 			       int queue, int thread, u32 data)
 {
 	static const unsigned int sp;
@@ -1151,7 +1151,7 @@ static int ipu3_css_queue_data(struct ipu3_css *css,
 }
 
 /* Receive data using given buffer queue, or if queue < 0, event queue. */
-static int ipu3_css_dequeue_data(struct ipu3_css *css, int queue, u32 *data)
+static int imgu_css_dequeue_data(struct imgu_css *css, int queue, u32 *data)
 {
 	static const unsigned int sp;
 	void __iomem *const base = css->base;
@@ -1188,7 +1188,7 @@ static int ipu3_css_dequeue_data(struct ipu3_css *css, int queue, u32 *data)
 		writeb(start2, &q->sp2host_evtq_info.start);
 
 		/* Acknowledge events dequeued from event queue */
-		r = ipu3_css_queue_data(css, queue, 0,
+		r = imgu_css_queue_data(css, queue, 0,
 					IMGU_ABI_EVENT_EVENT_DEQUEUED);
 		if (r < 0)
 			return r;
@@ -1198,52 +1198,52 @@ static int ipu3_css_dequeue_data(struct ipu3_css *css, int queue, u32 *data)
 }
 
 /* Free binary-specific resources */
-static void ipu3_css_binary_cleanup(struct ipu3_css *css, unsigned int pipe)
+static void imgu_css_binary_cleanup(struct imgu_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i, j;
 
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	for (j = 0; j < IMGU_ABI_PARAM_CLASS_NUM - 1; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-			ipu3_dmamap_free(imgu,
+			imgu_dmamap_free(imgu,
 					 &css_pipe->binary_params_cs[j][i]);
 
 	j = IPU3_CSS_AUX_FRAME_REF;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		ipu3_dmamap_free(imgu,
+		imgu_dmamap_free(imgu,
 				 &css_pipe->aux_frames[j].mem[i]);
 
 	j = IPU3_CSS_AUX_FRAME_TNR;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		ipu3_dmamap_free(imgu,
+		imgu_dmamap_free(imgu,
 				 &css_pipe->aux_frames[j].mem[i]);
 }
 
-static int ipu3_css_binary_preallocate(struct ipu3_css *css, unsigned int pipe)
+static int imgu_css_binary_preallocate(struct imgu_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i, j;
 
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	for (j = IMGU_ABI_PARAM_CLASS_CONFIG;
 	     j < IMGU_ABI_PARAM_CLASS_NUM; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-			if (!ipu3_dmamap_alloc(imgu,
+			if (!imgu_dmamap_alloc(imgu,
 					       &css_pipe->binary_params_cs[j - 1][i],
 					       CSS_ABI_SIZE))
 				goto out_of_memory;
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (!ipu3_dmamap_alloc(imgu,
+		if (!imgu_dmamap_alloc(imgu,
 				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].
 				       mem[i], CSS_BDS_SIZE))
 			goto out_of_memory;
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (!ipu3_dmamap_alloc(imgu,
+		if (!imgu_dmamap_alloc(imgu,
 				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].
 				       mem[i], CSS_GDC_SIZE))
 			goto out_of_memory;
@@ -1251,14 +1251,14 @@ static int ipu3_css_binary_preallocate(struct ipu3_css *css, unsigned int pipe)
 	return 0;
 
 out_of_memory:
-	ipu3_css_binary_cleanup(css, pipe);
+	imgu_css_binary_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
 /* allocate binary-specific resources */
-static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
+static int imgu_css_binary_setup(struct imgu_css *css, unsigned int pipe)
 {
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	struct imgu_fw_info *bi = &css->fwp->binary_header[css_pipe->bindex];
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	int i, j, size;
@@ -1269,7 +1269,7 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 
 	for (j = IMGU_ABI_PARAM_CLASS_CONFIG; j < IMGU_ABI_PARAM_CLASS_NUM; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++) {
-			if (ipu3_css_dma_buffer_resize(
+			if (imgu_css_dma_buffer_resize(
 			    imgu,
 			    &css_pipe->binary_params_cs[j - 1][i],
 			    bi->info.isp.sp.mem_initializers.params[j][i].size))
@@ -1292,7 +1292,7 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel * w;
 	size = w * h * BYPC + (w / 2) * (h / 2) * BYPC * 2;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (ipu3_css_dma_buffer_resize(
+		if (imgu_css_dma_buffer_resize(
 			imgu,
 			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i],
 			size))
@@ -1313,7 +1313,7 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 	h = css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
 	size = w * ALIGN(h * 3 / 2 + 3, 2);	/* +3 for vf_pp prefetch */
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (ipu3_css_dma_buffer_resize(
+		if (imgu_css_dma_buffer_resize(
 			imgu,
 			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].mem[i],
 			size))
@@ -1322,11 +1322,11 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 	return 0;
 
 out_of_memory:
-	ipu3_css_binary_cleanup(css, pipe);
+	imgu_css_binary_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
-int ipu3_css_start_streaming(struct ipu3_css *css)
+int imgu_css_start_streaming(struct imgu_css *css)
 {
 	u32 data;
 	int r, pipe;
@@ -1335,48 +1335,48 @@ int ipu3_css_start_streaming(struct ipu3_css *css)
 		return -EPROTO;
 
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		r = ipu3_css_binary_setup(css, pipe);
+		r = imgu_css_binary_setup(css, pipe);
 		if (r < 0)
 			return r;
 	}
 
-	r = ipu3_css_hw_init(css);
+	r = imgu_css_hw_init(css);
 	if (r < 0)
 		return r;
 
-	r = ipu3_css_hw_start(css);
+	r = imgu_css_hw_start(css);
 	if (r < 0)
 		goto fail;
 
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		r = ipu3_css_pipeline_init(css, pipe);
+		r = imgu_css_pipeline_init(css, pipe);
 		if (r < 0)
 			goto fail;
 	}
 
 	css->streaming = true;
 
-	ipu3_css_hw_enable_irq(css);
+	imgu_css_hw_enable_irq(css);
 
 	/* Initialize parameters to default */
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		r = ipu3_css_set_parameters(css, pipe, NULL);
+		r = imgu_css_set_parameters(css, pipe, NULL);
 		if (r < 0)
 			goto fail;
 	}
 
-	while (!(r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_A_ID, &data)))
+	while (!(r = imgu_css_dequeue_data(css, IMGU_ABI_QUEUE_A_ID, &data)))
 		;
 	if (r != -EBUSY)
 		goto fail;
 
-	while (!(r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_B_ID, &data)))
+	while (!(r = imgu_css_dequeue_data(css, IMGU_ABI_QUEUE_B_ID, &data)))
 		;
 	if (r != -EBUSY)
 		goto fail;
 
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+		r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_START_STREAM |
 					pipe << 16);
 		if (r < 0)
@@ -1387,22 +1387,22 @@ int ipu3_css_start_streaming(struct ipu3_css *css)
 
 fail:
 	css->streaming = false;
-	ipu3_css_hw_cleanup(css);
+	imgu_css_hw_cleanup(css);
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		ipu3_css_pipeline_cleanup(css, pipe);
-		ipu3_css_binary_cleanup(css, pipe);
+		imgu_css_pipeline_cleanup(css, pipe);
+		imgu_css_binary_cleanup(css, pipe);
 	}
 
 	return r;
 }
 
-void ipu3_css_stop_streaming(struct ipu3_css *css)
+void imgu_css_stop_streaming(struct imgu_css *css)
 {
-	struct ipu3_css_buffer *b, *b0;
+	struct imgu_css_buffer *b, *b0;
 	int q, r, pipe;
 
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+		r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_STOP_STREAM);
 		if (r < 0)
 			dev_warn(css->dev, "failed on stop stream event\n");
@@ -1411,14 +1411,14 @@ void ipu3_css_stop_streaming(struct ipu3_css *css)
 	if (!css->streaming)
 		return;
 
-	ipu3_css_hw_stop(css);
+	imgu_css_hw_stop(css);
 
-	ipu3_css_hw_cleanup(css);
+	imgu_css_hw_cleanup(css);
 
 	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
-		struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+		struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
-		ipu3_css_pipeline_cleanup(css, pipe);
+		imgu_css_pipeline_cleanup(css, pipe);
 
 		spin_lock(&css_pipe->qlock);
 		for (q = 0; q < IPU3_CSS_QUEUES; q++)
@@ -1434,10 +1434,10 @@ void ipu3_css_stop_streaming(struct ipu3_css *css)
 	css->streaming = false;
 }
 
-bool ipu3_css_pipe_queue_empty(struct ipu3_css *css, unsigned int pipe)
+bool imgu_css_pipe_queue_empty(struct imgu_css *css, unsigned int pipe)
 {
 	int q;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	spin_lock(&css_pipe->qlock);
 	for (q = 0; q < IPU3_CSS_QUEUES; q++)
@@ -1447,44 +1447,44 @@ bool ipu3_css_pipe_queue_empty(struct ipu3_css *css, unsigned int pipe)
 	return (q == IPU3_CSS_QUEUES);
 }
 
-bool ipu3_css_queue_empty(struct ipu3_css *css)
+bool imgu_css_queue_empty(struct imgu_css *css)
 {
 	unsigned int pipe;
 	bool ret = 0;
 
 	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++)
-		ret &= ipu3_css_pipe_queue_empty(css, pipe);
+		ret &= imgu_css_pipe_queue_empty(css, pipe);
 
 	return ret;
 }
 
-bool ipu3_css_is_streaming(struct ipu3_css *css)
+bool imgu_css_is_streaming(struct imgu_css *css)
 {
 	return css->streaming;
 }
 
-static int ipu3_css_map_init(struct ipu3_css *css, unsigned int pipe)
+static int imgu_css_map_init(struct imgu_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	unsigned int p, q, i;
 
 	/* Allocate and map common structures with imgu hardware */
 	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
 		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
-			if (!ipu3_dmamap_alloc(imgu,
+			if (!imgu_dmamap_alloc(imgu,
 					       &css_pipe->
 					       xmem_sp_stage_ptrs[p][i],
 					       sizeof(struct imgu_abi_sp_stage)))
 				return -ENOMEM;
-			if (!ipu3_dmamap_alloc(imgu,
+			if (!imgu_dmamap_alloc(imgu,
 					       &css_pipe->
 					       xmem_isp_stage_ptrs[p][i],
 					       sizeof(struct imgu_abi_isp_stage)))
 				return -ENOMEM;
 		}
 
-	if (!ipu3_dmamap_alloc(imgu, &css_pipe->sp_ddr_ptrs,
+	if (!imgu_dmamap_alloc(imgu, &css_pipe->sp_ddr_ptrs,
 			       ALIGN(sizeof(struct imgu_abi_ddr_address_map),
 				     IMGU_ABI_ISP_DDR_WORD_BYTES)))
 		return -ENOMEM;
@@ -1493,58 +1493,58 @@ static int ipu3_css_map_init(struct ipu3_css *css, unsigned int pipe)
 		unsigned int abi_buf_num = ARRAY_SIZE(css_pipe->abi_buffers[q]);
 
 		for (i = 0; i < abi_buf_num; i++)
-			if (!ipu3_dmamap_alloc(imgu,
+			if (!imgu_dmamap_alloc(imgu,
 					       &css_pipe->abi_buffers[q][i],
 					       sizeof(struct imgu_abi_buffer)))
 				return -ENOMEM;
 	}
 
-	if (ipu3_css_binary_preallocate(css, pipe)) {
-		ipu3_css_binary_cleanup(css, pipe);
+	if (imgu_css_binary_preallocate(css, pipe)) {
+		imgu_css_binary_cleanup(css, pipe);
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void ipu3_css_pipe_cleanup(struct ipu3_css *css, unsigned int pipe)
+static void imgu_css_pipe_cleanup(struct imgu_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	unsigned int p, q, i, abi_buf_num;
 
-	ipu3_css_binary_cleanup(css, pipe);
+	imgu_css_binary_cleanup(css, pipe);
 
 	for (q = 0; q < IPU3_CSS_QUEUES; q++) {
 		abi_buf_num = ARRAY_SIZE(css_pipe->abi_buffers[q]);
 		for (i = 0; i < abi_buf_num; i++)
-			ipu3_dmamap_free(imgu, &css_pipe->abi_buffers[q][i]);
+			imgu_dmamap_free(imgu, &css_pipe->abi_buffers[q][i]);
 	}
 
 	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
 		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
-			ipu3_dmamap_free(imgu,
+			imgu_dmamap_free(imgu,
 					 &css_pipe->xmem_sp_stage_ptrs[p][i]);
-			ipu3_dmamap_free(imgu,
+			imgu_dmamap_free(imgu,
 					 &css_pipe->xmem_isp_stage_ptrs[p][i]);
 		}
 
-	ipu3_dmamap_free(imgu, &css_pipe->sp_ddr_ptrs);
+	imgu_dmamap_free(imgu, &css_pipe->sp_ddr_ptrs);
 }
 
-void ipu3_css_cleanup(struct ipu3_css *css)
+void imgu_css_cleanup(struct imgu_css *css)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int pipe;
 
-	ipu3_css_stop_streaming(css);
+	imgu_css_stop_streaming(css);
 	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++)
-		ipu3_css_pipe_cleanup(css, pipe);
-	ipu3_dmamap_free(imgu, &css->xmem_sp_group_ptrs);
-	ipu3_css_fw_cleanup(css);
+		imgu_css_pipe_cleanup(css, pipe);
+	imgu_dmamap_free(imgu, &css->xmem_sp_group_ptrs);
+	imgu_css_fw_cleanup(css);
 }
 
-int ipu3_css_init(struct device *dev, struct ipu3_css *css,
+int imgu_css_init(struct device *dev, struct imgu_css *css,
 		  void __iomem *base, int length)
 {
 	struct imgu_device *imgu = dev_get_drvdata(dev);
@@ -1556,35 +1556,35 @@ int ipu3_css_init(struct device *dev, struct ipu3_css *css,
 	css->iomem_length = length;
 
 	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++) {
-		struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+		struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 		css_pipe->vf_output_en = false;
 		spin_lock_init(&css_pipe->qlock);
 		css_pipe->bindex = IPU3_CSS_DEFAULT_BINARY;
 		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_VIDEO;
 		for (q = 0; q < IPU3_CSS_QUEUES; q++) {
-			r = ipu3_css_queue_init(&css_pipe->queue[q], NULL, 0);
+			r = imgu_css_queue_init(&css_pipe->queue[q], NULL, 0);
 			if (r)
 				return r;
 		}
-		r = ipu3_css_map_init(css, pipe);
+		r = imgu_css_map_init(css, pipe);
 		if (r) {
-			ipu3_css_cleanup(css);
+			imgu_css_cleanup(css);
 			return r;
 		}
 	}
-	if (!ipu3_dmamap_alloc(imgu, &css->xmem_sp_group_ptrs,
+	if (!imgu_dmamap_alloc(imgu, &css->xmem_sp_group_ptrs,
 			       sizeof(struct imgu_abi_sp_group)))
 		return -ENOMEM;
 
-	r = ipu3_css_fw_init(css);
+	r = imgu_css_fw_init(css);
 	if (r)
 		return r;
 
 	return 0;
 }
 
-static u32 ipu3_css_adjust(u32 res, u32 align)
+static u32 imgu_css_adjust(u32 res, u32 align)
 {
 	u32 val = max_t(u32, IPU3_CSS_MIN_RES, res);
 
@@ -1592,9 +1592,9 @@ static u32 ipu3_css_adjust(u32 res, u32 align)
 }
 
 /* Select a binary matching the required resolutions and formats */
-static int ipu3_css_find_binary(struct ipu3_css *css,
+static int imgu_css_find_binary(struct imgu_css *css,
 				unsigned int pipe,
-				struct ipu3_css_queue queue[IPU3_CSS_QUEUES],
+				struct imgu_css_queue queue[IPU3_CSS_QUEUES],
 				struct v4l2_rect rects[IPU3_CSS_RECTS])
 {
 	const int binary_nr = css->fwp->file_header.binary_nr;
@@ -1611,7 +1611,7 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
 	const char *name;
 	int i, j;
 
-	if (!ipu3_css_queue_enabled(&queue[IPU3_CSS_QUEUE_IN]))
+	if (!imgu_css_queue_enabled(&queue[IPU3_CSS_QUEUE_IN]))
 		return -EINVAL;
 
 	/* Find out the strip size boundary */
@@ -1659,7 +1659,7 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
 		    in->height > bi->info.isp.sp.input.max_height)
 			continue;
 
-		if (ipu3_css_queue_enabled(&queue[IPU3_CSS_QUEUE_OUT])) {
+		if (imgu_css_queue_enabled(&queue[IPU3_CSS_QUEUE_OUT])) {
 			if (bi->info.isp.num_output_pins <= 0)
 				continue;
 
@@ -1681,7 +1681,7 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
 				continue;
 		}
 
-		if (ipu3_css_queue_enabled(&queue[IPU3_CSS_QUEUE_VF])) {
+		if (imgu_css_queue_enabled(&queue[IPU3_CSS_QUEUE_VF])) {
 			if (bi->info.isp.num_output_pins <= 1)
 				continue;
 
@@ -1716,7 +1716,7 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
  * found binary number. May modify the given parameters if not exact match
  * is found.
  */
-int ipu3_css_fmt_try(struct ipu3_css *css,
+int imgu_css_fmt_try(struct imgu_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
 		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
 		     unsigned int pipe)
@@ -1744,7 +1744,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	struct v4l2_rect *const bds = &r[IPU3_CSS_RECT_BDS];
 	struct v4l2_rect *const env = &r[IPU3_CSS_RECT_ENVELOPE];
 	struct v4l2_rect *const gdc = &r[IPU3_CSS_RECT_GDC];
-	struct ipu3_css_queue q[IPU3_CSS_QUEUES];
+	struct imgu_css_queue q[IPU3_CSS_QUEUES];
 	struct v4l2_pix_format_mplane *const in =
 					&q[IPU3_CSS_QUEUE_IN].fmt.mpix;
 	struct v4l2_pix_format_mplane *const out =
@@ -1762,7 +1762,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 		else
 			dev_dbg(css->dev, "%s %s: (not set)\n", __func__,
 				qnames[i]);
-		if (ipu3_css_queue_init(&q[i], fmts[i],
+		if (imgu_css_queue_init(&q[i], fmts[i],
 					IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 			dev_notice(css->dev, "can not initialize queue %s\n",
 				   qnames[i]);
@@ -1785,13 +1785,13 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	}
 
 	/* Always require one input and vf only if out is also enabled */
-	if (!ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
-	    !ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
+	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
+	    !imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
 		dev_warn(css->dev, "required queues are disabled\n");
 		return -EINVAL;
 	}
 
-	if (!ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
+	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
 		out->width = in->width;
 		out->height = in->height;
 	}
@@ -1808,18 +1808,18 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 		gdc->height = out->height;
 	}
 
-	in->width   = ipu3_css_adjust(in->width, 1);
-	in->height  = ipu3_css_adjust(in->height, 1);
-	eff->width  = ipu3_css_adjust(eff->width, EFF_ALIGN_W);
-	eff->height = ipu3_css_adjust(eff->height, 1);
-	bds->width  = ipu3_css_adjust(bds->width, BDS_ALIGN_W);
-	bds->height = ipu3_css_adjust(bds->height, 1);
-	gdc->width  = ipu3_css_adjust(gdc->width, OUT_ALIGN_W);
-	gdc->height = ipu3_css_adjust(gdc->height, OUT_ALIGN_H);
-	out->width  = ipu3_css_adjust(out->width, OUT_ALIGN_W);
-	out->height = ipu3_css_adjust(out->height, OUT_ALIGN_H);
-	vf->width   = ipu3_css_adjust(vf->width, VF_ALIGN_W);
-	vf->height  = ipu3_css_adjust(vf->height, 1);
+	in->width   = imgu_css_adjust(in->width, 1);
+	in->height  = imgu_css_adjust(in->height, 1);
+	eff->width  = imgu_css_adjust(eff->width, EFF_ALIGN_W);
+	eff->height = imgu_css_adjust(eff->height, 1);
+	bds->width  = imgu_css_adjust(bds->width, BDS_ALIGN_W);
+	bds->height = imgu_css_adjust(bds->height, 1);
+	gdc->width  = imgu_css_adjust(gdc->width, OUT_ALIGN_W);
+	gdc->height = imgu_css_adjust(gdc->height, OUT_ALIGN_H);
+	out->width  = imgu_css_adjust(out->width, OUT_ALIGN_W);
+	out->height = imgu_css_adjust(out->height, OUT_ALIGN_H);
+	vf->width   = imgu_css_adjust(vf->width, VF_ALIGN_W);
+	vf->height  = imgu_css_adjust(vf->height, 1);
 
 	s = (bds->width - gdc->width) / 2 - FILTER_SIZE;
 	env->width = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
@@ -1827,7 +1827,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
 
 	css->pipes[pipe].bindex =
-		ipu3_css_find_binary(css, pipe, q, r);
+		imgu_css_find_binary(css, pipe, q, r);
 	if (css->pipes[pipe].bindex < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
 		return -EINVAL;
@@ -1839,7 +1839,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	/* Final adjustment and set back the queried formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		if (fmts[i]) {
-			if (ipu3_css_queue_init(&q[i], &q[i].fmt.mpix,
+			if (imgu_css_queue_init(&q[i], &q[i].fmt.mpix,
 						IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 				dev_err(css->dev,
 					"final resolution adjustment failed\n");
@@ -1862,7 +1862,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	return 0;
 }
 
-int ipu3_css_fmt_set(struct ipu3_css *css,
+int imgu_css_fmt_set(struct imgu_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
 		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
 		     unsigned int pipe)
@@ -1870,7 +1870,7 @@ int ipu3_css_fmt_set(struct ipu3_css *css,
 	struct v4l2_rect rect_data[IPU3_CSS_RECTS];
 	struct v4l2_rect *all_rects[IPU3_CSS_RECTS];
 	int i, r;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
 		if (rects[i])
@@ -1879,12 +1879,12 @@ int ipu3_css_fmt_set(struct ipu3_css *css,
 			memset(&rect_data[i], 0, sizeof(rect_data[i]));
 		all_rects[i] = &rect_data[i];
 	}
-	r = ipu3_css_fmt_try(css, fmts, all_rects, pipe);
+	r = imgu_css_fmt_try(css, fmts, all_rects, pipe);
 	if (r < 0)
 		return r;
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++)
-		if (ipu3_css_queue_init(&css_pipe->queue[i], fmts[i],
+		if (imgu_css_queue_init(&css_pipe->queue[i], fmts[i],
 					IPU3_CSS_QUEUE_TO_FLAGS(i)))
 			return -EINVAL;
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
@@ -1896,7 +1896,7 @@ int ipu3_css_fmt_set(struct ipu3_css *css,
 	return 0;
 }
 
-int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt)
+int imgu_css_meta_fmt_set(struct v4l2_meta_format *fmt)
 {
 	switch (fmt->dataformat) {
 	case V4L2_META_FMT_IPU3_PARAMS:
@@ -1913,27 +1913,27 @@ int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt)
 }
 
 /*
- * Queue given buffer to CSS. ipu3_css_buf_prepare() must have been first
+ * Queue given buffer to CSS. imgu_css_buf_prepare() must have been first
  * called for the buffer. May be called from interrupt context.
  * Returns 0 on success, -EBUSY if the buffer queue is full, or some other
  * code on error conditions.
  */
-int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
-		       struct ipu3_css_buffer *b)
+int imgu_css_buf_queue(struct imgu_css *css, unsigned int pipe,
+		       struct imgu_css_buffer *b)
 {
 	struct imgu_abi_buffer *abi_buf;
 	struct imgu_addr_t *buf_addr;
 	u32 data;
 	int r;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 
 	if (!css->streaming)
 		return -EPROTO;	/* CSS or buffer in wrong state */
 
-	if (b->queue >= IPU3_CSS_QUEUES || !ipu3_css_queues[b->queue].qid)
+	if (b->queue >= IPU3_CSS_QUEUES || !imgu_css_queues[b->queue].qid)
 		return -EINVAL;
 
-	b->queue_pos = ipu3_css_queue_pos(css, ipu3_css_queues[b->queue].qid,
+	b->queue_pos = imgu_css_queue_pos(css, imgu_css_queues[b->queue].qid,
 					  pipe);
 
 	if (b->queue_pos >= ARRAY_SIZE(css->pipes[pipe].abi_buffers[b->queue]))
@@ -1943,7 +1943,7 @@ int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
 	/* Fill struct abi_buffer for firmware */
 	memset(abi_buf, 0, sizeof(*abi_buf));
 
-	buf_addr = (void *)abi_buf + ipu3_css_queues[b->queue].ptr_ofs;
+	buf_addr = (void *)abi_buf + imgu_css_queues[b->queue].ptr_ofs;
 	*(imgu_addr_t *)buf_addr = b->daddr;
 
 	if (b->queue == IPU3_CSS_QUEUE_STAT_3A)
@@ -1963,14 +1963,14 @@ int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
 	b->state = IPU3_CSS_BUFFER_QUEUED;
 
 	data = css->pipes[pipe].abi_buffers[b->queue][b->queue_pos].daddr;
-	r = ipu3_css_queue_data(css, ipu3_css_queues[b->queue].qid,
+	r = imgu_css_queue_data(css, imgu_css_queues[b->queue].qid,
 				pipe, data);
 	if (r < 0)
 		goto queueing_failed;
 
 	data = IMGU_ABI_EVENT_BUFFER_ENQUEUED(pipe,
-					      ipu3_css_queues[b->queue].qid);
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe, data);
+					      imgu_css_queues[b->queue].qid);
+	r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe, data);
 	if (r < 0)
 		goto queueing_failed;
 
@@ -1992,7 +1992,7 @@ int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
  * should be called again, or -EBUSY which means that there are no more
  * buffers available. May be called from interrupt context.
  */
-struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
+struct imgu_css_buffer *imgu_css_buf_dequeue(struct imgu_css *css)
 {
 	static const unsigned char evtype_to_queue[] = {
 		[IMGU_ABI_EVTTYPE_INPUT_FRAME_DONE] = IPU3_CSS_QUEUE_IN,
@@ -2000,15 +2000,15 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 		[IMGU_ABI_EVTTYPE_VF_OUT_FRAME_DONE] = IPU3_CSS_QUEUE_VF,
 		[IMGU_ABI_EVTTYPE_3A_STATS_DONE] = IPU3_CSS_QUEUE_STAT_3A,
 	};
-	struct ipu3_css_buffer *b = ERR_PTR(-EAGAIN);
+	struct imgu_css_buffer *b = ERR_PTR(-EAGAIN);
 	u32 event, daddr;
 	int evtype, pipe, pipeid, queue, qid, r;
-	struct ipu3_css_pipe *css_pipe;
+	struct imgu_css_pipe *css_pipe;
 
 	if (!css->streaming)
 		return ERR_PTR(-EPROTO);
 
-	r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_EVENT_ID, &event);
+	r = imgu_css_dequeue_data(css, IMGU_ABI_QUEUE_EVENT_ID, &event);
 	if (r < 0)
 		return ERR_PTR(r);
 
@@ -2025,7 +2025,7 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 		pipeid = (event & IMGU_ABI_EVTTYPE_PIPEID_MASK) >>
 			IMGU_ABI_EVTTYPE_PIPEID_SHIFT;
 		queue = evtype_to_queue[evtype];
-		qid = ipu3_css_queues[queue].qid;
+		qid = imgu_css_queues[queue].qid;
 
 		if (pipe >= IMGU_MAX_PIPE_NUM) {
 			dev_err(css->dev, "Invalid pipe: %i\n", pipe);
@@ -2041,14 +2041,14 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 			"event: buffer done 0x%x queue %i pipe %i pipeid %i\n",
 			event, queue, pipe, pipeid);
 
-		r = ipu3_css_dequeue_data(css, qid, &daddr);
+		r = imgu_css_dequeue_data(css, qid, &daddr);
 		if (r < 0) {
 			dev_err(css->dev, "failed to dequeue buffer\n");
 			/* Force real error, not -EBUSY */
 			return ERR_PTR(-EIO);
 		}
 
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+		r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_BUFFER_DEQUEUED(qid));
 		if (r < 0) {
 			dev_err(css->dev, "failed to queue event\n");
@@ -2062,7 +2062,7 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 			return ERR_PTR(-EIO);
 		}
 		b = list_first_entry(&css_pipe->queue[queue].bufs,
-				     struct ipu3_css_buffer, list);
+				     struct imgu_css_buffer, list);
 		if (queue != b->queue ||
 		    daddr != css_pipe->abi_buffers
 			[b->queue][b->queue_pos].daddr) {
@@ -2090,7 +2090,7 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 			event, pipe);
 		break;
 	case IMGU_ABI_EVTTYPE_TIMER:
-		r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_EVENT_ID, &event);
+		r = imgu_css_dequeue_data(css, IMGU_ABI_QUEUE_EVENT_ID, &event);
 		if (r < 0)
 			return ERR_PTR(r);
 
@@ -2128,11 +2128,11 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
  * Return index to css->parameter_set_info which has the newly created
  * parameters or negative value on error.
  */
-int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_set_parameters(struct imgu_css *css, unsigned int pipe,
 			    struct ipu3_uapi_params *set_params)
 {
 	static const unsigned int queue_id = IMGU_ABI_QUEUE_A_ID;
-	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &css->pipes[pipe];
 	const int stage = 0;
 	const struct imgu_fw_info *bi;
 	int obgrid_size;
@@ -2144,7 +2144,7 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	struct imgu_abi_acc_param *acc = NULL;
 	struct imgu_abi_gdc_warp_param *gdc = NULL;
 	struct ipu3_uapi_obgrid_param *obgrid = NULL;
-	const struct ipu3_css_map *map;
+	const struct imgu_css_map *map;
 	void *vmem0 = NULL;
 	void *dmem0 = NULL;
 
@@ -2157,7 +2157,7 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	dev_dbg(css->dev, "%s for pipe %d", __func__, pipe);
 
 	bi = &css->fwp->binary_header[css_pipe->bindex];
-	obgrid_size = ipu3_css_fw_obgrid_size(bi);
+	obgrid_size = imgu_css_fw_obgrid_size(bi);
 	stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
 
 	/*
@@ -2165,45 +2165,45 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	 * parameters from previous buffers will be overwritten. Fix the driver
 	 * not to allow this.
 	 */
-	ipu3_css_pool_get(&css_pipe->pool.parameter_set_info);
-	param_set = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info,
+	imgu_css_pool_get(&css_pipe->pool.parameter_set_info);
+	param_set = imgu_css_pool_last(&css_pipe->pool.parameter_set_info,
 				       0)->vaddr;
 
 	/* Get a new acc only if new parameters given, or none yet */
-	map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
+	map = imgu_css_pool_last(&css_pipe->pool.acc, 0);
 	if (set_params || !map->vaddr) {
-		ipu3_css_pool_get(&css_pipe->pool.acc);
-		map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
+		imgu_css_pool_get(&css_pipe->pool.acc);
+		map = imgu_css_pool_last(&css_pipe->pool.acc, 0);
 		acc = map->vaddr;
 	}
 
 	/* Get new VMEM0 only if needed, or none yet */
 	m = IMGU_ABI_MEM_ISP_VMEM0;
-	map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
+	map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 	if (!map->vaddr || (set_params && (set_params->use.lin_vmem_params ||
 					   set_params->use.tnr3_vmem_params ||
 					   set_params->use.xnr3_vmem_params))) {
-		ipu3_css_pool_get(&css_pipe->pool.binary_params_p[m]);
-		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
+		imgu_css_pool_get(&css_pipe->pool.binary_params_p[m]);
+		map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		vmem0 = map->vaddr;
 	}
 
 	/* Get new DMEM0 only if needed, or none yet */
 	m = IMGU_ABI_MEM_ISP_DMEM0;
-	map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
+	map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 	if (!map->vaddr || (set_params && (set_params->use.tnr3_dmem_params ||
 					   set_params->use.xnr3_dmem_params))) {
-		ipu3_css_pool_get(&css_pipe->pool.binary_params_p[m]);
-		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
+		imgu_css_pool_get(&css_pipe->pool.binary_params_p[m]);
+		map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		dmem0 = map->vaddr;
 	}
 
 	/* Configure acc parameter cluster */
 	if (acc) {
 		/* get acc_old */
-		map = ipu3_css_pool_last(&css_pipe->pool.acc, 1);
+		map = imgu_css_pool_last(&css_pipe->pool.acc, 1);
 		/* user acc */
-		r = ipu3_css_cfg_acc(css, pipe, use, acc, map->vaddr,
+		r = imgu_css_cfg_acc(css, pipe, use, acc, map->vaddr,
 			set_params ? &set_params->acc_param : NULL);
 		if (r < 0)
 			goto fail;
@@ -2212,8 +2212,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	/* Configure late binding parameters */
 	if (vmem0) {
 		m = IMGU_ABI_MEM_ISP_VMEM0;
-		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
-		r = ipu3_css_cfg_vmem0(css, pipe, use, vmem0,
+		map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
+		r = imgu_css_cfg_vmem0(css, pipe, use, vmem0,
 				       map->vaddr, set_params);
 		if (r < 0)
 			goto fail;
@@ -2221,8 +2221,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 
 	if (dmem0) {
 		m = IMGU_ABI_MEM_ISP_DMEM0;
-		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
-		r = ipu3_css_cfg_dmem0(css, pipe, use, dmem0,
+		map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
+		r = imgu_css_cfg_dmem0(css, pipe, use, dmem0,
 				       map->vaddr, set_params);
 		if (r < 0)
 			goto fail;
@@ -2234,12 +2234,12 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 		unsigned int g = IPU3_CSS_RECT_GDC;
 		unsigned int e = IPU3_CSS_RECT_ENVELOPE;
 
-		map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
+		map = imgu_css_pool_last(&css_pipe->pool.gdc, 0);
 		if (!map->vaddr) {
-			ipu3_css_pool_get(&css_pipe->pool.gdc);
-			map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
+			imgu_css_pool_get(&css_pipe->pool.gdc);
+			map = imgu_css_pool_last(&css_pipe->pool.gdc, 0);
 			gdc = map->vaddr;
-			ipu3_css_cfg_gdc_table(map->vaddr,
+			imgu_css_cfg_gdc_table(map->vaddr,
 				css_pipe->aux_frames[a].bytesperline /
 				css_pipe->aux_frames[a].bytesperpixel,
 				css_pipe->aux_frames[a].height,
@@ -2252,10 +2252,10 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	}
 
 	/* Get a new obgrid only if a new obgrid is given, or none yet */
-	map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
+	map = imgu_css_pool_last(&css_pipe->pool.obgrid, 0);
 	if (!map->vaddr || (set_params && set_params->use.obgrid_param)) {
-		ipu3_css_pool_get(&css_pipe->pool.obgrid);
-		map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
+		imgu_css_pool_get(&css_pipe->pool.obgrid);
+		map = imgu_css_pool_last(&css_pipe->pool.obgrid, 0);
 		obgrid = map->vaddr;
 
 		/* Configure optical black level grid (obgrid) */
@@ -2269,30 +2269,30 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	/* Configure parameter set info, queued to `queue_id' */
 
 	memset(param_set, 0, sizeof(*param_set));
-	map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
+	map = imgu_css_pool_last(&css_pipe->pool.acc, 0);
 	param_set->mem_map.acc_cluster_params_for_sp = map->daddr;
 
-	map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
+	map = imgu_css_pool_last(&css_pipe->pool.gdc, 0);
 	param_set->mem_map.dvs_6axis_params_y = map->daddr;
 
 	for (i = 0; i < stripes; i++) {
-		map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
+		map = imgu_css_pool_last(&css_pipe->pool.obgrid, 0);
 		param_set->mem_map.obgrid_tbl[i] =
 			map->daddr + (obgrid_size / stripes) * i;
 	}
 
 	for (m = 0; m < IMGU_ABI_NUM_MEMORIES; m++) {
-		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
+		map = imgu_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		param_set->mem_map.isp_mem_param[stage][m] = map->daddr;
 	}
 
 	/* Then queue the new parameter buffer */
-	map = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info, 0);
-	r = ipu3_css_queue_data(css, queue_id, pipe, map->daddr);
+	map = imgu_css_pool_last(&css_pipe->pool.parameter_set_info, 0);
+	r = imgu_css_queue_data(css, queue_id, pipe, map->daddr);
 	if (r < 0)
 		goto fail;
 
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+	r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 				IMGU_ABI_EVENT_BUFFER_ENQUEUED(pipe,
 							       queue_id));
 	if (r < 0)
@@ -2303,12 +2303,12 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	do {
 		u32 daddr;
 
-		r = ipu3_css_dequeue_data(css, queue_id, &daddr);
+		r = imgu_css_dequeue_data(css, queue_id, &daddr);
 		if (r == -EBUSY)
 			break;
 		if (r)
 			goto fail_no_put;
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+		r = imgu_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_BUFFER_DEQUEUED
 					(queue_id));
 		if (r < 0) {
@@ -2326,19 +2326,19 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	 * parameters again later.
 	 */
 
-	ipu3_css_pool_put(&css_pipe->pool.parameter_set_info);
+	imgu_css_pool_put(&css_pipe->pool.parameter_set_info);
 	if (acc)
-		ipu3_css_pool_put(&css_pipe->pool.acc);
+		imgu_css_pool_put(&css_pipe->pool.acc);
 	if (gdc)
-		ipu3_css_pool_put(&css_pipe->pool.gdc);
+		imgu_css_pool_put(&css_pipe->pool.gdc);
 	if (obgrid)
-		ipu3_css_pool_put(&css_pipe->pool.obgrid);
+		imgu_css_pool_put(&css_pipe->pool.obgrid);
 	if (vmem0)
-		ipu3_css_pool_put(
+		imgu_css_pool_put(
 			&css_pipe->pool.binary_params_p
 			[IMGU_ABI_MEM_ISP_VMEM0]);
 	if (dmem0)
-		ipu3_css_pool_put(
+		imgu_css_pool_put(
 			&css_pipe->pool.binary_params_p
 			[IMGU_ABI_MEM_ISP_DMEM0]);
 
@@ -2346,7 +2346,7 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	return r;
 }
 
-int ipu3_css_irq_ack(struct ipu3_css *css)
+int imgu_css_irq_ack(struct imgu_css *css)
 {
 	static const int NUM_SWIRQS = 3;
 	struct imgu_fw_info *bi = &css->fwp->binary_header[css->fw_sp[0]];
diff --git a/drivers/staging/media/ipu3/ipu3-css.h b/drivers/staging/media/ipu3/ipu3-css.h
index e88d60f1a0c3..6b8bab27ab1f 100644
--- a/drivers/staging/media/ipu3/ipu3-css.h
+++ b/drivers/staging/media/ipu3/ipu3-css.h
@@ -43,7 +43,7 @@
  * The pipe id type, distinguishes the kind of pipes that
  * can be run in parallel.
  */
-enum ipu3_css_pipe_id {
+enum imgu_css_pipe_id {
 	IPU3_CSS_PIPE_ID_PREVIEW,
 	IPU3_CSS_PIPE_ID_COPY,
 	IPU3_CSS_PIPE_ID_VIDEO,
@@ -53,29 +53,29 @@ enum ipu3_css_pipe_id {
 	IPU3_CSS_PIPE_ID_NUM
 };
 
-struct ipu3_css_resolution {
+struct imgu_css_resolution {
 	u32 w;
 	u32 h;
 };
 
-enum ipu3_css_buffer_state {
+enum imgu_css_buffer_state {
 	IPU3_CSS_BUFFER_NEW,	/* Not yet queued */
 	IPU3_CSS_BUFFER_QUEUED,	/* Queued, waiting to be filled */
 	IPU3_CSS_BUFFER_DONE,	/* Finished processing, removed from queue */
 	IPU3_CSS_BUFFER_FAILED,	/* Was not processed, removed from queue */
 };
 
-struct ipu3_css_buffer {
+struct imgu_css_buffer {
 	/* Private fields: user doesn't touch */
 	dma_addr_t daddr;
 	unsigned int queue;
-	enum ipu3_css_buffer_state state;
+	enum imgu_css_buffer_state state;
 	struct list_head list;
 	u8 queue_pos;
 	unsigned int pipe;
 };
 
-struct ipu3_css_format {
+struct imgu_css_format {
 	u32 pixelformat;
 	enum v4l2_colorspace colorspace;
 	enum imgu_abi_frame_format frame_format;
@@ -89,22 +89,22 @@ struct ipu3_css_format {
 	u8 flags;
 };
 
-struct ipu3_css_queue {
+struct imgu_css_queue {
 	union {
 		struct v4l2_pix_format_mplane mpix;
 		struct v4l2_meta_format	meta;
 
 	} fmt;
-	const struct ipu3_css_format *css_fmt;
+	const struct imgu_css_format *css_fmt;
 	unsigned int width_pad;
 	struct list_head bufs;
 };
 
-struct ipu3_css_pipe {
-	enum ipu3_css_pipe_id pipe_id;
+struct imgu_css_pipe {
+	enum imgu_css_pipe_id pipe_id;
 	unsigned int bindex;
 
-	struct ipu3_css_queue queue[IPU3_CSS_QUEUES];
+	struct imgu_css_queue queue[IPU3_CSS_QUEUES];
 	struct v4l2_rect rect[IPU3_CSS_RECTS];
 
 	bool vf_output_en;
@@ -112,21 +112,21 @@ struct ipu3_css_pipe {
 	spinlock_t qlock;
 
 	/* Data structures shared with IMGU and driver, always allocated */
-	struct ipu3_css_map sp_ddr_ptrs;
-	struct ipu3_css_map xmem_sp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
+	struct imgu_css_map sp_ddr_ptrs;
+	struct imgu_css_map xmem_sp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
 					    [IMGU_ABI_MAX_STAGES];
-	struct ipu3_css_map xmem_isp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
+	struct imgu_css_map xmem_isp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
 					    [IMGU_ABI_MAX_STAGES];
 
 	/*
 	 * Data structures shared with IMGU and driver, binary specific.
 	 * PARAM_CLASS_CONFIG and PARAM_CLASS_STATE parameters.
 	 */
-	struct ipu3_css_map binary_params_cs[IMGU_ABI_PARAM_CLASS_NUM - 1]
+	struct imgu_css_map binary_params_cs[IMGU_ABI_PARAM_CLASS_NUM - 1]
 					    [IMGU_ABI_NUM_MEMORIES];
 
 	struct {
-		struct ipu3_css_map mem[IPU3_CSS_AUX_FRAMES];
+		struct imgu_css_map mem[IPU3_CSS_AUX_FRAMES];
 		unsigned int width;
 		unsigned int height;
 		unsigned int bytesperline;
@@ -134,76 +134,76 @@ struct ipu3_css_pipe {
 	} aux_frames[IPU3_CSS_AUX_FRAME_TYPES];
 
 	struct {
-		struct ipu3_css_pool parameter_set_info;
-		struct ipu3_css_pool acc;
-		struct ipu3_css_pool gdc;
-		struct ipu3_css_pool obgrid;
+		struct imgu_css_pool parameter_set_info;
+		struct imgu_css_pool acc;
+		struct imgu_css_pool gdc;
+		struct imgu_css_pool obgrid;
 		/* PARAM_CLASS_PARAM parameters for binding while streaming */
-		struct ipu3_css_pool binary_params_p[IMGU_ABI_NUM_MEMORIES];
+		struct imgu_css_pool binary_params_p[IMGU_ABI_NUM_MEMORIES];
 	} pool;
 
-	struct ipu3_css_map abi_buffers[IPU3_CSS_QUEUES]
+	struct imgu_css_map abi_buffers[IPU3_CSS_QUEUES]
 				    [IMGU_ABI_HOST2SP_BUFQ_SIZE];
 };
 
 /* IPU3 Camera Sub System structure */
-struct ipu3_css {
+struct imgu_css {
 	struct device *dev;
 	void __iomem *base;
 	const struct firmware *fw;
 	struct imgu_fw_header *fwp;
 	int iomem_length;
 	int fw_bl, fw_sp[IMGU_NUM_SP];	/* Indices of bl and SP binaries */
-	struct ipu3_css_map *binary;	/* fw binaries mapped to device */
+	struct imgu_css_map *binary;	/* fw binaries mapped to device */
 	bool streaming;		/* true when streaming is enabled */
 
-	struct ipu3_css_pipe pipes[IMGU_MAX_PIPE_NUM];
-	struct ipu3_css_map xmem_sp_group_ptrs;
+	struct imgu_css_pipe pipes[IMGU_MAX_PIPE_NUM];
+	struct imgu_css_map xmem_sp_group_ptrs;
 
 	/* enabled pipe(s) */
 	DECLARE_BITMAP(enabled_pipes, IMGU_MAX_PIPE_NUM);
 };
 
 /******************* css v4l *******************/
-int ipu3_css_init(struct device *dev, struct ipu3_css *css,
+int imgu_css_init(struct device *dev, struct imgu_css *css,
 		  void __iomem *base, int length);
-void ipu3_css_cleanup(struct ipu3_css *css);
-int ipu3_css_fmt_try(struct ipu3_css *css,
+void imgu_css_cleanup(struct imgu_css *css);
+int imgu_css_fmt_try(struct imgu_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
 		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
 		     unsigned int pipe);
-int ipu3_css_fmt_set(struct ipu3_css *css,
+int imgu_css_fmt_set(struct imgu_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
 		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
 		     unsigned int pipe);
-int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt);
-int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
-		       struct ipu3_css_buffer *b);
-struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css);
-int ipu3_css_start_streaming(struct ipu3_css *css);
-void ipu3_css_stop_streaming(struct ipu3_css *css);
-bool ipu3_css_queue_empty(struct ipu3_css *css);
-bool ipu3_css_is_streaming(struct ipu3_css *css);
-bool ipu3_css_pipe_queue_empty(struct ipu3_css *css, unsigned int pipe);
+int imgu_css_meta_fmt_set(struct v4l2_meta_format *fmt);
+int imgu_css_buf_queue(struct imgu_css *css, unsigned int pipe,
+		       struct imgu_css_buffer *b);
+struct imgu_css_buffer *imgu_css_buf_dequeue(struct imgu_css *css);
+int imgu_css_start_streaming(struct imgu_css *css);
+void imgu_css_stop_streaming(struct imgu_css *css);
+bool imgu_css_queue_empty(struct imgu_css *css);
+bool imgu_css_is_streaming(struct imgu_css *css);
+bool imgu_css_pipe_queue_empty(struct imgu_css *css, unsigned int pipe);
 
 /******************* css hw *******************/
-int ipu3_css_set_powerup(struct device *dev, void __iomem *base);
-void ipu3_css_set_powerdown(struct device *dev, void __iomem *base);
-int ipu3_css_irq_ack(struct ipu3_css *css);
+int imgu_css_set_powerup(struct device *dev, void __iomem *base);
+void imgu_css_set_powerdown(struct device *dev, void __iomem *base);
+int imgu_css_irq_ack(struct imgu_css *css);
 
 /******************* set parameters ************/
-int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
+int imgu_css_set_parameters(struct imgu_css *css, unsigned int pipe,
 			    struct ipu3_uapi_params *set_params);
 
 /******************* auxiliary helpers *******************/
-static inline enum ipu3_css_buffer_state
-ipu3_css_buf_state(struct ipu3_css_buffer *b)
+static inline enum imgu_css_buffer_state
+imgu_css_buf_state(struct imgu_css_buffer *b)
 {
 	return b->state;
 }
 
 /* Initialize given buffer. May be called several times. */
-static inline void ipu3_css_buf_init(struct ipu3_css_buffer *b,
+static inline void imgu_css_buf_init(struct imgu_css_buffer *b,
 				     unsigned int queue, dma_addr_t daddr)
 {
 	b->state = IPU3_CSS_BUFFER_NEW;
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.c b/drivers/staging/media/ipu3/ipu3-dmamap.c
index 5bed01d5b8df..d978a00e1e0b 100644
--- a/drivers/staging/media/ipu3/ipu3-dmamap.c
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -15,9 +15,9 @@
 #include "ipu3-dmamap.h"
 
 /*
- * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
+ * Free a buffer allocated by imgu_dmamap_alloc_buffer()
  */
-static void ipu3_dmamap_free_buffer(struct page **pages,
+static void imgu_dmamap_free_buffer(struct page **pages,
 				    size_t size)
 {
 	int count = size >> PAGE_SHIFT;
@@ -31,7 +31,7 @@ static void ipu3_dmamap_free_buffer(struct page **pages,
  * Based on the implementation of __iommu_dma_alloc_pages()
  * defined in drivers/iommu/dma-iommu.c
  */
-static struct page **ipu3_dmamap_alloc_buffer(size_t size,
+static struct page **imgu_dmamap_alloc_buffer(size_t size,
 					      unsigned long order_mask,
 					      gfp_t gfp)
 {
@@ -74,7 +74,7 @@ static struct page **ipu3_dmamap_alloc_buffer(size_t size,
 			__free_pages(page, order);
 		}
 		if (!page) {
-			ipu3_dmamap_free_buffer(pages, i << PAGE_SHIFT);
+			imgu_dmamap_free_buffer(pages, i << PAGE_SHIFT);
 			return NULL;
 		}
 		count -= order_size;
@@ -86,7 +86,7 @@ static struct page **ipu3_dmamap_alloc_buffer(size_t size,
 }
 
 /**
- * ipu3_dmamap_alloc - allocate and map a buffer into KVA
+ * imgu_dmamap_alloc - allocate and map a buffer into KVA
  * @imgu: struct device pointer
  * @map: struct to store mapping variables
  * @len: size required
@@ -95,7 +95,7 @@ static struct page **ipu3_dmamap_alloc_buffer(size_t size,
  *  KVA on success
  *  %NULL on failure
  */
-void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
+void *imgu_dmamap_alloc(struct imgu_device *imgu, struct imgu_css_map *map,
 			size_t len)
 {
 	unsigned long shift = iova_shift(&imgu->iova_domain);
@@ -114,7 +114,7 @@ void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
 	if (!iova)
 		return NULL;
 
-	pages = ipu3_dmamap_alloc_buffer(size, alloc_sizes >> PAGE_SHIFT,
+	pages = imgu_dmamap_alloc_buffer(size, alloc_sizes >> PAGE_SHIFT,
 					 GFP_KERNEL);
 	if (!pages)
 		goto out_free_iova;
@@ -122,7 +122,7 @@ void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
 	/* Call IOMMU driver to setup pgt */
 	iovaddr = iova_dma_addr(&imgu->iova_domain, iova);
 	for (i = 0; i < size / PAGE_SIZE; ++i) {
-		rval = ipu3_mmu_map(imgu->mmu, iovaddr,
+		rval = imgu_mmu_map(imgu->mmu, iovaddr,
 				    page_to_phys(pages[i]), PAGE_SIZE);
 		if (rval)
 			goto out_unmap;
@@ -153,8 +153,8 @@ void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
 	vunmap(map->vma->addr);
 
 out_unmap:
-	ipu3_dmamap_free_buffer(pages, size);
-	ipu3_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+	imgu_dmamap_free_buffer(pages, size);
+	imgu_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
 		       i * PAGE_SIZE);
 	map->vma = NULL;
 
@@ -164,7 +164,7 @@ void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
 	return NULL;
 }
 
-void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map)
+void imgu_dmamap_unmap(struct imgu_device *imgu, struct imgu_css_map *map)
 {
 	struct iova *iova;
 
@@ -173,16 +173,16 @@ void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map)
 	if (WARN_ON(!iova))
 		return;
 
-	ipu3_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+	imgu_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
 		       iova_size(iova) << iova_shift(&imgu->iova_domain));
 
 	__free_iova(&imgu->iova_domain, iova);
 }
 
 /*
- * Counterpart of ipu3_dmamap_alloc
+ * Counterpart of imgu_dmamap_alloc
  */
-void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map)
+void imgu_dmamap_free(struct imgu_device *imgu, struct imgu_css_map *map)
 {
 	struct vm_struct *area = map->vma;
 
@@ -192,18 +192,18 @@ void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map)
 	if (!map->vaddr)
 		return;
 
-	ipu3_dmamap_unmap(imgu, map);
+	imgu_dmamap_unmap(imgu, map);
 
 	if (WARN_ON(!area) || WARN_ON(!area->pages))
 		return;
 
-	ipu3_dmamap_free_buffer(area->pages, map->size);
+	imgu_dmamap_free_buffer(area->pages, map->size);
 	vunmap(map->vaddr);
 	map->vaddr = NULL;
 }
 
-int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
-		       int nents, struct ipu3_css_map *map)
+int imgu_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
+		       int nents, struct imgu_css_map *map)
 {
 	unsigned long shift = iova_shift(&imgu->iova_domain);
 	struct scatterlist *sg;
@@ -233,7 +233,7 @@ int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
 	dev_dbg(&imgu->pci_dev->dev, "dmamap: iova low pfn %lu, high pfn %lu\n",
 		iova->pfn_lo, iova->pfn_hi);
 
-	if (ipu3_mmu_map_sg(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+	if (imgu_mmu_map_sg(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
 			    sglist, nents) < size)
 		goto out_fail;
 
@@ -249,7 +249,7 @@ int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
 	return -EFAULT;
 }
 
-int ipu3_dmamap_init(struct imgu_device *imgu)
+int imgu_dmamap_init(struct imgu_device *imgu)
 {
 	unsigned long order, base_pfn;
 	int ret = iova_cache_get();
@@ -264,7 +264,7 @@ int ipu3_dmamap_init(struct imgu_device *imgu)
 	return 0;
 }
 
-void ipu3_dmamap_exit(struct imgu_device *imgu)
+void imgu_dmamap_exit(struct imgu_device *imgu)
 {
 	put_iova_domain(&imgu->iova_domain);
 	iova_cache_put();
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.h b/drivers/staging/media/ipu3/ipu3-dmamap.h
index b9d224a33273..9db513b3d603 100644
--- a/drivers/staging/media/ipu3/ipu3-dmamap.h
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.h
@@ -8,15 +8,15 @@
 struct imgu_device;
 struct scatterlist;
 
-void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
+void *imgu_dmamap_alloc(struct imgu_device *imgu, struct imgu_css_map *map,
 			size_t len);
-void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map);
+void imgu_dmamap_free(struct imgu_device *imgu, struct imgu_css_map *map);
 
-int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
-		       int nents, struct ipu3_css_map *map);
-void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map);
+int imgu_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
+		       int nents, struct imgu_css_map *map);
+void imgu_dmamap_unmap(struct imgu_device *imgu, struct imgu_css_map *map);
 
-int ipu3_dmamap_init(struct imgu_device *imgu);
-void ipu3_dmamap_exit(struct imgu_device *imgu);
+int imgu_dmamap_init(struct imgu_device *imgu);
+void imgu_dmamap_exit(struct imgu_device *imgu);
 
 #endif
diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index b9f209541f78..cd2038b22b55 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -48,7 +48,7 @@
 #define REG_GP_HALT		(IMGU_REG_BASE + 0x5dc)
 #define REG_GP_HALTED		(IMGU_REG_BASE + 0x5e0)
 
-struct ipu3_mmu {
+struct imgu_mmu {
 	struct device *dev;
 	void __iomem *base;
 	/* protect access to l2pts, l1pt */
@@ -63,28 +63,28 @@ struct ipu3_mmu {
 	u32 **l2pts;
 	u32 *l1pt;
 
-	struct ipu3_mmu_info geometry;
+	struct imgu_mmu_info geometry;
 };
 
-static inline struct ipu3_mmu *to_ipu3_mmu(struct ipu3_mmu_info *info)
+static inline struct imgu_mmu *to_imgu_mmu(struct imgu_mmu_info *info)
 {
-	return container_of(info, struct ipu3_mmu, geometry);
+	return container_of(info, struct imgu_mmu, geometry);
 }
 
 /**
- * ipu3_mmu_tlb_invalidate - invalidate translation look-aside buffer
+ * imgu_mmu_tlb_invalidate - invalidate translation look-aside buffer
  * @mmu: MMU to perform the invalidate operation on
  *
  * This function invalidates the whole TLB. Must be called when the hardware
  * is powered on.
  */
-static void ipu3_mmu_tlb_invalidate(struct ipu3_mmu *mmu)
+static void imgu_mmu_tlb_invalidate(struct imgu_mmu *mmu)
 {
 	writel(TLB_INVALIDATE, mmu->base + REG_TLB_INVALIDATE);
 }
 
-static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
-				    void (*func)(struct ipu3_mmu *mmu))
+static void call_if_imgu_is_powered(struct imgu_mmu *mmu,
+				    void (*func)(struct imgu_mmu *mmu))
 {
 	if (!pm_runtime_get_if_in_use(mmu->dev))
 		return;
@@ -94,14 +94,14 @@ static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
 }
 
 /**
- * ipu3_mmu_set_halt - set CIO gate halt bit
+ * imgu_mmu_set_halt - set CIO gate halt bit
  * @mmu: MMU to set the CIO gate bit in.
  * @halt: Desired state of the gate bit.
  *
  * This function sets the CIO gate bit that controls whether external memory
  * accesses are allowed. Must be called when the hardware is powered on.
  */
-static void ipu3_mmu_set_halt(struct ipu3_mmu *mmu, bool halt)
+static void imgu_mmu_set_halt(struct imgu_mmu *mmu, bool halt)
 {
 	int ret;
 	u32 val;
@@ -116,12 +116,12 @@ static void ipu3_mmu_set_halt(struct ipu3_mmu *mmu, bool halt)
 }
 
 /**
- * ipu3_mmu_alloc_page_table - allocate a pre-filled page table
+ * imgu_mmu_alloc_page_table - allocate a pre-filled page table
  * @pteval: Value to initialize for page table entries with.
  *
  * Return: Pointer to allocated page table or NULL on failure.
  */
-static u32 *ipu3_mmu_alloc_page_table(u32 pteval)
+static u32 *imgu_mmu_alloc_page_table(u32 pteval)
 {
 	u32 *pt;
 	int pte;
@@ -139,10 +139,10 @@ static u32 *ipu3_mmu_alloc_page_table(u32 pteval)
 }
 
 /**
- * ipu3_mmu_free_page_table - free page table
+ * imgu_mmu_free_page_table - free page table
  * @pt: Page table to free.
  */
-static void ipu3_mmu_free_page_table(u32 *pt)
+static void imgu_mmu_free_page_table(u32 *pt)
 {
 	set_memory_wb((unsigned long int)pt, IPU3_PT_ORDER);
 	free_page((unsigned long)pt);
@@ -168,7 +168,7 @@ static inline void address_to_pte_idx(unsigned long iova, u32 *l1pt_idx,
 		*l1pt_idx = iova & IPU3_L1PT_MASK;
 }
 
-static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu *mmu, u32 l1pt_idx)
+static u32 *imgu_mmu_get_l2pt(struct imgu_mmu *mmu, u32 l1pt_idx)
 {
 	unsigned long flags;
 	u32 *l2pt, *new_l2pt;
@@ -182,7 +182,7 @@ static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu *mmu, u32 l1pt_idx)
 
 	spin_unlock_irqrestore(&mmu->lock, flags);
 
-	new_l2pt = ipu3_mmu_alloc_page_table(mmu->dummy_page_pteval);
+	new_l2pt = imgu_mmu_alloc_page_table(mmu->dummy_page_pteval);
 	if (!new_l2pt)
 		return NULL;
 
@@ -193,7 +193,7 @@ static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu *mmu, u32 l1pt_idx)
 
 	l2pt = mmu->l2pts[l1pt_idx];
 	if (l2pt) {
-		ipu3_mmu_free_page_table(new_l2pt);
+		imgu_mmu_free_page_table(new_l2pt);
 		goto done;
 	}
 
@@ -208,7 +208,7 @@ static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu *mmu, u32 l1pt_idx)
 	return l2pt;
 }
 
-static int __ipu3_mmu_map(struct ipu3_mmu *mmu, unsigned long iova,
+static int __imgu_mmu_map(struct imgu_mmu *mmu, unsigned long iova,
 			  phys_addr_t paddr)
 {
 	u32 l1pt_idx, l2pt_idx;
@@ -220,7 +220,7 @@ static int __ipu3_mmu_map(struct ipu3_mmu *mmu, unsigned long iova,
 
 	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
 
-	l2pt = ipu3_mmu_get_l2pt(mmu, l1pt_idx);
+	l2pt = imgu_mmu_get_l2pt(mmu, l1pt_idx);
 	if (!l2pt)
 		return -ENOMEM;
 
@@ -242,7 +242,7 @@ static int __ipu3_mmu_map(struct ipu3_mmu *mmu, unsigned long iova,
  * The following four functions are implemented based on iommu.c
  * drivers/iommu/iommu.c/iommu_pgsize().
  */
-static size_t ipu3_mmu_pgsize(unsigned long pgsize_bitmap,
+static size_t imgu_mmu_pgsize(unsigned long pgsize_bitmap,
 			      unsigned long addr_merge, size_t size)
 {
 	unsigned int pgsize_idx;
@@ -276,10 +276,10 @@ static size_t ipu3_mmu_pgsize(unsigned long pgsize_bitmap,
 }
 
 /* drivers/iommu/iommu.c/iommu_map() */
-int ipu3_mmu_map(struct ipu3_mmu_info *info, unsigned long iova,
+int imgu_mmu_map(struct imgu_mmu_info *info, unsigned long iova,
 		 phys_addr_t paddr, size_t size)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 	unsigned int min_pagesz;
 	int ret = 0;
 
@@ -301,13 +301,13 @@ int ipu3_mmu_map(struct ipu3_mmu_info *info, unsigned long iova,
 		iova, &paddr, size);
 
 	while (size) {
-		size_t pgsize = ipu3_mmu_pgsize(mmu->geometry.pgsize_bitmap,
+		size_t pgsize = imgu_mmu_pgsize(mmu->geometry.pgsize_bitmap,
 						iova | paddr, size);
 
 		dev_dbg(mmu->dev, "mapping: iova 0x%lx pa %pa pgsize 0x%zx\n",
 			iova, &paddr, pgsize);
 
-		ret = __ipu3_mmu_map(mmu, iova, paddr);
+		ret = __imgu_mmu_map(mmu, iova, paddr);
 		if (ret)
 			break;
 
@@ -316,16 +316,16 @@ int ipu3_mmu_map(struct ipu3_mmu_info *info, unsigned long iova,
 		size -= pgsize;
 	}
 
-	call_if_ipu3_is_powered(mmu, ipu3_mmu_tlb_invalidate);
+	call_if_imgu_is_powered(mmu, imgu_mmu_tlb_invalidate);
 
 	return ret;
 }
 
 /* drivers/iommu/iommu.c/default_iommu_map_sg() */
-size_t ipu3_mmu_map_sg(struct ipu3_mmu_info *info, unsigned long iova,
+size_t imgu_mmu_map_sg(struct imgu_mmu_info *info, unsigned long iova,
 		       struct scatterlist *sg, unsigned int nents)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 	struct scatterlist *s;
 	size_t s_length, mapped = 0;
 	unsigned int i, min_pagesz;
@@ -345,25 +345,25 @@ size_t ipu3_mmu_map_sg(struct ipu3_mmu_info *info, unsigned long iova,
 		if (i == nents - 1 && !IS_ALIGNED(s->length, min_pagesz))
 			s_length = PAGE_ALIGN(s->length);
 
-		ret = ipu3_mmu_map(info, iova + mapped, phys, s_length);
+		ret = imgu_mmu_map(info, iova + mapped, phys, s_length);
 		if (ret)
 			goto out_err;
 
 		mapped += s_length;
 	}
 
-	call_if_ipu3_is_powered(mmu, ipu3_mmu_tlb_invalidate);
+	call_if_imgu_is_powered(mmu, imgu_mmu_tlb_invalidate);
 
 	return mapped;
 
 out_err:
 	/* undo mappings already done */
-	ipu3_mmu_unmap(info, iova, mapped);
+	imgu_mmu_unmap(info, iova, mapped);
 
 	return 0;
 }
 
-static size_t __ipu3_mmu_unmap(struct ipu3_mmu *mmu,
+static size_t __imgu_mmu_unmap(struct imgu_mmu *mmu,
 			       unsigned long iova, size_t size)
 {
 	u32 l1pt_idx, l2pt_idx;
@@ -395,10 +395,10 @@ static size_t __ipu3_mmu_unmap(struct ipu3_mmu *mmu,
 }
 
 /* drivers/iommu/iommu.c/iommu_unmap() */
-size_t ipu3_mmu_unmap(struct ipu3_mmu_info *info, unsigned long iova,
+size_t imgu_mmu_unmap(struct imgu_mmu_info *info, unsigned long iova,
 		      size_t size)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
 
@@ -423,10 +423,10 @@ size_t ipu3_mmu_unmap(struct ipu3_mmu_info *info, unsigned long iova,
 	 * or we hit an area that isn't mapped.
 	 */
 	while (unmapped < size) {
-		size_t pgsize = ipu3_mmu_pgsize(mmu->geometry.pgsize_bitmap,
+		size_t pgsize = imgu_mmu_pgsize(mmu->geometry.pgsize_bitmap,
 						iova, size - unmapped);
 
-		unmapped_page = __ipu3_mmu_unmap(mmu, iova, pgsize);
+		unmapped_page = __imgu_mmu_unmap(mmu, iova, pgsize);
 		if (!unmapped_page)
 			break;
 
@@ -437,20 +437,20 @@ size_t ipu3_mmu_unmap(struct ipu3_mmu_info *info, unsigned long iova,
 		unmapped += unmapped_page;
 	}
 
-	call_if_ipu3_is_powered(mmu, ipu3_mmu_tlb_invalidate);
+	call_if_imgu_is_powered(mmu, imgu_mmu_tlb_invalidate);
 
 	return unmapped;
 }
 
 /**
- * ipu3_mmu_init() - initialize IPU3 MMU block
+ * imgu_mmu_init() - initialize IPU3 MMU block
  * @base:	IOMEM base of hardware registers.
  *
  * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
  */
-struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
+struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base)
 {
-	struct ipu3_mmu *mmu;
+	struct imgu_mmu *mmu;
 	u32 pteval;
 
 	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
@@ -462,7 +462,7 @@ struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
 	spin_lock_init(&mmu->lock);
 
 	/* Disallow external memory access when having no valid page tables. */
-	ipu3_mmu_set_halt(mmu, true);
+	imgu_mmu_set_halt(mmu, true);
 
 	/*
 	 * The MMU does not have a "valid" bit, so we have to use a dummy
@@ -478,7 +478,7 @@ struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
 	 * Allocate a dummy L2 page table with all entries pointing to
 	 * the dummy page.
 	 */
-	mmu->dummy_l2pt = ipu3_mmu_alloc_page_table(pteval);
+	mmu->dummy_l2pt = imgu_mmu_alloc_page_table(pteval);
 	if (!mmu->dummy_l2pt)
 		goto fail_dummy_page;
 	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->dummy_l2pt));
@@ -493,14 +493,14 @@ struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
 		goto fail_l2pt;
 
 	/* Allocate the L1 page table. */
-	mmu->l1pt = ipu3_mmu_alloc_page_table(mmu->dummy_l2pt_pteval);
+	mmu->l1pt = imgu_mmu_alloc_page_table(mmu->dummy_l2pt_pteval);
 	if (!mmu->l1pt)
 		goto fail_l2pts;
 
 	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
 	writel(pteval, mmu->base + REG_L1_PHYS);
-	ipu3_mmu_tlb_invalidate(mmu);
-	ipu3_mmu_set_halt(mmu, false);
+	imgu_mmu_tlb_invalidate(mmu);
+	imgu_mmu_set_halt(mmu, false);
 
 	mmu->geometry.aperture_start = 0;
 	mmu->geometry.aperture_end = DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
@@ -511,7 +511,7 @@ struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
 fail_l2pts:
 	vfree(mmu->l2pts);
 fail_l2pt:
-	ipu3_mmu_free_page_table(mmu->dummy_l2pt);
+	imgu_mmu_free_page_table(mmu->dummy_l2pt);
 fail_dummy_page:
 	free_page((unsigned long)mmu->dummy_page);
 fail_group:
@@ -521,41 +521,41 @@ struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base)
 }
 
 /**
- * ipu3_mmu_exit() - clean up IPU3 MMU block
+ * imgu_mmu_exit() - clean up IPU3 MMU block
  * @mmu: IPU3 MMU private data
  */
-void ipu3_mmu_exit(struct ipu3_mmu_info *info)
+void imgu_mmu_exit(struct imgu_mmu_info *info)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 
 	/* We are going to free our page tables, no more memory access. */
-	ipu3_mmu_set_halt(mmu, true);
-	ipu3_mmu_tlb_invalidate(mmu);
+	imgu_mmu_set_halt(mmu, true);
+	imgu_mmu_tlb_invalidate(mmu);
 
-	ipu3_mmu_free_page_table(mmu->l1pt);
+	imgu_mmu_free_page_table(mmu->l1pt);
 	vfree(mmu->l2pts);
-	ipu3_mmu_free_page_table(mmu->dummy_l2pt);
+	imgu_mmu_free_page_table(mmu->dummy_l2pt);
 	free_page((unsigned long)mmu->dummy_page);
 	kfree(mmu);
 }
 
-void ipu3_mmu_suspend(struct ipu3_mmu_info *info)
+void imgu_mmu_suspend(struct imgu_mmu_info *info)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 
-	ipu3_mmu_set_halt(mmu, true);
+	imgu_mmu_set_halt(mmu, true);
 }
 
-void ipu3_mmu_resume(struct ipu3_mmu_info *info)
+void imgu_mmu_resume(struct imgu_mmu_info *info)
 {
-	struct ipu3_mmu *mmu = to_ipu3_mmu(info);
+	struct imgu_mmu *mmu = to_imgu_mmu(info);
 	u32 pteval;
 
-	ipu3_mmu_set_halt(mmu, true);
+	imgu_mmu_set_halt(mmu, true);
 
 	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
 	writel(pteval, mmu->base + REG_L1_PHYS);
 
-	ipu3_mmu_tlb_invalidate(mmu);
-	ipu3_mmu_set_halt(mmu, false);
+	imgu_mmu_tlb_invalidate(mmu);
+	imgu_mmu_set_halt(mmu, false);
 }
diff --git a/drivers/staging/media/ipu3/ipu3-mmu.h b/drivers/staging/media/ipu3/ipu3-mmu.h
index 8fe63b4c6e1c..fa58827eb19c 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.h
+++ b/drivers/staging/media/ipu3/ipu3-mmu.h
@@ -6,13 +6,13 @@
 #define __IPU3_MMU_H
 
 /**
- * struct ipu3_mmu_info - Describes mmu geometry
+ * struct imgu_mmu_info - Describes mmu geometry
  *
  * @aperture_start:	First address that can be mapped
  * @aperture_end:	Last address that can be mapped
  * @pgsize_bitmap:	Bitmap of page sizes in use
  */
-struct ipu3_mmu_info {
+struct imgu_mmu_info {
 	dma_addr_t aperture_start;
 	dma_addr_t aperture_end;
 	unsigned long pgsize_bitmap;
@@ -21,15 +21,15 @@ struct ipu3_mmu_info {
 struct device;
 struct scatterlist;
 
-struct ipu3_mmu_info *ipu3_mmu_init(struct device *parent, void __iomem *base);
-void ipu3_mmu_exit(struct ipu3_mmu_info *info);
-void ipu3_mmu_suspend(struct ipu3_mmu_info *info);
-void ipu3_mmu_resume(struct ipu3_mmu_info *info);
+struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base);
+void imgu_mmu_exit(struct imgu_mmu_info *info);
+void imgu_mmu_suspend(struct imgu_mmu_info *info);
+void imgu_mmu_resume(struct imgu_mmu_info *info);
 
-int ipu3_mmu_map(struct ipu3_mmu_info *info, unsigned long iova,
+int imgu_mmu_map(struct imgu_mmu_info *info, unsigned long iova,
 		 phys_addr_t paddr, size_t size);
-size_t ipu3_mmu_unmap(struct ipu3_mmu_info *info, unsigned long iova,
+size_t imgu_mmu_unmap(struct imgu_mmu_info *info, unsigned long iova,
 		      size_t size);
-size_t ipu3_mmu_map_sg(struct ipu3_mmu_info *info, unsigned long iova,
+size_t imgu_mmu_map_sg(struct imgu_mmu_info *info, unsigned long iova,
 		       struct scatterlist *sg, unsigned int nents);
 #endif
diff --git a/drivers/staging/media/ipu3/ipu3-tables.c b/drivers/staging/media/ipu3/ipu3-tables.c
index 334517987eba..3a3730bd4395 100644
--- a/drivers/staging/media/ipu3/ipu3-tables.c
+++ b/drivers/staging/media/ipu3/ipu3-tables.c
@@ -5,8 +5,8 @@
 
 #define X					0	/*  Don't care value */
 
-const struct ipu3_css_bds_config
-			ipu3_css_bds_configs[IMGU_BDS_CONFIG_LEN] = { {
+const struct imgu_css_bds_config
+			imgu_css_bds_configs[IMGU_BDS_CONFIG_LEN] = { {
 	/* Scale factor 32 / (32 + 0) = 1 */
 	.hor_phase_arr = {
 		.even = { { 0, 0, 64, 6, 0, 0, 0 } },
@@ -9015,7 +9015,7 @@ const struct ipu3_css_bds_config
 	.ver_ds_en = 1
 } };
 
-const s32 ipu3_css_downscale_4taps[IMGU_SCALER_DOWNSCALE_4TAPS_LEN] = {
+const s32 imgu_css_downscale_4taps[IMGU_SCALER_DOWNSCALE_4TAPS_LEN] = {
 	IMGU_SCALER_FP * -0.000000000000000,
 	IMGU_SCALER_FP * -0.000249009327023,
 	IMGU_SCALER_FP * -0.001022241683322,
@@ -9146,7 +9146,7 @@ const s32 ipu3_css_downscale_4taps[IMGU_SCALER_DOWNSCALE_4TAPS_LEN] = {
 	IMGU_SCALER_FP * -0.000249009327023
 };
 
-const s32 ipu3_css_downscale_2taps[IMGU_SCALER_DOWNSCALE_2TAPS_LEN] = {
+const s32 imgu_css_downscale_2taps[IMGU_SCALER_DOWNSCALE_2TAPS_LEN] = {
 	IMGU_SCALER_FP * 0.074300676367033,
 	IMGU_SCALER_FP * 0.094030234498392,
 	IMGU_SCALER_FP * 0.115522859526596,
@@ -9214,7 +9214,7 @@ const s32 ipu3_css_downscale_2taps[IMGU_SCALER_DOWNSCALE_2TAPS_LEN] = {
 };
 
 /* settings for Geometric Distortion Correction */
-const s16 ipu3_css_gdc_lut[4][256] = { {
+const s16 imgu_css_gdc_lut[4][256] = { {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -2, -2, -2,
 	-2, -3, -3, -3, -4, -4, -4, -5, -5, -5, -6, -6, -7, -7, -7, -8, -8,
 	-9, -9, -10, -10, -11, -11, -12, -12, -13, -13, -14, -14, -15, -15,
@@ -9292,7 +9292,7 @@ const s16 ipu3_css_gdc_lut[4][256] = { {
 	-1, 0, 1, 0, 0, 0, 0, 0, 0, 0
 } };
 
-const struct ipu3_css_xnr3_vmem_defaults ipu3_css_xnr3_vmem_defaults = {
+const struct imgu_css_xnr3_vmem_defaults imgu_css_xnr3_vmem_defaults = {
 	.x = {
 		1024, 1164, 1320, 1492, 1680, 1884, 2108, 2352,
 		2616, 2900, 3208, 3540, 3896, 4276, 4684, 5120
@@ -9311,7 +9311,7 @@ const struct ipu3_css_xnr3_vmem_defaults ipu3_css_xnr3_vmem_defaults = {
 };
 
 /* settings for Bayer Noise Reduction */
-const struct ipu3_uapi_bnr_static_config ipu3_css_bnr_defaults = {
+const struct ipu3_uapi_bnr_static_config imgu_css_bnr_defaults = {
 	{ 16, 16, 16, 16 },			/* wb_gains */
 	{ 16, 16, 16, 16 },			/* wb_gains_thr */
 	{ 0, X, 8, 6, X, 14 },			/* thr_coeffs */
@@ -9327,18 +9327,18 @@ const struct ipu3_uapi_bnr_static_config ipu3_css_bnr_defaults = {
 	{ 8, 4, 4, X, 8, X, 1, 1, 1, 1 },	/* dn_detect_ctrl */
 };
 
-const struct ipu3_uapi_dm_config ipu3_css_dm_defaults = {
+const struct ipu3_uapi_dm_config imgu_css_dm_defaults = {
 	1, 1, 1, X, X, 8, X, 7, X, 8, X, 8, X, 4, X
 };
 
-const struct ipu3_uapi_ccm_mat_config ipu3_css_ccm_defaults = {
+const struct ipu3_uapi_ccm_mat_config imgu_css_ccm_defaults = {
 	 9775, -2671,  1087, 0,
 	-1071,  8303,   815, 0,
 	  -23, -7887, 16103, 0
 };
 
 /* settings for Gamma correction */
-const struct ipu3_uapi_gamma_corr_lut ipu3_css_gamma_lut = { {
+const struct ipu3_uapi_gamma_corr_lut imgu_css_gamma_lut = { {
 	63, 79, 95, 111, 127, 143, 159, 175, 191, 207, 223, 239, 255, 271, 287,
 	303, 319, 335, 351, 367, 383, 399, 415, 431, 447, 463, 479, 495, 511,
 	527, 543, 559, 575, 591, 607, 623, 639, 655, 671, 687, 703, 719, 735,
@@ -9362,13 +9362,13 @@ const struct ipu3_uapi_gamma_corr_lut ipu3_css_gamma_lut = { {
 	7807, 7871, 7935, 7999, 8063, 8127, 8191
 } };
 
-const struct ipu3_uapi_csc_mat_config ipu3_css_csc_defaults = {
+const struct ipu3_uapi_csc_mat_config imgu_css_csc_defaults = {
 	 4898,  9617,  1867, 0,
 	-2410, -4732,  7143, 0,
 	10076, -8437, -1638, 0
 };
 
-const struct ipu3_uapi_cds_params ipu3_css_cds_defaults = {
+const struct ipu3_uapi_cds_params imgu_css_cds_defaults = {
 	1, 3, 3, 1,
 	1, 3, 3, 1,
 	4, X,					/* ds_nf */
@@ -9376,7 +9376,7 @@ const struct ipu3_uapi_cds_params ipu3_css_cds_defaults = {
 	0, X					/* uv_bin_output */
 };
 
-const struct ipu3_uapi_shd_config_static ipu3_css_shd_defaults = {
+const struct ipu3_uapi_shd_config_static imgu_css_shd_defaults = {
 	.grid = {
 		.width = 73,
 		.height = 55,
@@ -9397,7 +9397,7 @@ const struct ipu3_uapi_shd_config_static ipu3_css_shd_defaults = {
 	},
 };
 
-const struct ipu3_uapi_yuvp1_iefd_config ipu3_css_iefd_defaults = {
+const struct ipu3_uapi_yuvp1_iefd_config imgu_css_iefd_defaults = {
 	.units = {
 		.cu_1 = { 0, 150, 7, 0 },
 		.cu_ed = { 7, 110, 244, X, 307, 409, 511, X,
@@ -9436,17 +9436,17 @@ const struct ipu3_uapi_yuvp1_iefd_config ipu3_css_iefd_defaults = {
 		    { 1, X, 2, X,  8, X } },
 };
 
-const struct ipu3_uapi_yuvp1_yds_config ipu3_css_yds_defaults = {
+const struct ipu3_uapi_yuvp1_yds_config imgu_css_yds_defaults = {
 	0, 1, 1, 0, 0, 1, 1, 0, 2, X, 0, X
 };
 
-const struct ipu3_uapi_yuvp1_chnr_config ipu3_css_chnr_defaults = {
+const struct ipu3_uapi_yuvp1_chnr_config imgu_css_chnr_defaults = {
 	.coring = { 0, X, 0, X },
 	.sense_gain = { 6, 6, 6, X, 4, 4, 4, X },
 	.iir_fir = { 8, X, 12, X, 0, 256 - 127, X },
 };
 
-const struct ipu3_uapi_yuvp1_y_ee_nr_config ipu3_css_y_ee_nr_defaults = {
+const struct ipu3_uapi_yuvp1_y_ee_nr_config imgu_css_y_ee_nr_defaults = {
 	.lpf = { 4, X, 8, X, 16, X,  0 },
 	.sense = { 8191, X, 0, X, 8191, X, 0, X },
 	.gain = { 8, X, 0, X, 8, X, 0, X },
@@ -9457,7 +9457,7 @@ const struct ipu3_uapi_yuvp1_y_ee_nr_config ipu3_css_y_ee_nr_defaults = {
 };
 
 const struct ipu3_uapi_yuvp2_tcc_gain_pcwl_lut_static_config
-					ipu3_css_tcc_gain_pcwl_lut = { {
+					imgu_css_tcc_gain_pcwl_lut = { {
 	1024, 1032, 1040, 1048, 1057, 1065, 1073, 1081, 1089, 1097, 1105, 1113,
 	1122, 1130, 1138, 1146, 1154, 1162, 1170, 1178, 1187, 1195, 1203, 1211,
 	1219, 1227, 1235, 1243, 1252, 1260, 1268, 1276, 1284, 1292, 1300, 1308,
@@ -9483,12 +9483,12 @@ const struct ipu3_uapi_yuvp2_tcc_gain_pcwl_lut_static_config
 } };
 
 const struct ipu3_uapi_yuvp2_tcc_r_sqr_lut_static_config
-					ipu3_css_tcc_r_sqr_lut = { {
+					imgu_css_tcc_r_sqr_lut = { {
 	32, 44, 64, 92, 128, 180, 256, 364, 512, 628, 724, 808, 888,
 	956, 1024, 1088, 1144, 1200, 1256, 1304, 1356, 1404, 1448
 } };
 
-const struct imgu_abi_anr_config ipu3_css_anr_defaults = {
+const struct imgu_abi_anr_config imgu_css_anr_defaults = {
 	.transform = {
 		.adaptive_treshhold_en = 1,
 		.alpha = { { 13, 13, 13, 13, 0, 0, 0, 0},
@@ -9545,7 +9545,7 @@ const struct imgu_abi_anr_config ipu3_css_anr_defaults = {
 };
 
 /* frame settings for Auto White Balance */
-const struct ipu3_uapi_awb_fr_config_s ipu3_css_awb_fr_defaults = {
+const struct ipu3_uapi_awb_fr_config_s imgu_css_awb_fr_defaults = {
 	.grid_cfg = {
 		.width = 16,
 		.height = 16,
@@ -9560,7 +9560,7 @@ const struct ipu3_uapi_awb_fr_config_s ipu3_css_awb_fr_defaults = {
 };
 
 /* settings for Auto Exposure */
-const struct ipu3_uapi_ae_grid_config ipu3_css_ae_grid_defaults = {
+const struct ipu3_uapi_ae_grid_config imgu_css_ae_grid_defaults = {
 	.width = 16,
 	.height = 16,
 	.block_width_log2 = 3,
@@ -9571,13 +9571,13 @@ const struct ipu3_uapi_ae_grid_config ipu3_css_ae_grid_defaults = {
 };
 
 /* settings for Auto Exposure color correction matrix */
-const struct ipu3_uapi_ae_ccm ipu3_css_ae_ccm_defaults = {
+const struct ipu3_uapi_ae_ccm imgu_css_ae_ccm_defaults = {
 	256, 256, 256, 256,		/* gain_gr/r/b/gb */
 	.mat = { 128, 0, 0, 0, 0, 128, 0, 0, 0, 0, 128, 0, 0, 0, 0, 128 },
 };
 
 /* settings for Auto Focus */
-const struct ipu3_uapi_af_config_s ipu3_css_af_defaults = {
+const struct ipu3_uapi_af_config_s imgu_css_af_defaults = {
 	.filter_config = {
 		{ 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 128 }, 0,
 		{ 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 128 }, 0,
@@ -9595,7 +9595,7 @@ const struct ipu3_uapi_af_config_s ipu3_css_af_defaults = {
 };
 
 /* settings for Auto White Balance */
-const struct ipu3_uapi_awb_config_s ipu3_css_awb_defaults = {
+const struct ipu3_uapi_awb_config_s imgu_css_awb_defaults = {
 	8191, 8191, 8191, 8191 |	/* rgbs_thr_gr/r/gb/b */
 	IPU3_UAPI_AWB_RGBS_THR_B_EN | IPU3_UAPI_AWB_RGBS_THR_B_INCL_SAT,
 	.grid = {
diff --git a/drivers/staging/media/ipu3/ipu3-tables.h b/drivers/staging/media/ipu3/ipu3-tables.h
index 6563782cbd22..a1bf3286f380 100644
--- a/drivers/staging/media/ipu3/ipu3-tables.h
+++ b/drivers/staging/media/ipu3/ipu3-tables.h
@@ -19,7 +19,7 @@
 #define IMGU_GDC_LUT_UNIT		4
 #define IMGU_GDC_LUT_LEN		256
 
-struct ipu3_css_bds_config {
+struct imgu_css_bds_config {
 	struct imgu_abi_bds_phase_arr hor_phase_arr;
 	struct imgu_abi_bds_phase_arr ver_phase_arr;
 	struct imgu_abi_bds_ptrn_arr ptrn_arr;
@@ -28,39 +28,39 @@ struct ipu3_css_bds_config {
 	u8 ver_ds_en;
 };
 
-struct ipu3_css_xnr3_vmem_defaults {
+struct imgu_css_xnr3_vmem_defaults {
 	s16 x[IMGU_XNR3_VMEM_LUT_LEN];
 	s16 a[IMGU_XNR3_VMEM_LUT_LEN];
 	s16 b[IMGU_XNR3_VMEM_LUT_LEN];
 	s16 c[IMGU_XNR3_VMEM_LUT_LEN];
 };
 
-extern const struct ipu3_css_bds_config
-			ipu3_css_bds_configs[IMGU_BDS_CONFIG_LEN];
-extern const s32 ipu3_css_downscale_4taps[IMGU_SCALER_DOWNSCALE_4TAPS_LEN];
-extern const s32 ipu3_css_downscale_2taps[IMGU_SCALER_DOWNSCALE_2TAPS_LEN];
-extern const s16 ipu3_css_gdc_lut[IMGU_GDC_LUT_UNIT][IMGU_GDC_LUT_LEN];
-extern const struct ipu3_css_xnr3_vmem_defaults ipu3_css_xnr3_vmem_defaults;
-extern const struct ipu3_uapi_bnr_static_config ipu3_css_bnr_defaults;
-extern const struct ipu3_uapi_dm_config ipu3_css_dm_defaults;
-extern const struct ipu3_uapi_ccm_mat_config ipu3_css_ccm_defaults;
-extern const struct ipu3_uapi_gamma_corr_lut ipu3_css_gamma_lut;
-extern const struct ipu3_uapi_csc_mat_config ipu3_css_csc_defaults;
-extern const struct ipu3_uapi_cds_params ipu3_css_cds_defaults;
-extern const struct ipu3_uapi_shd_config_static ipu3_css_shd_defaults;
-extern const struct ipu3_uapi_yuvp1_iefd_config ipu3_css_iefd_defaults;
-extern const struct ipu3_uapi_yuvp1_yds_config ipu3_css_yds_defaults;
-extern const struct ipu3_uapi_yuvp1_chnr_config ipu3_css_chnr_defaults;
-extern const struct ipu3_uapi_yuvp1_y_ee_nr_config ipu3_css_y_ee_nr_defaults;
+extern const struct imgu_css_bds_config
+			imgu_css_bds_configs[IMGU_BDS_CONFIG_LEN];
+extern const s32 imgu_css_downscale_4taps[IMGU_SCALER_DOWNSCALE_4TAPS_LEN];
+extern const s32 imgu_css_downscale_2taps[IMGU_SCALER_DOWNSCALE_2TAPS_LEN];
+extern const s16 imgu_css_gdc_lut[IMGU_GDC_LUT_UNIT][IMGU_GDC_LUT_LEN];
+extern const struct imgu_css_xnr3_vmem_defaults imgu_css_xnr3_vmem_defaults;
+extern const struct ipu3_uapi_bnr_static_config imgu_css_bnr_defaults;
+extern const struct ipu3_uapi_dm_config imgu_css_dm_defaults;
+extern const struct ipu3_uapi_ccm_mat_config imgu_css_ccm_defaults;
+extern const struct ipu3_uapi_gamma_corr_lut imgu_css_gamma_lut;
+extern const struct ipu3_uapi_csc_mat_config imgu_css_csc_defaults;
+extern const struct ipu3_uapi_cds_params imgu_css_cds_defaults;
+extern const struct ipu3_uapi_shd_config_static imgu_css_shd_defaults;
+extern const struct ipu3_uapi_yuvp1_iefd_config imgu_css_iefd_defaults;
+extern const struct ipu3_uapi_yuvp1_yds_config imgu_css_yds_defaults;
+extern const struct ipu3_uapi_yuvp1_chnr_config imgu_css_chnr_defaults;
+extern const struct ipu3_uapi_yuvp1_y_ee_nr_config imgu_css_y_ee_nr_defaults;
 extern const struct ipu3_uapi_yuvp2_tcc_gain_pcwl_lut_static_config
-						ipu3_css_tcc_gain_pcwl_lut;
+						imgu_css_tcc_gain_pcwl_lut;
 extern const struct ipu3_uapi_yuvp2_tcc_r_sqr_lut_static_config
-						ipu3_css_tcc_r_sqr_lut;
-extern const struct imgu_abi_anr_config ipu3_css_anr_defaults;
-extern const struct ipu3_uapi_awb_fr_config_s ipu3_css_awb_fr_defaults;
-extern const struct ipu3_uapi_ae_grid_config ipu3_css_ae_grid_defaults;
-extern const struct ipu3_uapi_ae_ccm ipu3_css_ae_ccm_defaults;
-extern const struct ipu3_uapi_af_config_s ipu3_css_af_defaults;
-extern const struct ipu3_uapi_awb_config_s ipu3_css_awb_defaults;
+						imgu_css_tcc_r_sqr_lut;
+extern const struct imgu_abi_anr_config imgu_css_anr_defaults;
+extern const struct ipu3_uapi_awb_fr_config_s imgu_css_awb_fr_defaults;
+extern const struct ipu3_uapi_ae_grid_config imgu_css_ae_grid_defaults;
+extern const struct ipu3_uapi_ae_ccm imgu_css_ae_ccm_defaults;
+extern const struct ipu3_uapi_af_config_s imgu_css_af_defaults;
+extern const struct ipu3_uapi_awb_config_s imgu_css_awb_defaults;
 
 #endif
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index e758a650ad2b..9c0352b193a7 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -15,7 +15,7 @@
 #define IPU3_RUNNING_MODE_VIDEO		0
 #define IPU3_RUNNING_MODE_STILL		1
 
-static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+static int imgu_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
 							struct imgu_v4l2_subdev,
@@ -50,7 +50,7 @@ static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	return 0;
 }
 
-static int ipu3_subdev_s_stream(struct v4l2_subdev *sd, int enable)
+static int imgu_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	int i;
 	unsigned int node;
@@ -63,7 +63,7 @@ static int ipu3_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 	struct device *dev = &imgu->pci_dev->dev;
 	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
 	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
-	struct ipu3_css_pipe *css_pipe = &imgu->css.pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	dev_dbg(dev, "%s %d for pipe %d", __func__, enable, pipe);
@@ -107,7 +107,7 @@ static int ipu3_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 	rects[IPU3_CSS_RECT_BDS] = &imgu_sd->rect.bds;
 	rects[IPU3_CSS_RECT_GDC] = &imgu_sd->rect.gdc;
 
-	r = ipu3_css_fmt_set(&imgu->css, fmts, rects, pipe);
+	r = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 	if (r) {
 		dev_err(dev, "failed to set initial formats pipe %d with (%d)",
 			pipe, r);
@@ -119,7 +119,7 @@ static int ipu3_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int ipu3_subdev_get_fmt(struct v4l2_subdev *sd,
+static int imgu_subdev_get_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
@@ -143,7 +143,7 @@ static int ipu3_subdev_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ipu3_subdev_set_fmt(struct v4l2_subdev *sd,
+static int imgu_subdev_set_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
@@ -189,7 +189,7 @@ static int ipu3_subdev_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ipu3_subdev_get_selection(struct v4l2_subdev *sd,
+static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
@@ -222,7 +222,7 @@ static int ipu3_subdev_get_selection(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ipu3_subdev_set_selection(struct v4l2_subdev *sd,
+static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
@@ -263,7 +263,7 @@ static int ipu3_subdev_set_selection(struct v4l2_subdev *sd,
 
 /******************** media_entity_operations ********************/
 
-static int ipu3_link_setup(struct media_entity *entity,
+static int imgu_link_setup(struct media_entity *entity,
 			   const struct media_pad *local,
 			   const struct media_pad *remote, u32 flags)
 {
@@ -302,7 +302,7 @@ static int ipu3_link_setup(struct media_entity *entity,
 
 /******************** vb2_ops ********************/
 
-static int ipu3_vb2_buf_init(struct vb2_buffer *vb)
+static int imgu_vb2_buf_init(struct vb2_buffer *vb)
 {
 	struct sg_table *sg = vb2_dma_sg_plane_desc(vb, 0);
 	struct imgu_device *imgu = vb2_get_drv_priv(vb->vb2_queue);
@@ -315,11 +315,11 @@ static int ipu3_vb2_buf_init(struct vb2_buffer *vb)
 	if (queue == IPU3_CSS_QUEUE_PARAMS)
 		return 0;
 
-	return ipu3_dmamap_map_sg(imgu, sg->sgl, sg->nents, &buf->map);
+	return imgu_dmamap_map_sg(imgu, sg->sgl, sg->nents, &buf->map);
 }
 
 /* Called when each buffer is freed */
-static void ipu3_vb2_buf_cleanup(struct vb2_buffer *vb)
+static void imgu_vb2_buf_cleanup(struct vb2_buffer *vb)
 {
 	struct imgu_device *imgu = vb2_get_drv_priv(vb->vb2_queue);
 	struct imgu_buffer *buf = container_of(vb,
@@ -331,11 +331,11 @@ static void ipu3_vb2_buf_cleanup(struct vb2_buffer *vb)
 	if (queue == IPU3_CSS_QUEUE_PARAMS)
 		return;
 
-	ipu3_dmamap_unmap(imgu, &buf->map);
+	imgu_dmamap_unmap(imgu, &buf->map);
 }
 
 /* Transfer buffer ownership to me */
-static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
+static void imgu_vb2_buf_queue(struct vb2_buffer *vb)
 {
 	struct imgu_device *imgu = vb2_get_drv_priv(vb->vb2_queue);
 	struct imgu_video_device *node =
@@ -361,7 +361,7 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 			vb2_set_plane_payload(vb, 0, payload);
 		}
 		if (payload >= need_bytes)
-			r = ipu3_css_set_parameters(&imgu->css, pipe,
+			r = imgu_css_set_parameters(&imgu->css, pipe,
 						    vb2_plane_vaddr(vb, 0));
 		buf->flags = V4L2_BUF_FLAG_DONE;
 		vb2_buffer_done(vb, r == 0 ? VB2_BUF_STATE_DONE
@@ -372,7 +372,7 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 						       vid_buf.vbb.vb2_buf);
 
 		mutex_lock(&imgu->lock);
-		ipu3_css_buf_init(&buf->css_buf, queue, buf->map.daddr);
+		imgu_css_buf_init(&buf->css_buf, queue, buf->map.daddr);
 		list_add_tail(&buf->vid_buf.list,
 			      &node->buffers);
 		mutex_unlock(&imgu->lock);
@@ -388,7 +388,7 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 
 }
 
-static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
+static int imgu_vb2_queue_setup(struct vb2_queue *vq,
 				unsigned int *num_buffers,
 				unsigned int *num_planes,
 				unsigned int sizes[],
@@ -425,7 +425,7 @@ static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
 }
 
 /* Check if all enabled video nodes are streaming, exception ignored */
-static bool ipu3_all_nodes_streaming(struct imgu_device *imgu,
+static bool imgu_all_nodes_streaming(struct imgu_device *imgu,
 				     struct imgu_video_device *except)
 {
 	unsigned int i, pipe, p;
@@ -454,11 +454,11 @@ static bool ipu3_all_nodes_streaming(struct imgu_device *imgu,
 	return true;
 }
 
-static void ipu3_return_all_buffers(struct imgu_device *imgu,
+static void imgu_return_all_buffers(struct imgu_device *imgu,
 				    struct imgu_video_device *node,
 				    enum vb2_buffer_state state)
 {
-	struct ipu3_vb2_buffer *b, *b0;
+	struct imgu_vb2_buffer *b, *b0;
 
 	/* Return all buffers */
 	mutex_lock(&imgu->lock);
@@ -469,7 +469,7 @@ static void ipu3_return_all_buffers(struct imgu_device *imgu,
 	mutex_unlock(&imgu->lock);
 }
 
-static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+static int imgu_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct imgu_media_pipe *imgu_pipe;
 	struct imgu_device *imgu = vb2_get_drv_priv(vq);
@@ -500,7 +500,7 @@ static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 		goto fail_return_bufs;
 
 
-	if (!ipu3_all_nodes_streaming(imgu, node))
+	if (!imgu_all_nodes_streaming(imgu, node))
 		return 0;
 
 	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM) {
@@ -521,12 +521,12 @@ static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 fail_stop_pipeline:
 	media_pipeline_stop(&node->vdev.entity);
 fail_return_bufs:
-	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_QUEUED);
+	imgu_return_all_buffers(imgu, node, VB2_BUF_STATE_QUEUED);
 
 	return r;
 }
 
-static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
+static void imgu_vb2_stop_streaming(struct vb2_queue *vq)
 {
 	struct imgu_media_pipe *imgu_pipe;
 	struct imgu_device *imgu = vb2_get_drv_priv(vq);
@@ -547,7 +547,7 @@ static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
 			"failed to stop subdev streaming\n");
 
 	/* Was this the first node with streaming disabled? */
-	if (imgu->streaming && ipu3_all_nodes_streaming(imgu, node)) {
+	if (imgu->streaming && imgu_all_nodes_streaming(imgu, node)) {
 		/* Yes, really stop streaming now */
 		dev_dbg(dev, "IMGU streaming is ready to stop");
 		r = imgu_s_stream(imgu, false);
@@ -555,7 +555,7 @@ static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
 			imgu->streaming = false;
 	}
 
-	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
+	imgu_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
 	media_pipeline_stop(&node->vdev.entity);
 }
 
@@ -566,13 +566,13 @@ static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
 #define DEF_VID_CAPTURE	0
 #define DEF_VID_OUTPUT	1
 
-struct ipu3_fmt {
+struct imgu_fmt {
 	u32	fourcc;
 	u16	type; /* VID_CAPTURE or VID_OUTPUT not both */
 };
 
 /* format descriptions for capture and preview */
-static const struct ipu3_fmt formats[] = {
+static const struct imgu_fmt formats[] = {
 	{ V4L2_PIX_FMT_NV12, VID_CAPTURE },
 	{ V4L2_PIX_FMT_IPU3_SGRBG10, VID_OUTPUT },
 	{ V4L2_PIX_FMT_IPU3_SBGGR10, VID_OUTPUT },
@@ -581,7 +581,7 @@ static const struct ipu3_fmt formats[] = {
 };
 
 /* Find the first matched format, return default if not found */
-static const struct ipu3_fmt *find_format(struct v4l2_format *f, u32 type)
+static const struct imgu_fmt *find_format(struct v4l2_format *f, u32 type)
 {
 	unsigned int i;
 
@@ -595,10 +595,10 @@ static const struct ipu3_fmt *find_format(struct v4l2_format *f, u32 type)
 				     &formats[DEF_VID_OUTPUT];
 }
 
-static int ipu3_vidioc_querycap(struct file *file, void *fh,
+static int imgu_vidioc_querycap(struct file *file, void *fh,
 				struct v4l2_capability *cap)
 {
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 
 	strscpy(cap->driver, IMGU_NAME, sizeof(cap->driver));
 	strscpy(cap->card, IMGU_NAME, sizeof(cap->card));
@@ -646,10 +646,10 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 }
 
 /* Propagate forward always the format from the CIO2 subdev */
-static int ipu3_vidioc_g_fmt(struct file *file, void *fh,
+static int imgu_vidioc_g_fmt(struct file *file, void *fh,
 			     struct v4l2_format *f)
 {
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 
 	f->fmt = node->vdev_fmt.fmt;
 
@@ -670,7 +670,7 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	struct v4l2_mbus_framefmt pad_fmt;
 	unsigned int i, css_q;
 	int r;
-	struct ipu3_css_pipe *css_pipe = &imgu->css.pipes[pipe];
+	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
 
@@ -736,9 +736,9 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		return -EINVAL;
 
 	if (try)
-		r = ipu3_css_fmt_try(&imgu->css, fmts, rects, pipe);
+		r = imgu_css_fmt_try(&imgu->css, fmts, rects, pipe);
 	else
-		r = ipu3_css_fmt_set(&imgu->css, fmts, rects, pipe);
+		r = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
 	/* r is the binary number in the firmware blob */
 	if (r < 0)
@@ -752,10 +752,10 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	return 0;
 }
 
-static int ipu3_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
+static int imgu_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
-	const struct ipu3_fmt *fmt;
+	const struct imgu_fmt *fmt;
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		fmt = find_format(f, VID_CAPTURE);
@@ -772,58 +772,58 @@ static int ipu3_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	return 0;
 }
 
-static int ipu3_vidioc_try_fmt(struct file *file, void *fh,
+static int imgu_vidioc_try_fmt(struct file *file, void *fh,
 			       struct v4l2_format *f)
 {
 	struct imgu_device *imgu = video_drvdata(file);
 	struct device *dev = &imgu->pci_dev->dev;
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	int r;
 
 	dev_dbg(dev, "%s [%ux%u] for node %d\n", __func__,
 		pix_mp->width, pix_mp->height, node->id);
 
-	r = ipu3_try_fmt(file, fh, f);
+	r = imgu_try_fmt(file, fh, f);
 	if (r)
 		return r;
 
 	return imgu_fmt(imgu, node->pipe, node->id, f, true);
 }
 
-static int ipu3_vidioc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
+static int imgu_vidioc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct imgu_device *imgu = video_drvdata(file);
 	struct device *dev = &imgu->pci_dev->dev;
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	int r;
 
 	dev_dbg(dev, "%s [%ux%u] for node %d\n", __func__,
 		pix_mp->width, pix_mp->height, node->id);
 
-	r = ipu3_try_fmt(file, fh, f);
+	r = imgu_try_fmt(file, fh, f);
 	if (r)
 		return r;
 
 	return imgu_fmt(imgu, node->pipe, node->id, f, false);
 }
 
-struct ipu3_meta_fmt {
+struct imgu_meta_fmt {
 	__u32 fourcc;
 	char *name;
 };
 
 /* From drivers/media/v4l2-core/v4l2-ioctl.c */
-static const struct ipu3_meta_fmt meta_fmts[] = {
+static const struct imgu_meta_fmt meta_fmts[] = {
 	{ V4L2_META_FMT_IPU3_PARAMS, "IPU3 processing parameters" },
 	{ V4L2_META_FMT_IPU3_STAT_3A, "IPU3 3A statistics" },
 };
 
-static int ipu3_meta_enum_format(struct file *file, void *fh,
+static int imgu_meta_enum_format(struct file *file, void *fh,
 				 struct v4l2_fmtdesc *fmt)
 {
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 	unsigned int i = fmt->type == V4L2_BUF_TYPE_META_OUTPUT ? 0 : 1;
 
 	/* Each node is dedicated to only one meta format */
@@ -836,10 +836,10 @@ static int ipu3_meta_enum_format(struct file *file, void *fh,
 	return 0;
 }
 
-static int ipu3_vidioc_g_meta_fmt(struct file *file, void *fh,
+static int imgu_vidioc_g_meta_fmt(struct file *file, void *fh,
 				  struct v4l2_format *f)
 {
-	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct imgu_video_device *node = file_to_intel_imgu_node(file);
 
 	if (f->type != node->vbq.type)
 		return -EINVAL;
@@ -849,7 +849,7 @@ static int ipu3_vidioc_g_meta_fmt(struct file *file, void *fh,
 	return 0;
 }
 
-static int ipu3_vidioc_enum_input(struct file *file, void *fh,
+static int imgu_vidioc_enum_input(struct file *file, void *fh,
 				  struct v4l2_input *input)
 {
 	if (input->index > 0)
@@ -860,19 +860,19 @@ static int ipu3_vidioc_enum_input(struct file *file, void *fh,
 	return 0;
 }
 
-static int ipu3_vidioc_g_input(struct file *file, void *fh, unsigned int *input)
+static int imgu_vidioc_g_input(struct file *file, void *fh, unsigned int *input)
 {
 	*input = 0;
 
 	return 0;
 }
 
-static int ipu3_vidioc_s_input(struct file *file, void *fh, unsigned int input)
+static int imgu_vidioc_s_input(struct file *file, void *fh, unsigned int input)
 {
 	return input == 0 ? 0 : -EINVAL;
 }
 
-static int ipu3_vidioc_enum_output(struct file *file, void *fh,
+static int imgu_vidioc_enum_output(struct file *file, void *fh,
 				   struct v4l2_output *output)
 {
 	if (output->index > 0)
@@ -883,7 +883,7 @@ static int ipu3_vidioc_enum_output(struct file *file, void *fh,
 	return 0;
 }
 
-static int ipu3_vidioc_g_output(struct file *file, void *fh,
+static int imgu_vidioc_g_output(struct file *file, void *fh,
 				unsigned int *output)
 {
 	*output = 0;
@@ -891,7 +891,7 @@ static int ipu3_vidioc_g_output(struct file *file, void *fh,
 	return 0;
 }
 
-static int ipu3_vidioc_s_output(struct file *file, void *fh,
+static int imgu_vidioc_s_output(struct file *file, void *fh,
 				unsigned int output)
 {
 	return output == 0 ? 0 : -EINVAL;
@@ -899,54 +899,54 @@ static int ipu3_vidioc_s_output(struct file *file, void *fh,
 
 /******************** function pointers ********************/
 
-static struct v4l2_subdev_internal_ops ipu3_subdev_internal_ops = {
-	.open = ipu3_subdev_open,
+static struct v4l2_subdev_internal_ops imgu_subdev_internal_ops = {
+	.open = imgu_subdev_open,
 };
 
-static const struct v4l2_subdev_core_ops ipu3_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops imgu_subdev_core_ops = {
 	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
 	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
-static const struct v4l2_subdev_video_ops ipu3_subdev_video_ops = {
-	.s_stream = ipu3_subdev_s_stream,
+static const struct v4l2_subdev_video_ops imgu_subdev_video_ops = {
+	.s_stream = imgu_subdev_s_stream,
 };
 
-static const struct v4l2_subdev_pad_ops ipu3_subdev_pad_ops = {
+static const struct v4l2_subdev_pad_ops imgu_subdev_pad_ops = {
 	.link_validate = v4l2_subdev_link_validate_default,
-	.get_fmt = ipu3_subdev_get_fmt,
-	.set_fmt = ipu3_subdev_set_fmt,
-	.get_selection = ipu3_subdev_get_selection,
-	.set_selection = ipu3_subdev_set_selection,
+	.get_fmt = imgu_subdev_get_fmt,
+	.set_fmt = imgu_subdev_set_fmt,
+	.get_selection = imgu_subdev_get_selection,
+	.set_selection = imgu_subdev_set_selection,
 };
 
-static const struct v4l2_subdev_ops ipu3_subdev_ops = {
-	.core = &ipu3_subdev_core_ops,
-	.video = &ipu3_subdev_video_ops,
-	.pad = &ipu3_subdev_pad_ops,
+static const struct v4l2_subdev_ops imgu_subdev_ops = {
+	.core = &imgu_subdev_core_ops,
+	.video = &imgu_subdev_video_ops,
+	.pad = &imgu_subdev_pad_ops,
 };
 
-static const struct media_entity_operations ipu3_media_ops = {
-	.link_setup = ipu3_link_setup,
+static const struct media_entity_operations imgu_media_ops = {
+	.link_setup = imgu_link_setup,
 	.link_validate = v4l2_subdev_link_validate,
 };
 
 /****************** vb2_ops of the Q ********************/
 
-static const struct vb2_ops ipu3_vb2_ops = {
-	.buf_init = ipu3_vb2_buf_init,
-	.buf_cleanup = ipu3_vb2_buf_cleanup,
-	.buf_queue = ipu3_vb2_buf_queue,
-	.queue_setup = ipu3_vb2_queue_setup,
-	.start_streaming = ipu3_vb2_start_streaming,
-	.stop_streaming = ipu3_vb2_stop_streaming,
+static const struct vb2_ops imgu_vb2_ops = {
+	.buf_init = imgu_vb2_buf_init,
+	.buf_cleanup = imgu_vb2_buf_cleanup,
+	.buf_queue = imgu_vb2_buf_queue,
+	.queue_setup = imgu_vb2_queue_setup,
+	.start_streaming = imgu_vb2_start_streaming,
+	.stop_streaming = imgu_vb2_stop_streaming,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
 };
 
 /****************** v4l2_file_operations *****************/
 
-static const struct v4l2_file_operations ipu3_v4l2_fops = {
+static const struct v4l2_file_operations imgu_v4l2_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.open = v4l2_fh_open,
 	.release = vb2_fop_release,
@@ -956,26 +956,26 @@ static const struct v4l2_file_operations ipu3_v4l2_fops = {
 
 /******************** v4l2_ioctl_ops ********************/
 
-static const struct v4l2_ioctl_ops ipu3_v4l2_ioctl_ops = {
-	.vidioc_querycap = ipu3_vidioc_querycap,
+static const struct v4l2_ioctl_ops imgu_v4l2_ioctl_ops = {
+	.vidioc_querycap = imgu_vidioc_querycap,
 
 	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap_mplane = ipu3_vidioc_g_fmt,
-	.vidioc_s_fmt_vid_cap_mplane = ipu3_vidioc_s_fmt,
-	.vidioc_try_fmt_vid_cap_mplane = ipu3_vidioc_try_fmt,
+	.vidioc_g_fmt_vid_cap_mplane = imgu_vidioc_g_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = imgu_vidioc_s_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = imgu_vidioc_try_fmt,
 
 	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out,
-	.vidioc_g_fmt_vid_out_mplane = ipu3_vidioc_g_fmt,
-	.vidioc_s_fmt_vid_out_mplane = ipu3_vidioc_s_fmt,
-	.vidioc_try_fmt_vid_out_mplane = ipu3_vidioc_try_fmt,
+	.vidioc_g_fmt_vid_out_mplane = imgu_vidioc_g_fmt,
+	.vidioc_s_fmt_vid_out_mplane = imgu_vidioc_s_fmt,
+	.vidioc_try_fmt_vid_out_mplane = imgu_vidioc_try_fmt,
 
-	.vidioc_enum_output = ipu3_vidioc_enum_output,
-	.vidioc_g_output = ipu3_vidioc_g_output,
-	.vidioc_s_output = ipu3_vidioc_s_output,
+	.vidioc_enum_output = imgu_vidioc_enum_output,
+	.vidioc_g_output = imgu_vidioc_g_output,
+	.vidioc_s_output = imgu_vidioc_s_output,
 
-	.vidioc_enum_input = ipu3_vidioc_enum_input,
-	.vidioc_g_input = ipu3_vidioc_g_input,
-	.vidioc_s_input = ipu3_vidioc_s_input,
+	.vidioc_enum_input = imgu_vidioc_enum_input,
+	.vidioc_g_input = imgu_vidioc_g_input,
+	.vidioc_s_input = imgu_vidioc_s_input,
 
 	/* buffer queue management */
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
@@ -989,20 +989,20 @@ static const struct v4l2_ioctl_ops ipu3_v4l2_ioctl_ops = {
 	.vidioc_expbuf = vb2_ioctl_expbuf,
 };
 
-static const struct v4l2_ioctl_ops ipu3_v4l2_meta_ioctl_ops = {
-	.vidioc_querycap = ipu3_vidioc_querycap,
+static const struct v4l2_ioctl_ops imgu_v4l2_meta_ioctl_ops = {
+	.vidioc_querycap = imgu_vidioc_querycap,
 
 	/* meta capture */
-	.vidioc_enum_fmt_meta_cap = ipu3_meta_enum_format,
-	.vidioc_g_fmt_meta_cap = ipu3_vidioc_g_meta_fmt,
-	.vidioc_s_fmt_meta_cap = ipu3_vidioc_g_meta_fmt,
-	.vidioc_try_fmt_meta_cap = ipu3_vidioc_g_meta_fmt,
+	.vidioc_enum_fmt_meta_cap = imgu_meta_enum_format,
+	.vidioc_g_fmt_meta_cap = imgu_vidioc_g_meta_fmt,
+	.vidioc_s_fmt_meta_cap = imgu_vidioc_g_meta_fmt,
+	.vidioc_try_fmt_meta_cap = imgu_vidioc_g_meta_fmt,
 
 	/* meta output */
-	.vidioc_enum_fmt_meta_out = ipu3_meta_enum_format,
-	.vidioc_g_fmt_meta_out = ipu3_vidioc_g_meta_fmt,
-	.vidioc_s_fmt_meta_out = ipu3_vidioc_g_meta_fmt,
-	.vidioc_try_fmt_meta_out = ipu3_vidioc_g_meta_fmt,
+	.vidioc_enum_fmt_meta_out = imgu_meta_enum_format,
+	.vidioc_g_fmt_meta_out = imgu_vidioc_g_meta_fmt,
+	.vidioc_s_fmt_meta_out = imgu_vidioc_g_meta_fmt,
+	.vidioc_try_fmt_meta_out = imgu_vidioc_g_meta_fmt,
 
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs = vb2_ioctl_create_bufs,
@@ -1015,7 +1015,7 @@ static const struct v4l2_ioctl_ops ipu3_v4l2_meta_ioctl_ops = {
 	.vidioc_expbuf = vb2_ioctl_expbuf,
 };
 
-static int ipu3_sd_s_ctrl(struct v4l2_ctrl *ctrl)
+static int imgu_sd_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct imgu_v4l2_subdev *imgu_sd =
 		container_of(ctrl->handler, struct imgu_v4l2_subdev, ctrl_handler);
@@ -1034,29 +1034,29 @@ static int ipu3_sd_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
 }
 
-static const struct v4l2_ctrl_ops ipu3_subdev_ctrl_ops = {
-	.s_ctrl = ipu3_sd_s_ctrl,
+static const struct v4l2_ctrl_ops imgu_subdev_ctrl_ops = {
+	.s_ctrl = imgu_sd_s_ctrl,
 };
 
-static const char * const ipu3_ctrl_mode_strings[] = {
+static const char * const imgu_ctrl_mode_strings[] = {
 	"Video mode",
 	"Still mode",
 };
 
-static const struct v4l2_ctrl_config ipu3_subdev_ctrl_mode = {
-	.ops = &ipu3_subdev_ctrl_ops,
+static const struct v4l2_ctrl_config imgu_subdev_ctrl_mode = {
+	.ops = &imgu_subdev_ctrl_ops,
 	.id = V4L2_CID_INTEL_IPU3_MODE,
 	.name = "IPU3 Pipe Mode",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = ARRAY_SIZE(ipu3_ctrl_mode_strings) - 1,
+	.max = ARRAY_SIZE(imgu_ctrl_mode_strings) - 1,
 	.def = IPU3_RUNNING_MODE_VIDEO,
-	.qmenu = ipu3_ctrl_mode_strings,
+	.qmenu = imgu_ctrl_mode_strings,
 };
 
 /******************** Framework registration ********************/
 
 /* helper function to config node's video properties */
-static void ipu3_node_to_v4l2(u32 node, struct video_device *vdev,
+static void imgu_node_to_v4l2(u32 node, struct video_device *vdev,
 			      struct v4l2_format *f)
 {
 	u32 cap;
@@ -1068,32 +1068,32 @@ static void ipu3_node_to_v4l2(u32 node, struct video_device *vdev,
 	case IMGU_NODE_IN:
 		cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 		f->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-		vdev->ioctl_ops = &ipu3_v4l2_ioctl_ops;
+		vdev->ioctl_ops = &imgu_v4l2_ioctl_ops;
 		break;
 	case IMGU_NODE_PARAMS:
 		cap = V4L2_CAP_META_OUTPUT;
 		f->type = V4L2_BUF_TYPE_META_OUTPUT;
 		f->fmt.meta.dataformat = V4L2_META_FMT_IPU3_PARAMS;
-		vdev->ioctl_ops = &ipu3_v4l2_meta_ioctl_ops;
-		ipu3_css_meta_fmt_set(&f->fmt.meta);
+		vdev->ioctl_ops = &imgu_v4l2_meta_ioctl_ops;
+		imgu_css_meta_fmt_set(&f->fmt.meta);
 		break;
 	case IMGU_NODE_STAT_3A:
 		cap = V4L2_CAP_META_CAPTURE;
 		f->type = V4L2_BUF_TYPE_META_CAPTURE;
 		f->fmt.meta.dataformat = V4L2_META_FMT_IPU3_STAT_3A;
-		vdev->ioctl_ops = &ipu3_v4l2_meta_ioctl_ops;
-		ipu3_css_meta_fmt_set(&f->fmt.meta);
+		vdev->ioctl_ops = &imgu_v4l2_meta_ioctl_ops;
+		imgu_css_meta_fmt_set(&f->fmt.meta);
 		break;
 	default:
 		cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 		f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-		vdev->ioctl_ops = &ipu3_v4l2_ioctl_ops;
+		vdev->ioctl_ops = &imgu_v4l2_ioctl_ops;
 	}
 
 	vdev->device_caps = V4L2_CAP_STREAMING | cap;
 }
 
-static int ipu3_v4l2_subdev_register(struct imgu_device *imgu,
+static int imgu_v4l2_subdev_register(struct imgu_device *imgu,
 				     struct imgu_v4l2_subdev *imgu_sd,
 				     unsigned int pipe)
 {
@@ -1109,16 +1109,16 @@ static int ipu3_v4l2_subdev_register(struct imgu_device *imgu,
 			"failed initialize subdev media entity (%d)\n", r);
 		return r;
 	}
-	imgu_sd->subdev.entity.ops = &ipu3_media_ops;
+	imgu_sd->subdev.entity.ops = &imgu_media_ops;
 	for (i = 0; i < IMGU_NODE_NUM; i++) {
 		imgu_sd->subdev_pads[i].flags = imgu_pipe->nodes[i].output ?
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 	}
 
 	/* Initialize subdev */
-	v4l2_subdev_init(&imgu_sd->subdev, &ipu3_subdev_ops);
+	v4l2_subdev_init(&imgu_sd->subdev, &imgu_subdev_ops);
 	imgu_sd->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_STATISTICS;
-	imgu_sd->subdev.internal_ops = &ipu3_subdev_internal_ops;
+	imgu_sd->subdev.internal_ops = &imgu_subdev_internal_ops;
 	imgu_sd->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE |
 				V4L2_SUBDEV_FL_HAS_EVENTS;
 	snprintf(imgu_sd->subdev.name, sizeof(imgu_sd->subdev.name),
@@ -1127,7 +1127,7 @@ static int ipu3_v4l2_subdev_register(struct imgu_device *imgu,
 	atomic_set(&imgu_sd->running_mode, IPU3_RUNNING_MODE_VIDEO);
 	v4l2_ctrl_handler_init(hdl, 1);
 	imgu_sd->subdev.ctrl_handler = hdl;
-	imgu_sd->ctrl = v4l2_ctrl_new_custom(hdl, &ipu3_subdev_ctrl_mode, NULL);
+	imgu_sd->ctrl = v4l2_ctrl_new_custom(hdl, &imgu_subdev_ctrl_mode, NULL);
 	if (hdl->error) {
 		r = hdl->error;
 		dev_err(&imgu->pci_dev->dev,
@@ -1151,7 +1151,7 @@ static int ipu3_v4l2_subdev_register(struct imgu_device *imgu,
 	return r;
 }
 
-static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
+static int imgu_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 				int node_num)
 {
 	int r;
@@ -1196,7 +1196,7 @@ static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 	node->pad_fmt = def_bus_fmt;
 	node->id = node_num;
 	node->pipe = pipe;
-	ipu3_node_to_v4l2(node_num, vdev, &node->vdev_fmt);
+	imgu_node_to_v4l2(node_num, vdev, &node->vdev_fmt);
 	if (node->vdev_fmt.type ==
 	    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
 	    node->vdev_fmt.type ==
@@ -1221,11 +1221,11 @@ static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 	/* Initialize vbq */
 	vbq->type = node->vdev_fmt.type;
 	vbq->io_modes = VB2_USERPTR | VB2_MMAP | VB2_DMABUF;
-	vbq->ops = &ipu3_vb2_ops;
+	vbq->ops = &imgu_vb2_ops;
 	vbq->mem_ops = &vb2_dma_sg_memops;
 	if (imgu->buf_struct_size <= 0)
 		imgu->buf_struct_size =
-			sizeof(struct ipu3_vb2_buffer);
+			sizeof(struct imgu_vb2_buffer);
 	vbq->buf_struct_size = imgu->buf_struct_size;
 	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	/* can streamon w/o buffers */
@@ -1243,7 +1243,7 @@ static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 	snprintf(vdev->name, sizeof(vdev->name), "%s %d %s",
 		 IMGU_NAME, pipe, node->name);
 	vdev->release = video_device_release_empty;
-	vdev->fops = &ipu3_v4l2_fops;
+	vdev->fops = &imgu_v4l2_fops;
 	vdev->lock = &node->lock;
 	vdev->v4l2_dev = &imgu->v4l2_dev;
 	vdev->queue = &node->vbq;
@@ -1276,7 +1276,7 @@ static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 	return 0;
 }
 
-static void ipu3_v4l2_nodes_cleanup_pipe(struct imgu_device *imgu,
+static void imgu_v4l2_nodes_cleanup_pipe(struct imgu_device *imgu,
 					 unsigned int pipe, int node)
 {
 	int i;
@@ -1289,12 +1289,12 @@ static void ipu3_v4l2_nodes_cleanup_pipe(struct imgu_device *imgu,
 	}
 }
 
-static int ipu3_v4l2_nodes_setup_pipe(struct imgu_device *imgu, int pipe)
+static int imgu_v4l2_nodes_setup_pipe(struct imgu_device *imgu, int pipe)
 {
 	int i, r;
 
 	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		r = ipu3_v4l2_node_setup(imgu, pipe, i);
+		r = imgu_v4l2_node_setup(imgu, pipe, i);
 		if (r)
 			goto cleanup;
 	}
@@ -1302,11 +1302,11 @@ static int ipu3_v4l2_nodes_setup_pipe(struct imgu_device *imgu, int pipe)
 	return 0;
 
 cleanup:
-	ipu3_v4l2_nodes_cleanup_pipe(imgu, pipe, i);
+	imgu_v4l2_nodes_cleanup_pipe(imgu, pipe, i);
 	return r;
 }
 
-static void ipu3_v4l2_subdev_cleanup(struct imgu_device *imgu, unsigned int i)
+static void imgu_v4l2_subdev_cleanup(struct imgu_device *imgu, unsigned int i)
 {
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[i];
 
@@ -1315,13 +1315,13 @@ static void ipu3_v4l2_subdev_cleanup(struct imgu_device *imgu, unsigned int i)
 	media_entity_cleanup(&imgu_pipe->imgu_sd.subdev.entity);
 }
 
-static void ipu3_v4l2_cleanup_pipes(struct imgu_device *imgu, unsigned int pipe)
+static void imgu_v4l2_cleanup_pipes(struct imgu_device *imgu, unsigned int pipe)
 {
 	int i;
 
 	for (i = 0; i < pipe; i++) {
-		ipu3_v4l2_nodes_cleanup_pipe(imgu, i, IMGU_NODE_NUM);
-		ipu3_v4l2_subdev_cleanup(imgu, i);
+		imgu_v4l2_nodes_cleanup_pipe(imgu, i, IMGU_NODE_NUM);
+		imgu_v4l2_subdev_cleanup(imgu, i);
 	}
 }
 
@@ -1332,15 +1332,15 @@ static int imgu_v4l2_register_pipes(struct imgu_device *imgu)
 
 	for (i = 0; i < IMGU_MAX_PIPE_NUM; i++) {
 		imgu_pipe = &imgu->imgu_pipe[i];
-		r = ipu3_v4l2_subdev_register(imgu, &imgu_pipe->imgu_sd, i);
+		r = imgu_v4l2_subdev_register(imgu, &imgu_pipe->imgu_sd, i);
 		if (r) {
 			dev_err(&imgu->pci_dev->dev,
 				"failed to register subdev%d ret (%d)\n", i, r);
 			goto pipes_cleanup;
 		}
-		r = ipu3_v4l2_nodes_setup_pipe(imgu, i);
+		r = imgu_v4l2_nodes_setup_pipe(imgu, i);
 		if (r) {
-			ipu3_v4l2_subdev_cleanup(imgu, i);
+			imgu_v4l2_subdev_cleanup(imgu, i);
 			goto pipes_cleanup;
 		}
 	}
@@ -1348,7 +1348,7 @@ static int imgu_v4l2_register_pipes(struct imgu_device *imgu)
 	return 0;
 
 pipes_cleanup:
-	ipu3_v4l2_cleanup_pipes(imgu, i);
+	imgu_v4l2_cleanup_pipes(imgu, i);
 	return r;
 }
 
@@ -1396,7 +1396,7 @@ int imgu_v4l2_register(struct imgu_device *imgu)
 	return 0;
 
 fail_subdevs:
-	ipu3_v4l2_cleanup_pipes(imgu, IMGU_MAX_PIPE_NUM);
+	imgu_v4l2_cleanup_pipes(imgu, IMGU_MAX_PIPE_NUM);
 fail_v4l2_pipes:
 	v4l2_device_unregister(&imgu->v4l2_dev);
 fail_v4l2_dev:
@@ -1408,7 +1408,7 @@ int imgu_v4l2_register(struct imgu_device *imgu)
 int imgu_v4l2_unregister(struct imgu_device *imgu)
 {
 	media_device_unregister(&imgu->media_dev);
-	ipu3_v4l2_cleanup_pipes(imgu, IMGU_MAX_PIPE_NUM);
+	imgu_v4l2_cleanup_pipes(imgu, IMGU_MAX_PIPE_NUM);
 	v4l2_device_unregister(&imgu->v4l2_dev);
 	media_device_cleanup(&imgu->media_dev);
 
@@ -1418,8 +1418,8 @@ int imgu_v4l2_unregister(struct imgu_device *imgu)
 void imgu_v4l2_buffer_done(struct vb2_buffer *vb,
 			   enum vb2_buffer_state state)
 {
-	struct ipu3_vb2_buffer *b =
-		container_of(vb, struct ipu3_vb2_buffer, vbb.vb2_buf);
+	struct imgu_vb2_buffer *b =
+		container_of(vb, struct imgu_vb2_buffer, vbb.vb2_buf);
 
 	list_del(&b->list);
 	vb2_buffer_done(&b->vbb.vb2_buf, state);
diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index 839d9398f8e9..d575ac78c8f0 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -72,7 +72,7 @@ static void imgu_dummybufs_cleanup(struct imgu_device *imgu, unsigned int pipe)
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++)
-		ipu3_dmamap_free(imgu,
+		imgu_dmamap_free(imgu,
 				 &imgu_pipe->queues[i].dmap);
 }
 
@@ -93,7 +93,7 @@ static int imgu_dummybufs_preallocate(struct imgu_device *imgu,
 		if (i == IMGU_QUEUE_MASTER || size == 0)
 			continue;
 
-		if (!ipu3_dmamap_alloc(imgu,
+		if (!imgu_dmamap_alloc(imgu,
 				       &imgu_pipe->queues[i].dmap, size)) {
 			imgu_dummybufs_cleanup(imgu, pipe);
 			return -ENOMEM;
@@ -133,7 +133,7 @@ static int imgu_dummybufs_init(struct imgu_device *imgu, unsigned int pipe)
 		else
 			size = mpix->plane_fmt[0].sizeimage;
 
-		if (ipu3_css_dma_buffer_resize(imgu,
+		if (imgu_css_dma_buffer_resize(imgu,
 					       &imgu_pipe->queues[i].dmap,
 					       size)) {
 			imgu_dummybufs_cleanup(imgu, pipe);
@@ -141,7 +141,7 @@ static int imgu_dummybufs_init(struct imgu_device *imgu, unsigned int pipe)
 		}
 
 		for (k = 0; k < IMGU_MAX_QUEUE_DEPTH; k++)
-			ipu3_css_buf_init(&imgu_pipe->queues[i].dummybufs[k], i,
+			imgu_css_buf_init(&imgu_pipe->queues[i].dummybufs[k], i,
 					  imgu_pipe->queues[i].dmap.daddr);
 	}
 
@@ -149,7 +149,7 @@ static int imgu_dummybufs_init(struct imgu_device *imgu, unsigned int pipe)
 }
 
 /* May be called from atomic context */
-static struct ipu3_css_buffer *imgu_dummybufs_get(struct imgu_device *imgu,
+static struct imgu_css_buffer *imgu_dummybufs_get(struct imgu_device *imgu,
 						   int queue, unsigned int pipe)
 {
 	unsigned int i;
@@ -164,14 +164,14 @@ static struct ipu3_css_buffer *imgu_dummybufs_get(struct imgu_device *imgu,
 		return NULL;
 
 	for (i = 0; i < IMGU_MAX_QUEUE_DEPTH; i++)
-		if (ipu3_css_buf_state(&imgu_pipe->queues[queue].dummybufs[i]) !=
+		if (imgu_css_buf_state(&imgu_pipe->queues[queue].dummybufs[i]) !=
 			IPU3_CSS_BUFFER_QUEUED)
 			break;
 
 	if (i == IMGU_MAX_QUEUE_DEPTH)
 		return NULL;
 
-	ipu3_css_buf_init(&imgu_pipe->queues[queue].dummybufs[i], queue,
+	imgu_css_buf_init(&imgu_pipe->queues[queue].dummybufs[i], queue,
 			  imgu_pipe->queues[queue].dmap.daddr);
 
 	return &imgu_pipe->queues[queue].dummybufs[i];
@@ -179,7 +179,7 @@ static struct ipu3_css_buffer *imgu_dummybufs_get(struct imgu_device *imgu,
 
 /* Check if given buffer is a dummy buffer */
 static bool imgu_dummybufs_check(struct imgu_device *imgu,
-				 struct ipu3_css_buffer *buf,
+				 struct imgu_css_buffer *buf,
 				 unsigned int pipe)
 {
 	unsigned int i;
@@ -200,7 +200,7 @@ static void imgu_buffer_done(struct imgu_device *imgu, struct vb2_buffer *vb,
 	mutex_unlock(&imgu->lock);
 }
 
-static struct ipu3_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
+static struct imgu_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
 						 unsigned int node,
 						 unsigned int pipe)
 {
@@ -212,7 +212,7 @@ static struct ipu3_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
 
 	/* Find first free buffer from the node */
 	list_for_each_entry(buf, &imgu_pipe->nodes[node].buffers, vid_buf.list) {
-		if (ipu3_css_buf_state(&buf->css_buf) == IPU3_CSS_BUFFER_NEW)
+		if (imgu_css_buf_state(&buf->css_buf) == IPU3_CSS_BUFFER_NEW)
 			return &buf->css_buf;
 	}
 
@@ -230,7 +230,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 	int r = 0;
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
-	if (!ipu3_css_is_streaming(&imgu->css))
+	if (!imgu_css_is_streaming(&imgu->css))
 		return 0;
 
 	dev_dbg(&imgu->pci_dev->dev, "Queue buffers to pipe %d", pipe);
@@ -247,7 +247,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 				 "Vf not enabled, ignore queue");
 			continue;
 		} else if (imgu_pipe->queue_enabled[node]) {
-			struct ipu3_css_buffer *buf =
+			struct imgu_css_buffer *buf =
 				imgu_queue_getbuf(imgu, node, pipe);
 			struct imgu_buffer *ibuf = NULL;
 			bool dummy;
@@ -255,7 +255,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 			if (!buf)
 				break;
 
-			r = ipu3_css_buf_queue(&imgu->css, pipe, buf);
+			r = imgu_css_buf_queue(&imgu->css, pipe, buf);
 			if (r)
 				break;
 			dummy = imgu_dummybufs_check(imgu, buf, pipe);
@@ -300,7 +300,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 		list_for_each_entry_safe(buf, buf0,
 					 &imgu_pipe->nodes[node].buffers,
 					 vid_buf.list) {
-			if (ipu3_css_buf_state(&buf->css_buf) ==
+			if (imgu_css_buf_state(&buf->css_buf) ==
 			    IPU3_CSS_BUFFER_QUEUED)
 				continue;	/* Was already queued, skip */
 
@@ -317,18 +317,18 @@ static int imgu_powerup(struct imgu_device *imgu)
 {
 	int r;
 
-	r = ipu3_css_set_powerup(&imgu->pci_dev->dev, imgu->base);
+	r = imgu_css_set_powerup(&imgu->pci_dev->dev, imgu->base);
 	if (r)
 		return r;
 
-	ipu3_mmu_resume(imgu->mmu);
+	imgu_mmu_resume(imgu->mmu);
 	return 0;
 }
 
 static void imgu_powerdown(struct imgu_device *imgu)
 {
-	ipu3_mmu_suspend(imgu->mmu);
-	ipu3_css_set_powerdown(&imgu->pci_dev->dev, imgu->base);
+	imgu_mmu_suspend(imgu->mmu);
+	imgu_css_set_powerdown(&imgu->pci_dev->dev, imgu->base);
 }
 
 int imgu_s_stream(struct imgu_device *imgu, int enable)
@@ -341,7 +341,7 @@ int imgu_s_stream(struct imgu_device *imgu, int enable)
 		dev_dbg(dev, "stream off\n");
 		/* Block new buffers to be queued to CSS. */
 		atomic_set(&imgu->qbuf_barrier, 1);
-		ipu3_css_stop_streaming(&imgu->css);
+		imgu_css_stop_streaming(&imgu->css);
 		synchronize_irq(imgu->pci_dev->irq);
 		atomic_set(&imgu->qbuf_barrier, 0);
 		imgu_powerdown(imgu);
@@ -366,7 +366,7 @@ int imgu_s_stream(struct imgu_device *imgu, int enable)
 	}
 
 	/* Start CSS streaming */
-	r = ipu3_css_start_streaming(&imgu->css);
+	r = imgu_css_start_streaming(&imgu->css);
 	if (r) {
 		dev_err(dev, "failed to start css streaming (%d)", r);
 		goto fail_start_streaming;
@@ -393,7 +393,7 @@ int imgu_s_stream(struct imgu_device *imgu, int enable)
 	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM)
 		imgu_dummybufs_cleanup(imgu, pipe);
 fail_dummybufs:
-	ipu3_css_stop_streaming(&imgu->css);
+	imgu_css_stop_streaming(&imgu->css);
 fail_start_streaming:
 	pm_runtime_put(dev);
 
@@ -435,7 +435,7 @@ static int imgu_video_nodes_init(struct imgu_device *imgu)
 
 		rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu_pipe->imgu_sd.rect.eff;
 		rects[IPU3_CSS_RECT_BDS] = &imgu_pipe->imgu_sd.rect.bds;
-		ipu3_css_fmt_set(&imgu->css, fmts, rects, j);
+		imgu_css_fmt_set(&imgu->css, fmts, rects, j);
 
 		/* Pre-allocate dummy buffers */
 		r = imgu_dummybufs_preallocate(imgu, j);
@@ -478,14 +478,14 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 	/* Dequeue / queue buffers */
 	do {
 		u64 ns = ktime_get_ns();
-		struct ipu3_css_buffer *b;
+		struct imgu_css_buffer *b;
 		struct imgu_buffer *buf = NULL;
 		unsigned int node, pipe;
 		bool dummy;
 
 		do {
 			mutex_lock(&imgu->lock);
-			b = ipu3_css_buf_dequeue(&imgu->css);
+			b = imgu_css_buf_dequeue(&imgu->css);
 			mutex_unlock(&imgu->lock);
 		} while (PTR_ERR(b) == -EAGAIN);
 
@@ -525,12 +525,12 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 				buf->vid_buf.vbb.sequence);
 		}
 		imgu_buffer_done(imgu, &buf->vid_buf.vbb.vb2_buf,
-				 ipu3_css_buf_state(&buf->css_buf) ==
+				 imgu_css_buf_state(&buf->css_buf) ==
 						    IPU3_CSS_BUFFER_DONE ?
 						    VB2_BUF_STATE_DONE :
 						    VB2_BUF_STATE_ERROR);
 		mutex_lock(&imgu->lock);
-		if (ipu3_css_queue_empty(&imgu->css))
+		if (imgu_css_queue_empty(&imgu->css))
 			wake_up_all(&imgu->buf_drain_wq);
 		mutex_unlock(&imgu->lock);
 	} while (1);
@@ -552,7 +552,7 @@ static irqreturn_t imgu_isr(int irq, void *imgu_ptr)
 	struct imgu_device *imgu = imgu_ptr;
 
 	/* acknowledge interruption */
-	if (ipu3_css_irq_ack(&imgu->css) < 0)
+	if (imgu_css_irq_ack(&imgu->css) < 0)
 		return IRQ_NONE;
 
 	return IRQ_WAKE_THREAD;
@@ -637,21 +637,21 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
 	atomic_set(&imgu->qbuf_barrier, 0);
 	init_waitqueue_head(&imgu->buf_drain_wq);
 
-	r = ipu3_css_set_powerup(&pci_dev->dev, imgu->base);
+	r = imgu_css_set_powerup(&pci_dev->dev, imgu->base);
 	if (r) {
 		dev_err(&pci_dev->dev,
 			"failed to power up CSS (%d)\n", r);
 		goto out_mutex_destroy;
 	}
 
-	imgu->mmu = ipu3_mmu_init(&pci_dev->dev, imgu->base);
+	imgu->mmu = imgu_mmu_init(&pci_dev->dev, imgu->base);
 	if (IS_ERR(imgu->mmu)) {
 		r = PTR_ERR(imgu->mmu);
 		dev_err(&pci_dev->dev, "failed to initialize MMU (%d)\n", r);
 		goto out_css_powerdown;
 	}
 
-	r = ipu3_dmamap_init(imgu);
+	r = imgu_dmamap_init(imgu);
 	if (r) {
 		dev_err(&pci_dev->dev,
 			"failed to initialize DMA mapping (%d)\n", r);
@@ -659,7 +659,7 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
 	}
 
 	/* ISP programming */
-	r = ipu3_css_init(&pci_dev->dev, &imgu->css, imgu->base, phys_len);
+	r = imgu_css_init(&pci_dev->dev, &imgu->css, imgu->base, phys_len);
 	if (r) {
 		dev_err(&pci_dev->dev, "failed to initialize CSS (%d)\n", r);
 		goto out_dmamap_exit;
@@ -689,13 +689,13 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
 out_video_exit:
 	imgu_video_nodes_exit(imgu);
 out_css_cleanup:
-	ipu3_css_cleanup(&imgu->css);
+	imgu_css_cleanup(&imgu->css);
 out_dmamap_exit:
-	ipu3_dmamap_exit(imgu);
+	imgu_dmamap_exit(imgu);
 out_mmu_exit:
-	ipu3_mmu_exit(imgu->mmu);
+	imgu_mmu_exit(imgu->mmu);
 out_css_powerdown:
-	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
+	imgu_css_set_powerdown(&pci_dev->dev, imgu->base);
 out_mutex_destroy:
 	mutex_destroy(&imgu->lock);
 
@@ -710,10 +710,10 @@ static void imgu_pci_remove(struct pci_dev *pci_dev)
 	pm_runtime_get_noresume(&pci_dev->dev);
 
 	imgu_video_nodes_exit(imgu);
-	ipu3_css_cleanup(&imgu->css);
-	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
-	ipu3_dmamap_exit(imgu);
-	ipu3_mmu_exit(imgu->mmu);
+	imgu_css_cleanup(&imgu->css);
+	imgu_css_set_powerdown(&pci_dev->dev, imgu->base);
+	imgu_dmamap_exit(imgu);
+	imgu_mmu_exit(imgu->mmu);
 	mutex_destroy(&imgu->lock);
 }
 
@@ -723,7 +723,7 @@ static int __maybe_unused imgu_suspend(struct device *dev)
 	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
 
 	dev_dbg(dev, "enter %s\n", __func__);
-	imgu->suspend_in_stream = ipu3_css_is_streaming(&imgu->css);
+	imgu->suspend_in_stream = imgu_css_is_streaming(&imgu->css);
 	if (!imgu->suspend_in_stream)
 		goto out;
 	/* Block new buffers to be queued to CSS. */
@@ -735,10 +735,10 @@ static int __maybe_unused imgu_suspend(struct device *dev)
 	synchronize_irq(pci_dev->irq);
 	/* Wait until all buffers in CSS are done. */
 	if (!wait_event_timeout(imgu->buf_drain_wq,
-	    ipu3_css_queue_empty(&imgu->css), msecs_to_jiffies(1000)))
+	    imgu_css_queue_empty(&imgu->css), msecs_to_jiffies(1000)))
 		dev_err(dev, "wait buffer drain timeout.\n");
 
-	ipu3_css_stop_streaming(&imgu->css);
+	imgu_css_stop_streaming(&imgu->css);
 	atomic_set(&imgu->qbuf_barrier, 0);
 	imgu_powerdown(imgu);
 	pm_runtime_force_suspend(dev);
@@ -768,7 +768,7 @@ static int __maybe_unused imgu_resume(struct device *dev)
 	}
 
 	/* Start CSS streaming */
-	r = ipu3_css_start_streaming(&imgu->css);
+	r = imgu_css_start_streaming(&imgu->css);
 	if (r) {
 		dev_err(dev, "failed to resume css streaming (%d)", r);
 		goto out;
diff --git a/drivers/staging/media/ipu3/ipu3.h b/drivers/staging/media/ipu3/ipu3.h
index 04fc99f47ebb..6b408f726667 100644
--- a/drivers/staging/media/ipu3/ipu3.h
+++ b/drivers/staging/media/ipu3/ipu3.h
@@ -32,7 +32,7 @@
 #define IMGU_NODE_STAT_3A		4 /* 3A statistics */
 #define IMGU_NODE_NUM			5
 
-#define file_to_intel_ipu3_node(__file) \
+#define file_to_intel_imgu_node(__file) \
 	container_of(video_devdata(__file), struct imgu_video_device, vdev)
 
 #define IPU3_INPUT_MIN_WIDTH		0U
@@ -44,7 +44,7 @@
 #define IPU3_OUTPUT_MAX_WIDTH		4480U
 #define IPU3_OUTPUT_MAX_HEIGHT		34004U
 
-struct ipu3_vb2_buffer {
+struct imgu_vb2_buffer {
 	/* Public fields */
 	struct vb2_v4l2_buffer vbb;	/* Must be the first field */
 
@@ -53,9 +53,9 @@ struct ipu3_vb2_buffer {
 };
 
 struct imgu_buffer {
-	struct ipu3_vb2_buffer vid_buf;	/* Must be the first field */
-	struct ipu3_css_buffer css_buf;
-	struct ipu3_css_map map;
+	struct imgu_vb2_buffer vid_buf;	/* Must be the first field */
+	struct imgu_css_buffer css_buf;
+	struct imgu_css_map map;
 };
 
 struct imgu_node_mapping {
@@ -107,8 +107,8 @@ struct imgu_media_pipe {
 
 	/* Internally enabled queues */
 	struct {
-		struct ipu3_css_map dmap;
-		struct ipu3_css_buffer dummybufs[IMGU_MAX_QUEUE_DEPTH];
+		struct imgu_css_map dmap;
+		struct imgu_css_buffer dummybufs[IMGU_MAX_QUEUE_DEPTH];
 	} queues[IPU3_CSS_QUEUES];
 	struct imgu_video_device nodes[IMGU_NODE_NUM];
 	bool queue_enabled[IMGU_NODE_NUM];
@@ -135,11 +135,11 @@ struct imgu_device {
 	struct v4l2_file_operations v4l2_file_ops;
 
 	/* MMU driver for css */
-	struct ipu3_mmu_info *mmu;
+	struct imgu_mmu_info *mmu;
 	struct iova_domain iova_domain;
 
 	/* css - Camera Sub-System */
-	struct ipu3_css css;
+	struct imgu_css css;
 
 	/*
 	 * Coarse-grained lock to protect
-- 
2.7.4

