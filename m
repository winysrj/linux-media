Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:58259 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbeJ3HR7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:17:59 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v7 16/16] intel-ipu3: Add dual pipe support
Date: Mon, 29 Oct 2018 15:23:10 -0700
Message-Id: <1540851790-1777-17-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Cao,Bing Bu" <bingbu.cao@intel.com>

This patch adds support to run dual pipes simultaneously.
A private ioctl to configure the pipe mode (video or still)
is also implemented.

IPU3 hardware supports a maximum of 2 streams per pipe.
With the support of dual pipes, more than 2 stream outputs
can be achieved.

This helps to support advanced camera features like
Continuous View Finder (CVF) and Snapshot During Video(SDV).

Extend ipu3 IMGU driver to support dual pipes

    1. Extend current IMGU device to contain 2 groups
       of video nodes and 2 subdevs
    2. Extend current css to support 2 pipeline and make
       CSS APIs to support 2 pipe
    3. Add a v4l2 ctrl to allow user to specify the mode
       of the pipe
    4. Check media pipeline link status to get enabled
       pipes

Signed-off-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c     |  11 +-
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h     |   6 +-
 drivers/media/pci/intel/ipu3/ipu3-css-params.c | 309 +++++----
 drivers/media/pci/intel/ipu3/ipu3-css-params.h |   9 +-
 drivers/media/pci/intel/ipu3/ipu3-css.c        | 864 ++++++++++++++-----------
 drivers/media/pci/intel/ipu3/ipu3-css.h        |  84 +--
 drivers/media/pci/intel/ipu3/ipu3-v4l2.c       | 797 ++++++++++++++++-------
 drivers/media/pci/intel/ipu3/ipu3.c            | 284 ++++----
 drivers/media/pci/intel/ipu3/ipu3.h            |  56 +-
 include/uapi/linux/intel-ipu3.h                |   8 +
 10 files changed, 1469 insertions(+), 959 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.c b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
index ba459e9..55861aa 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
@@ -69,16 +69,17 @@ unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi)
 	return obgrid_size;
 }
 
-void *ipu3_css_fw_pipeline_params(struct ipu3_css *css,
-				  enum imgu_abi_param_class c,
-				  enum imgu_abi_memories m,
+void *ipu3_css_fw_pipeline_params(struct ipu3_css *css, unsigned int pipe,
+				  enum imgu_abi_param_class cls,
+				  enum imgu_abi_memories mem,
 				  struct imgu_fw_isp_parameter *par,
 				  size_t par_size, void *binary_params)
 {
-	struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
+	struct imgu_fw_info *bi =
+		&css->fwp->binary_header[css->pipes[pipe].bindex];
 
 	if (par->offset + par->size >
-	    bi->info.isp.sp.mem_initializers.params[c][m].size)
+	    bi->info.isp.sp.mem_initializers.params[cls][mem].size)
 		return NULL;
 
 	if (par->size != par_size)
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.h b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
index 954bb31..d1ffe51 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
@@ -179,9 +179,9 @@ int ipu3_css_fw_init(struct ipu3_css *css);
 void ipu3_css_fw_cleanup(struct ipu3_css *css);
 
 unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi);
-void *ipu3_css_fw_pipeline_params(struct ipu3_css *css,
-				  enum imgu_abi_param_class c,
-				  enum imgu_abi_memories m,
+void *ipu3_css_fw_pipeline_params(struct ipu3_css *css, unsigned int pipe,
+				  enum imgu_abi_param_class cls,
+				  enum imgu_abi_memories mem,
 				  struct imgu_fw_isp_parameter *par,
 				  size_t par_size, void *binary_params);
 
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-params.c b/drivers/media/pci/intel/ipu3/ipu3-css-params.c
index add2be4..7843631 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css-params.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-params.c
@@ -364,55 +364,59 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
 		struct ipu3_css_scaler_info *scaler_luma,
 		struct ipu3_css_scaler_info *scaler_chroma,
 		struct ipu3_css_frame_params frame_params[],
-		struct ipu3_css_stripe_params stripe_params[])
+		struct ipu3_css_stripe_params stripe_params[],
+		unsigned int pipe)
 {
-	u32 input_width = css->rect[IPU3_CSS_RECT_GDC].width;
-	u32 input_height = css->rect[IPU3_CSS_RECT_GDC].height;
-	u32 target_width = css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
-	u32 target_height = css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
-	unsigned int procmode = 0;
 	struct ipu3_css_reso reso;
 	unsigned int output_width, pin, s;
+	u32 input_width, input_height, target_width, target_height;
+	unsigned int procmode = 0;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+
+	input_width = css_pipe->rect[IPU3_CSS_RECT_GDC].width;
+	input_height = css_pipe->rect[IPU3_CSS_RECT_GDC].height;
+	target_width = css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+	target_height = css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 
 	/* Frame parameters */
 
 	/* Input width for Output System is output width of DVS (with GDC) */
-	reso.input_width = css->rect[IPU3_CSS_RECT_GDC].width;
+	reso.input_width = css_pipe->rect[IPU3_CSS_RECT_GDC].width;
 
 	/* Input height for Output System is output height of DVS (with GDC) */
-	reso.input_height = css->rect[IPU3_CSS_RECT_GDC].height;
+	reso.input_height = css_pipe->rect[IPU3_CSS_RECT_GDC].height;
 
 	reso.input_format =
-		css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 
 	reso.pin_width[IMGU_ABI_OSYS_PIN_OUT] =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	reso.pin_height[IMGU_ABI_OSYS_PIN_OUT] =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	reso.pin_stride[IMGU_ABI_OSYS_PIN_OUT] =
-		css->queue[IPU3_CSS_QUEUE_OUT].width_pad;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 	reso.pin_format[IMGU_ABI_OSYS_PIN_OUT] =
-		css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 
 	reso.pin_width[IMGU_ABI_OSYS_PIN_VF] =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	reso.pin_height[IMGU_ABI_OSYS_PIN_VF] =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	reso.pin_stride[IMGU_ABI_OSYS_PIN_VF] =
-		css->queue[IPU3_CSS_QUEUE_VF].width_pad;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 	reso.pin_format[IMGU_ABI_OSYS_PIN_VF] =
-		css->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
 
 	/* Configure the frame parameters for all output pins */
 
 	frame_params[IMGU_ABI_OSYS_PIN_OUT].width =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	frame_params[IMGU_ABI_OSYS_PIN_OUT].height =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	frame_params[IMGU_ABI_OSYS_PIN_VF].width =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	frame_params[IMGU_ABI_OSYS_PIN_VF].height =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	frame_params[IMGU_ABI_OSYS_PIN_VF].crop_top = 0;
 	frame_params[IMGU_ABI_OSYS_PIN_VF].crop_left = 0;
 
@@ -842,7 +846,8 @@ static int ipu3_css_osys_calc_frame_and_stripe_params(
  * This function configures the Output Formatter System, given the number of
  * stripes, scaler luma and chrome parameters
  */
-static void ipu3_css_osys_calc(struct ipu3_css *css, unsigned int stripes,
+static void ipu3_css_osys_calc(struct ipu3_css *css, unsigned int pipe,
+			       unsigned int stripes,
 			       struct imgu_abi_osys_config *osys,
 			       struct ipu3_css_scaler_info *scaler_luma,
 			       struct ipu3_css_scaler_info *scaler_chroma,
@@ -852,13 +857,15 @@ static void ipu3_css_osys_calc(struct ipu3_css *css, unsigned int stripes,
 	struct ipu3_css_stripe_params stripe_params[IPU3_UAPI_MAX_STRIPES];
 	struct imgu_abi_osys_formatter_params *param;
 	unsigned int pin, s;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
 	memset(osys, 0, sizeof(*osys));
 
 	/* Compute the frame and stripe params */
 	ipu3_css_osys_calc_frame_and_stripe_params(css, stripes, osys,
 						   scaler_luma, scaler_chroma,
-						   frame_params, stripe_params);
+						   frame_params, stripe_params,
+						   pipe);
 
 	/* Output formatter system parameters */
 
@@ -1180,19 +1187,20 @@ static void ipu3_css_osys_calc(struct ipu3_css *css, unsigned int stripes,
 		block_stripes[0].height = stripe_params[0].input_height;
 	} else {
 		struct imgu_fw_info *bi =
-				&css->fwp->binary_header[css->current_binary];
-		unsigned int sp_block_width = IPU3_UAPI_ISP_VEC_ELEMS *
-				bi->info.isp.sp.block.block_width;
+			&css->fwp->binary_header[css_pipe->bindex];
+		unsigned int sp_block_width =
+				bi->info.isp.sp.block.block_width *
+				IPU3_UAPI_ISP_VEC_ELEMS;
 
 		block_stripes[0].width = roundup(stripe_params[0].input_width,
 						 sp_block_width);
 		block_stripes[1].offset =
-			rounddown(css->rect[IPU3_CSS_RECT_GDC].width -
+			rounddown(css_pipe->rect[IPU3_CSS_RECT_GDC].width -
 				  stripe_params[1].input_width, sp_block_width);
 		block_stripes[1].width =
-			roundup(css->rect[IPU3_CSS_RECT_GDC].width -
+			roundup(css_pipe->rect[IPU3_CSS_RECT_GDC].width -
 				block_stripes[1].offset, sp_block_width);
-		block_stripes[0].height = css->rect[IPU3_CSS_RECT_GDC].height;
+		block_stripes[0].height = css_pipe->rect[IPU3_CSS_RECT_GDC].height;
 		block_stripes[1].height = block_stripes[0].height;
 	}
 }
@@ -1620,15 +1628,17 @@ ipu3_css_acc_process_lines(const struct process_lines *pl,
 	return 0;
 }
 
-static int ipu3_css_af_ops_calc(struct ipu3_css *css,
+static int ipu3_css_af_ops_calc(struct ipu3_css *css, unsigned int pipe,
 				struct imgu_abi_af_config *af_config)
 {
 	struct imgu_abi_af_intra_frame_operations_data *to =
 		&af_config->operations_data;
-	struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_fw_info *bi =
+		&css->fwp->binary_header[css_pipe->bindex];
 
 	struct process_lines pl = {
-		.image_height = css->rect[IPU3_CSS_RECT_BDS].height,
+		.image_height = css_pipe->rect[IPU3_CSS_RECT_BDS].height,
 		.grid_height = af_config->config.grid_cfg.height,
 		.block_height =
 			1 << af_config->config.grid_cfg.block_height_log2,
@@ -1646,14 +1656,16 @@ static int ipu3_css_af_ops_calc(struct ipu3_css *css,
 }
 
 static int
-ipu3_css_awb_fr_ops_calc(struct ipu3_css *css,
+ipu3_css_awb_fr_ops_calc(struct ipu3_css *css, unsigned int pipe,
 			 struct imgu_abi_awb_fr_config *awb_fr_config)
 {
 	struct imgu_abi_awb_fr_intra_frame_operations_data *to =
 		&awb_fr_config->operations_data;
-	struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_fw_info *bi =
+		&css->fwp->binary_header[css_pipe->bindex];
 	struct process_lines pl = {
-		.image_height = css->rect[IPU3_CSS_RECT_BDS].height,
+		.image_height = css_pipe->rect[IPU3_CSS_RECT_BDS].height,
 		.grid_height = awb_fr_config->config.grid_cfg.height,
 		.block_height =
 			1 << awb_fr_config->config.grid_cfg.block_height_log2,
@@ -1670,15 +1682,17 @@ ipu3_css_awb_fr_ops_calc(struct ipu3_css *css,
 					  NULL);
 }
 
-static int ipu3_css_awb_ops_calc(struct ipu3_css *css,
+static int ipu3_css_awb_ops_calc(struct ipu3_css *css, unsigned int pipe,
 				 struct imgu_abi_awb_config *awb_config)
 {
 	struct imgu_abi_awb_intra_frame_operations_data *to =
 		&awb_config->operations_data;
-	struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_fw_info *bi =
+		&css->fwp->binary_header[css_pipe->bindex];
 
 	struct process_lines pl = {
-		.image_height = css->rect[IPU3_CSS_RECT_BDS].height,
+		.image_height = css_pipe->rect[IPU3_CSS_RECT_BDS].height,
 		.grid_height = awb_config->config.grid.height,
 		.block_height =
 			1 << awb_config->config.grid.block_height_log2,
@@ -1710,21 +1724,22 @@ static void ipu3_css_grid_end_calc(struct ipu3_uapi_grid_config *grid_cfg)
 
 /****************** config computation *****************************/
 
-static void ipu3_css_cfg_acc_stripe(struct ipu3_css *css,
+static void ipu3_css_cfg_acc_stripe(struct ipu3_css *css, unsigned int pipe,
 				    struct imgu_abi_acc_param *acc)
 {
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
-		&css->fwp->binary_header[css->current_binary];
-	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
-	const unsigned int F = IPU3_UAPI_ISP_VEC_ELEMS * 2;
+		&css->fwp->binary_header[css_pipe->bindex];
 	struct ipu3_css_scaler_info scaler_luma, scaler_chroma;
+	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
+	const unsigned int f = IPU3_UAPI_ISP_VEC_ELEMS * 2;
 	unsigned int bds_ds, i;
 
 	memset(acc, 0, sizeof(*acc));
 
 	/* acc_param: osys_config */
 
-	ipu3_css_osys_calc(css, stripes, &acc->osys, &scaler_luma,
+	ipu3_css_osys_calc(css, pipe, stripes, &acc->osys, &scaler_luma,
 			   &scaler_chroma, acc->stripe.block_stripes);
 
 	/* acc_param: stripe data */
@@ -1740,77 +1755,78 @@ static void ipu3_css_cfg_acc_stripe(struct ipu3_css *css,
 
 	acc->stripe.num_of_stripes = stripes;
 	acc->stripe.input_frame.width =
-		css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
 	acc->stripe.input_frame.height =
-		css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
 	acc->stripe.input_frame.bayer_order =
-		css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
 
 	for (i = 0; i < stripes; i++)
 		acc->stripe.bds_out_stripes[i].height =
-					css->rect[IPU3_CSS_RECT_BDS].height;
+					css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	acc->stripe.bds_out_stripes[0].offset = 0;
 	if (stripes <= 1) {
 		acc->stripe.bds_out_stripes[0].width =
-			ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, F);
+			ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f);
 	} else {
 		/* Image processing is divided into two stripes */
 		acc->stripe.bds_out_stripes[0].width =
 			acc->stripe.bds_out_stripes[1].width =
-			(css->rect[IPU3_CSS_RECT_BDS].width / 2 & ~(F - 1)) + F;
+			(css_pipe->rect[IPU3_CSS_RECT_BDS].width / 2 & ~(f - 1)) + f;
 		/*
 		 * Sum of width of the two stripes should not be smaller
 		 * than output width and must be even times of overlapping
 		 * unit f.
 		 */
-		if ((css->rect[IPU3_CSS_RECT_BDS].width / F & 1) !=
-		    !!(css->rect[IPU3_CSS_RECT_BDS].width & (F - 1)))
-			acc->stripe.bds_out_stripes[0].width += F;
-		if ((css->rect[IPU3_CSS_RECT_BDS].width / F & 1) &&
-		    (css->rect[IPU3_CSS_RECT_BDS].width & (F - 1))) {
-			acc->stripe.bds_out_stripes[0].width += F;
-			acc->stripe.bds_out_stripes[1].width += F;
+		if ((css_pipe->rect[IPU3_CSS_RECT_BDS].width / f & 1) !=
+		    !!(css_pipe->rect[IPU3_CSS_RECT_BDS].width & (f - 1)))
+			acc->stripe.bds_out_stripes[0].width += f;
+		if ((css_pipe->rect[IPU3_CSS_RECT_BDS].width / f & 1) &&
+		    (css_pipe->rect[IPU3_CSS_RECT_BDS].width & (f - 1))) {
+			acc->stripe.bds_out_stripes[0].width += f;
+			acc->stripe.bds_out_stripes[1].width += f;
 		}
 		/* Overlap between stripes is IPU3_UAPI_ISP_VEC_ELEMS * 4 */
 		acc->stripe.bds_out_stripes[1].offset =
-			acc->stripe.bds_out_stripes[0].width - 2 * F;
+			acc->stripe.bds_out_stripes[0].width - 2 * f;
 	}
 
 	acc->stripe.effective_stripes[0].height =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].height;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height;
 	acc->stripe.effective_stripes[0].offset = 0;
 	acc->stripe.bds_out_stripes_no_overlap[0].height =
-				css->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	acc->stripe.bds_out_stripes_no_overlap[0].offset = 0;
 	acc->stripe.output_stripes[0].height =
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	acc->stripe.output_stripes[0].offset = 0;
 	if (stripes <= 1) {
 		acc->stripe.down_scaled_stripes[0].width =
-				css->rect[IPU3_CSS_RECT_BDS].width;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 		acc->stripe.down_scaled_stripes[0].height =
-				css->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 		acc->stripe.down_scaled_stripes[0].offset = 0;
 
 		acc->stripe.effective_stripes[0].width =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].width;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].width;
 		acc->stripe.bds_out_stripes_no_overlap[0].width =
-			ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, F);
+			ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f);
 
 		acc->stripe.output_stripes[0].width =
-			css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	} else { /* Two stripes */
-		bds_ds = css->rect[IPU3_CSS_RECT_EFFECTIVE].width *
+		bds_ds = css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].width *
 				IMGU_BDS_GRANULARITY /
-				css->rect[IPU3_CSS_RECT_BDS].width;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 
 		acc->stripe.down_scaled_stripes[0] =
 			acc->stripe.bds_out_stripes[0];
 		acc->stripe.down_scaled_stripes[1] =
 			acc->stripe.bds_out_stripes[1];
-		if (!IS_ALIGNED(css->rect[IPU3_CSS_RECT_BDS].width, F))
-			acc->stripe.down_scaled_stripes[1].width += -F +
-				(css->rect[IPU3_CSS_RECT_BDS].width & (F - 1));
+		if (!IS_ALIGNED(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f))
+			acc->stripe.down_scaled_stripes[1].width +=
+				(css_pipe->rect[IPU3_CSS_RECT_BDS].width
+				& (f - 1)) - f;
 
 		acc->stripe.effective_stripes[0].width = bds_ds *
 			acc->stripe.down_scaled_stripes[0].width /
@@ -1819,55 +1835,55 @@ static void ipu3_css_cfg_acc_stripe(struct ipu3_css *css,
 			acc->stripe.down_scaled_stripes[1].width /
 			IMGU_BDS_GRANULARITY;
 		acc->stripe.effective_stripes[1].height =
-			css->rect[IPU3_CSS_RECT_EFFECTIVE].height;
+			css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height;
 		acc->stripe.effective_stripes[1].offset = bds_ds *
 			acc->stripe.down_scaled_stripes[1].offset /
 			IMGU_BDS_GRANULARITY;
 
 		acc->stripe.bds_out_stripes_no_overlap[0].width =
 		acc->stripe.bds_out_stripes_no_overlap[1].offset =
-			ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, 2 * F) / 2;
+			ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, 2 * f) / 2;
 		acc->stripe.bds_out_stripes_no_overlap[1].width =
-			DIV_ROUND_UP(css->rect[IPU3_CSS_RECT_BDS].width, F) /
-			2 * F;
+			DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f)
+			/ 2 * f;
 		acc->stripe.bds_out_stripes_no_overlap[1].height =
-			css->rect[IPU3_CSS_RECT_BDS].height;
+			css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 
 		acc->stripe.output_stripes[0].width =
-			acc->stripe.down_scaled_stripes[0].width - F;
+			acc->stripe.down_scaled_stripes[0].width - f;
 		acc->stripe.output_stripes[1].width =
-			acc->stripe.down_scaled_stripes[1].width - F;
+			acc->stripe.down_scaled_stripes[1].width - f;
 		acc->stripe.output_stripes[1].height =
-			css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 		acc->stripe.output_stripes[1].offset =
 			acc->stripe.output_stripes[0].width;
 	}
 
 	acc->stripe.output_system_in_frame_width =
-		css->rect[IPU3_CSS_RECT_GDC].width;
+		css_pipe->rect[IPU3_CSS_RECT_GDC].width;
 	acc->stripe.output_system_in_frame_height =
-		css->rect[IPU3_CSS_RECT_GDC].height;
+		css_pipe->rect[IPU3_CSS_RECT_GDC].height;
 
 	acc->stripe.effective_frame_width =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].width;
-	acc->stripe.bds_frame_width = css->rect[IPU3_CSS_RECT_BDS].width;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].width;
+	acc->stripe.bds_frame_width = css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	acc->stripe.out_frame_width =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	acc->stripe.out_frame_height =
-		css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	acc->stripe.gdc_in_buffer_width =
-		css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline /
-		css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline /
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel;
 	acc->stripe.gdc_in_buffer_height =
-		css->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
 	acc->stripe.gdc_in_buffer_offset_x = IMGU_GDC_BUF_X;
 	acc->stripe.gdc_in_buffer_offset_y = IMGU_GDC_BUF_Y;
 	acc->stripe.display_frame_width =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	acc->stripe.display_frame_height =
-		css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	acc->stripe.bds_aligned_frame_width =
-		roundup(css->rect[IPU3_CSS_RECT_BDS].width,
+		roundup(css_pipe->rect[IPU3_CSS_RECT_BDS].width,
 			2 * IPU3_UAPI_ISP_VEC_ELEMS);
 
 	if (stripes > 1)
@@ -1878,13 +1894,15 @@ static void ipu3_css_cfg_acc_stripe(struct ipu3_css *css,
 }
 
 static void ipu3_css_cfg_acc_dvs(struct ipu3_css *css,
-				 struct imgu_abi_acc_param *acc)
+				 struct imgu_abi_acc_param *acc,
+				 unsigned int pipe)
 {
 	unsigned int i;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
 	/* Disable DVS statistics */
 	acc->dvs_stat.operations_data.process_lines_data[0].lines =
-				css->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	acc->dvs_stat.operations_data.process_lines_data[0].cfg_set = 0;
 	acc->dvs_stat.operations_data.ops[0].op_type =
 		IMGU_ABI_ACC_OPTYPE_PROCESS_LINES;
@@ -1896,8 +1914,10 @@ static void ipu3_css_cfg_acc_dvs(struct ipu3_css *css,
 
 static void acc_bds_per_stripe_data(struct ipu3_css *css,
 				    struct imgu_abi_acc_param *acc,
-				    const int i)
+				    const int i, unsigned int pipe)
 {
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+
 	acc->bds.per_stripe.aligned_data[i].data.crop.hor_crop_en = 0;
 	acc->bds.per_stripe.aligned_data[i].data.crop.hor_crop_start = 0;
 	acc->bds.per_stripe.aligned_data[i].data.crop.hor_crop_end = 0;
@@ -1908,7 +1928,7 @@ static void acc_bds_per_stripe_data(struct ipu3_css *css,
 	acc->bds.per_stripe.aligned_data[i].data.ver_ctrl1.out_frame_width =
 		acc->stripe.down_scaled_stripes[i].width;
 	acc->bds.per_stripe.aligned_data[i].data.ver_ctrl1.out_frame_height =
-		css->rect[IPU3_CSS_RECT_BDS].height;
+		css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 }
 
 /*
@@ -1917,19 +1937,21 @@ static void acc_bds_per_stripe_data(struct ipu3_css *css,
  * telling which fields to take from the old values (or generate if it is NULL)
  * and which to take from the new user values.
  */
-int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
+		     struct ipu3_uapi_flags *use,
 		     struct imgu_abi_acc_param *acc,
 		     struct imgu_abi_acc_param *acc_old,
 		     struct ipu3_uapi_acc_param *acc_user)
 {
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
-		&css->fwp->binary_header[css->current_binary];
+		&css->fwp->binary_header[css_pipe->bindex];
 	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
 	const unsigned int tnr_frame_width =
 		acc->stripe.bds_aligned_frame_width;
 	const unsigned int min_overlap = 10;
 	const struct v4l2_pix_format_mplane *pixm =
-		&css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix;
+		&css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix;
 	const struct ipu3_css_bds_config *cfg_bds;
 	struct imgu_abi_input_feeder_data *feeder_data;
 
@@ -1938,21 +1960,21 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 
 	/* Update stripe using chroma and luma */
 
-	ipu3_css_cfg_acc_stripe(css, acc);
+	ipu3_css_cfg_acc_stripe(css, pipe, acc);
 
 	/* acc_param: input_feeder_config */
 
 	ofs_x = ((pixm->width -
-		  css->rect[IPU3_CSS_RECT_EFFECTIVE].width) >> 1) & ~1;
-	ofs_x += css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
+		  css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].width) >> 1) & ~1;
+	ofs_x += css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
 		IMGU_ABI_BAYER_ORDER_RGGB ||
-		css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
 		IMGU_ABI_BAYER_ORDER_GBRG ? 1 : 0;
 	ofs_y = ((pixm->height -
-		  css->rect[IPU3_CSS_RECT_EFFECTIVE].height) >> 1) & ~1;
-	ofs_y += css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
+		  css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height) >> 1) & ~1;
+	ofs_y += css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
 		IMGU_ABI_BAYER_ORDER_BGGR ||
-		css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order ==
 		IMGU_ABI_BAYER_ORDER_GBRG ? 1 : 0;
 	acc->input_feeder.data.row_stride = pixm->plane_fmt[0].bytesperline;
 	acc->input_feeder.data.start_row_address =
@@ -2108,11 +2130,11 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 				acc->shd.shd.grid.grid_height_per_slice;
 
 	if (ipu3_css_shd_ops_calc(&acc->shd.shd_ops, &acc->shd.shd.grid,
-				  css->rect[IPU3_CSS_RECT_BDS].height))
+				  css_pipe->rect[IPU3_CSS_RECT_BDS].height))
 		return -EINVAL;
 
 	/* acc_param: dvs_stat_config */
-	ipu3_css_cfg_acc_dvs(css, acc);
+	ipu3_css_cfg_acc_dvs(css, acc, pipe);
 
 	/* acc_param: yuvp1_iefd_config */
 
@@ -2254,8 +2276,8 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 
 	/* acc_param: bds_config */
 
-	bds_ds = (css->rect[IPU3_CSS_RECT_EFFECTIVE].height *
-		  IMGU_BDS_GRANULARITY) / css->rect[IPU3_CSS_RECT_BDS].height;
+	bds_ds = (css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height *
+		  IMGU_BDS_GRANULARITY) / css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	if (bds_ds < IMGU_BDS_MIN_SF_INV ||
 	    bds_ds - IMGU_BDS_MIN_SF_INV >= ARRAY_SIZE(ipu3_css_bds_configs))
 		return -EINVAL;
@@ -2270,11 +2292,11 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	acc->bds.hor.hor_ctrl0.min_clip_val = IMGU_BDS_MIN_CLIP_VAL;
 	acc->bds.hor.hor_ctrl0.max_clip_val = IMGU_BDS_MAX_CLIP_VAL;
 	acc->bds.hor.hor_ctrl0.out_frame_width =
-				css->rect[IPU3_CSS_RECT_BDS].width;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	acc->bds.hor.hor_ptrn_arr = cfg_bds->ptrn_arr;
 	acc->bds.hor.hor_phase_arr = cfg_bds->hor_phase_arr;
 	acc->bds.hor.hor_ctrl2.input_frame_height =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].height;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height;
 	acc->bds.ver.ver_ctrl0.min_clip_val = IMGU_BDS_MIN_CLIP_VAL;
 	acc->bds.ver.ver_ctrl0.max_clip_val = IMGU_BDS_MAX_CLIP_VAL;
 	acc->bds.ver.ver_ctrl0.sample_patrn_length =
@@ -2283,11 +2305,11 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	acc->bds.ver.ver_ptrn_arr = cfg_bds->ptrn_arr;
 	acc->bds.ver.ver_phase_arr = cfg_bds->ver_phase_arr;
 	acc->bds.ver.ver_ctrl1.out_frame_width =
-				css->rect[IPU3_CSS_RECT_BDS].width;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	acc->bds.ver.ver_ctrl1.out_frame_height =
-				css->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	for (i = 0; i < stripes; i++)
-		acc_bds_per_stripe_data(css, acc, i);
+		acc_bds_per_stripe_data(css, acc, i, pipe);
 
 	acc->bds.enabled = cfg_bds->hor_ds_en || cfg_bds->ver_ds_en;
 
@@ -2317,15 +2339,15 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	acc->anr.transform.enable = 1;
 	acc->anr.tile2strm.enable = 1;
 	acc->anr.tile2strm.frame_width =
-		ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
+		ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
 	acc->anr.search.frame_width = acc->anr.tile2strm.frame_width;
 	acc->anr.stitch.frame_width = acc->anr.tile2strm.frame_width;
-	acc->anr.tile2strm.frame_height = css->rect[IPU3_CSS_RECT_BDS].height;
+	acc->anr.tile2strm.frame_height = css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	acc->anr.search.frame_height = acc->anr.tile2strm.frame_height;
 	acc->anr.stitch.frame_height = acc->anr.tile2strm.frame_height;
 
-	width = ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
-	height = css->rect[IPU3_CSS_RECT_BDS].height;
+	width = ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
+	height = css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 
 	if (acc->anr.transform.xreset + width > IPU3_UAPI_ANR_MAX_RESET)
 		acc->anr.transform.xreset = IPU3_UAPI_ANR_MAX_RESET - width;
@@ -2409,7 +2431,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 			acc->awb_fr.stripes[i].grid_cfg.height_per_slice = 1;
 	}
 
-	if (ipu3_css_awb_fr_ops_calc(css, &acc->awb_fr))
+	if (ipu3_css_awb_fr_ops_calc(css, pipe, &acc->awb_fr))
 		return -EINVAL;
 
 	/* acc_param: ae_config */
@@ -2511,9 +2533,9 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	acc->af.config.grid_cfg.height_per_slice =
 		IMGU_ABI_AF_MAX_CELLS_PER_SET / acc->af.config.grid_cfg.width;
 	acc->af.config.frame_size.width =
-		ALIGN(css->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
+		ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, IMGU_ISP_VMEM_ALIGN);
 	acc->af.config.frame_size.height =
-		css->rect[IPU3_CSS_RECT_BDS].height;
+		css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 
 	if (acc->stripe.bds_out_stripes[0].width <= min_overlap)
 		return -EINVAL;
@@ -2521,7 +2543,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	for (i = 0; i < stripes; i++) {
 		acc->af.stripes[i].grid_cfg = acc->af.config.grid_cfg;
 		acc->af.stripes[i].frame_size.height =
-				css->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 		acc->af.stripes[i].frame_size.width =
 			acc->stripe.bds_out_stripes[i].width;
 	}
@@ -2572,7 +2594,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 			acc->af.stripes[i].grid_cfg.height_per_slice = 1;
 	}
 
-	if (ipu3_css_af_ops_calc(css, &acc->af))
+	if (ipu3_css_af_ops_calc(css, pipe, &acc->af))
 		return -EINVAL;
 
 	/* acc_param: awb_config */
@@ -2641,7 +2663,7 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 			acc->awb.stripes[i].grid.height_per_slice = 1;
 	}
 
-	if (ipu3_css_awb_ops_calc(css, &acc->awb))
+	if (ipu3_css_awb_ops_calc(css, pipe, &acc->awb))
 		return -EINVAL;
 
 	return 0;
@@ -2656,7 +2678,8 @@ int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
  * to the structure inside `new_binary_params'. In that case the caller
  * should calculate and fill the structure from scratch.
  */
-static void *ipu3_css_cfg_copy(struct ipu3_css *css, bool use_user,
+static void *ipu3_css_cfg_copy(struct ipu3_css *css,
+			       unsigned int pipe, bool use_user,
 			       void *user_setting, void *old_binary_params,
 			       void *new_binary_params,
 			       enum imgu_abi_memories m,
@@ -2666,8 +2689,8 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css, bool use_user,
 	const enum imgu_abi_param_class c = IMGU_ABI_PARAM_CLASS_PARAM;
 	void *new_setting, *old_setting;
 
-	new_setting = ipu3_css_fw_pipeline_params(css, c, m, par, par_size,
-						  new_binary_params);
+	new_setting = ipu3_css_fw_pipeline_params(css, pipe, c, m, par,
+						  par_size, new_binary_params);
 	if (!new_setting)
 		return ERR_PTR(-EPROTO);	/* Corrupted firmware */
 
@@ -2676,7 +2699,7 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css, bool use_user,
 		memcpy(new_setting, user_setting, par_size);
 	} else if (old_binary_params) {
 		/* Take previous value */
-		old_setting = ipu3_css_fw_pipeline_params(css, c, m, par,
+		old_setting = ipu3_css_fw_pipeline_params(css, pipe, c, m, par,
 							  par_size,
 							  old_binary_params);
 		if (!old_setting)
@@ -2692,12 +2715,13 @@ static void *ipu3_css_cfg_copy(struct ipu3_css *css, bool use_user,
 /*
  * Configure VMEM0 parameters (late binding parameters).
  */
-int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_uapi_flags *use,
 		       void *vmem0, void *vmem0_old,
 		       struct ipu3_uapi_params *user)
 {
 	const struct imgu_fw_info *bi =
-		&css->fwp->binary_header[css->current_binary];
+		&css->fwp->binary_header[css->pipes[pipe].bindex];
 	struct imgu_fw_param_memory_offsets *pofs = (void *)css->fwp +
 		bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_PARAM];
 	struct ipu3_uapi_isp_lin_vmem_params *lin_vmem = NULL;
@@ -2713,7 +2737,7 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 
 	/* Configure Linearization VMEM0 parameters */
 
-	lin_vmem = ipu3_css_cfg_copy(css, use && use->lin_vmem_params,
+	lin_vmem = ipu3_css_cfg_copy(css, pipe, use && use->lin_vmem_params,
 				     &user->lin_vmem_params, vmem0_old, vmem0,
 				     m, &pofs->vmem.lin, sizeof(*lin_vmem));
 	if (!IS_ERR_OR_NULL(lin_vmem)) {
@@ -2732,8 +2756,9 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	}
 
 	/* Configure TNR3 VMEM parameters */
-	if (css->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		tnr_vmem = ipu3_css_cfg_copy(css, use && use->tnr3_vmem_params,
+	if (css->pipes[pipe].pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
+		tnr_vmem = ipu3_css_cfg_copy(css, pipe,
+					     use && use->tnr3_vmem_params,
 					     &user->tnr3_vmem_params,
 					     vmem0_old, vmem0, m,
 					     &pofs->vmem.tnr3,
@@ -2748,7 +2773,7 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 
 	/* Configure XNR3 VMEM parameters */
 
-	xnr_vmem = ipu3_css_cfg_copy(css, use && use->xnr3_vmem_params,
+	xnr_vmem = ipu3_css_cfg_copy(css, pipe, use && use->xnr3_vmem_params,
 				     &user->xnr3_vmem_params, vmem0_old, vmem0,
 				     m, &pofs->vmem.xnr3, sizeof(*xnr_vmem));
 	if (!IS_ERR_OR_NULL(xnr_vmem)) {
@@ -2769,12 +2794,14 @@ int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 /*
  * Configure DMEM0 parameters (late binding parameters).
  */
-int ipu3_css_cfg_dmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_uapi_flags *use,
 		       void *dmem0, void *dmem0_old,
 		       struct ipu3_uapi_params *user)
 {
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
-		&css->fwp->binary_header[css->current_binary];
+		&css->fwp->binary_header[css_pipe->bindex];
 	struct imgu_fw_param_memory_offsets *pofs = (void *)css->fwp +
 		bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_PARAM];
 
@@ -2789,10 +2816,12 @@ int ipu3_css_cfg_dmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 	memset(dmem0, 0, bi->info.isp.sp.mem_initializers.params[c][m].size);
 
 	/* Configure TNR3 DMEM0 parameters */
-	if (css->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		tnr_dmem = ipu3_css_cfg_copy(css, use && use->tnr3_dmem_params,
-					     &user->tnr3_dmem_params, dmem0_old,
-					     dmem0, m, &pofs->dmem.tnr3,
+	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
+		tnr_dmem = ipu3_css_cfg_copy(css, pipe,
+					     use && use->tnr3_dmem_params,
+					     &user->tnr3_dmem_params,
+					     dmem0_old, dmem0, m,
+					     &pofs->dmem.tnr3,
 					     sizeof(*tnr_dmem));
 		if (!IS_ERR_OR_NULL(tnr_dmem)) {
 			/* Generate parameter from scratch */
@@ -2803,7 +2832,7 @@ int ipu3_css_cfg_dmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
 
 	/* Configure XNR3 DMEM0 parameters */
 
-	xnr_dmem = ipu3_css_cfg_copy(css, use && use->xnr3_dmem_params,
+	xnr_dmem = ipu3_css_cfg_copy(css, pipe, use && use->xnr3_dmem_params,
 				     &user->xnr3_dmem_params, dmem0_old, dmem0,
 				     m, &pofs->dmem.xnr3, sizeof(*xnr_dmem));
 	if (!IS_ERR_OR_NULL(xnr_dmem)) {
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-params.h b/drivers/media/pci/intel/ipu3/ipu3-css-params.h
index f93ed027..f3a0a47 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css-params.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-params.h
@@ -4,16 +4,19 @@
 #ifndef __IPU3_PARAMS_H
 #define __IPU3_PARAMS_H
 
-int ipu3_css_cfg_acc(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
+		     struct ipu3_uapi_flags *use,
 		     struct imgu_abi_acc_param *acc,
 		     struct imgu_abi_acc_param *acc_old,
 		     struct ipu3_uapi_acc_param *acc_user);
 
-int ipu3_css_cfg_vmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_uapi_flags *use,
 		       void *vmem0, void *vmem0_old,
 		       struct ipu3_uapi_params *user);
 
-int ipu3_css_cfg_dmem0(struct ipu3_css *css, struct ipu3_uapi_flags *use,
+int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_uapi_flags *use,
 		       void *dmem0, void *dmem0_old,
 		       struct ipu3_uapi_params *user);
 
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.c b/drivers/media/pci/intel/ipu3/ipu3-css.c
index c63b387..753913c 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-css.c
@@ -659,27 +659,28 @@ static void ipu3_css_hw_cleanup(struct ipu3_css *css)
 	usleep_range(200, 300);
 }
 
-static void ipu3_css_pipeline_cleanup(struct ipu3_css *css)
+static void ipu3_css_pipeline_cleanup(struct ipu3_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i;
 
-	ipu3_css_pool_cleanup(imgu, &css->pool.parameter_set_info);
-	ipu3_css_pool_cleanup(imgu, &css->pool.acc);
-	ipu3_css_pool_cleanup(imgu, &css->pool.gdc);
-	ipu3_css_pool_cleanup(imgu, &css->pool.obgrid);
+	ipu3_css_pool_cleanup(imgu,
+			      &css->pipes[pipe].pool.parameter_set_info);
+	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.acc);
+	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.gdc);
+	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.obgrid);
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-		ipu3_css_pool_cleanup(imgu, &css->pool.binary_params_p[i]);
+		ipu3_css_pool_cleanup(imgu,
+				      &css->pipes[pipe].pool.binary_params_p[i]);
 }
 
 /*
  * This function initializes various stages of the
  * IPU3 CSS ISP pipeline
  */
-static int ipu3_css_pipeline_init(struct ipu3_css *css)
+static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 {
-	static const unsigned int PIPE_ID = IPU3_CSS_PIPE_ID_VIDEO;
 	static const int BYPC = 2;	/* Bytes per component */
 	static const struct imgu_abi_buffer_sp buffer_sp_init = {
 		.buf_src = {.queue_id = IMGU_ABI_QUEUE_EVENT_ID},
@@ -693,11 +694,12 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	struct imgu_abi_isp_ref_dmem_state *cfg_ref_state;
 	struct imgu_abi_isp_tnr3_dmem_state *cfg_tnr_state;
 
-	const int pipe = 0, stage = 0, thread = 0;
+	const int stage = 0;
 	unsigned int i, j;
 
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 	const struct imgu_fw_info *bi =
-				&css->fwp->binary_header[css->current_binary];
+			&css->fwp->binary_header[css_pipe->bindex];
 	const unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
 
 	struct imgu_fw_config_memory_offsets *cofs = (void *)css->fwp +
@@ -710,103 +712,107 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	struct imgu_abi_sp_group *sp_group;
 
 	const unsigned int bds_width_pad =
-				ALIGN(css->rect[IPU3_CSS_RECT_BDS].width,
+				ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width,
 				      2 * IPU3_UAPI_ISP_VEC_ELEMS);
 
 	const enum imgu_abi_memories m0 = IMGU_ABI_MEM_ISP_DMEM0;
 	enum imgu_abi_param_class cfg = IMGU_ABI_PARAM_CLASS_CONFIG;
-	void *vaddr = css->binary_params_cs[cfg - 1][m0].vaddr;
+	void *vaddr = css_pipe->binary_params_cs[cfg - 1][m0].vaddr;
 
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 
+	dev_dbg(css->dev, "%s for pipe %d", __func__, pipe);
+
 	/* Configure iterator */
 
-	cfg_iter = ipu3_css_fw_pipeline_params(css, cfg, m0,
+	cfg_iter = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
 					       &cofs->dmem.iterator,
 					       sizeof(*cfg_iter), vaddr);
 	if (!cfg_iter)
 		goto bad_firmware;
 
 	cfg_iter->input_info.res.width =
-				css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
 	cfg_iter->input_info.res.height =
-				css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
 	cfg_iter->input_info.padded_width =
-				css->queue[IPU3_CSS_QUEUE_IN].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].width_pad;
 	cfg_iter->input_info.format =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
 	cfg_iter->input_info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
 	cfg_iter->input_info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
 	cfg_iter->input_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
-	cfg_iter->internal_info.res.width = css->rect[IPU3_CSS_RECT_BDS].width;
+	cfg_iter->internal_info.res.width = css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	cfg_iter->internal_info.res.height =
-					css->rect[IPU3_CSS_RECT_BDS].height;
+					css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	cfg_iter->internal_info.padded_width = bds_width_pad;
 	cfg_iter->internal_info.format =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	cfg_iter->internal_info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	cfg_iter->internal_info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	cfg_iter->internal_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	cfg_iter->output_info.res.width =
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	cfg_iter->output_info.res.height =
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	cfg_iter->output_info.padded_width =
-				css->queue[IPU3_CSS_QUEUE_OUT].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 	cfg_iter->output_info.format =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	cfg_iter->output_info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	cfg_iter->output_info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	cfg_iter->output_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	cfg_iter->vf_info.res.width =
-			css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	cfg_iter->vf_info.res.height =
-			css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	cfg_iter->vf_info.padded_width =
-			css->queue[IPU3_CSS_QUEUE_VF].width_pad;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 	cfg_iter->vf_info.format =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
 	cfg_iter->vf_info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
 	cfg_iter->vf_info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
 	cfg_iter->vf_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
-	cfg_iter->dvs_envelope.width = css->rect[IPU3_CSS_RECT_ENVELOPE].width;
+	cfg_iter->dvs_envelope.width = css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
 	cfg_iter->dvs_envelope.height =
-				css->rect[IPU3_CSS_RECT_ENVELOPE].height;
+				css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].height;
 
 	/* Configure reference (delay) frames */
 
-	cfg_ref = ipu3_css_fw_pipeline_params(css, cfg, m0, &cofs->dmem.ref,
+	cfg_ref = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
+					      &cofs->dmem.ref,
 					      sizeof(*cfg_ref), vaddr);
 	if (!cfg_ref)
 		goto bad_firmware;
 
 	cfg_ref->port_b.crop = 0;
 	cfg_ref->port_b.elems = IMGU_ABI_ISP_DDR_WORD_BYTES / BYPC;
-	cfg_ref->port_b.width = css->aux_frames[IPU3_CSS_AUX_FRAME_REF].width;
+	cfg_ref->port_b.width =
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].width;
 	cfg_ref->port_b.stride =
-			css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline;
 	cfg_ref->width_a_over_b =
 				IPU3_UAPI_ISP_VEC_ELEMS / cfg_ref->port_b.elems;
 	cfg_ref->dvs_frame_delay = IPU3_CSS_AUX_FRAMES - 1;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++) {
 		cfg_ref->ref_frame_addr_y[i] =
-			css->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr;
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr;
 		cfg_ref->ref_frame_addr_c[i] =
-			css->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr +
-			css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline *
-			css->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr +
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline *
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
 	}
 	for (; i < IMGU_ABI_FRAMES_REF; i++) {
 		cfg_ref->ref_frame_addr_y[i] = 0;
@@ -815,23 +821,23 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 
 	/* Configure DVS (digital video stabilization) */
 
-	cfg_dvs = ipu3_css_fw_pipeline_params(css, cfg, m0,
+	cfg_dvs = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
 					      &cofs->dmem.dvs, sizeof(*cfg_dvs),
 					      vaddr);
 	if (!cfg_dvs)
 		goto bad_firmware;
 
 	cfg_dvs->num_horizontal_blocks =
-			ALIGN(DIV_ROUND_UP(css->rect[IPU3_CSS_RECT_GDC].width,
+			ALIGN(DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_GDC].width,
 					   IMGU_DVS_BLOCK_W), 2);
 	cfg_dvs->num_vertical_blocks =
-			DIV_ROUND_UP(css->rect[IPU3_CSS_RECT_GDC].height,
+			DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_GDC].height,
 				     IMGU_DVS_BLOCK_H);
 
 	/* Configure TNR (temporal noise reduction) */
 
-	if (css->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
-		cfg_tnr = ipu3_css_fw_pipeline_params(css, cfg, m0,
+	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
+		cfg_tnr = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
 						      &cofs->dmem.tnr3,
 						      sizeof(*cfg_tnr),
 						      vaddr);
@@ -841,17 +847,17 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 		cfg_tnr->port_b.crop = 0;
 		cfg_tnr->port_b.elems = IMGU_ABI_ISP_DDR_WORD_BYTES;
 		cfg_tnr->port_b.width =
-				css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width;
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width;
 		cfg_tnr->port_b.stride =
-			css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline;
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline;
 		cfg_tnr->width_a_over_b =
-				IPU3_UAPI_ISP_VEC_ELEMS / cfg_tnr->port_b.elems;
+			IPU3_UAPI_ISP_VEC_ELEMS / cfg_tnr->port_b.elems;
 		cfg_tnr->frame_height =
-				css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
+			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
 		cfg_tnr->delay_frame = IPU3_CSS_AUX_FRAMES - 1;
 		for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
 			cfg_tnr->frame_addr[i] =
-					css->aux_frames[IPU3_CSS_AUX_FRAME_TNR]
+				css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR]
 					.mem[i].daddr;
 		for (; i < IMGU_ABI_FRAMES_TNR; i++)
 			cfg_tnr->frame_addr[i] = 0;
@@ -860,9 +866,9 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	/* Configure ref dmem state parameters */
 
 	cfg = IMGU_ABI_PARAM_CLASS_STATE;
-	vaddr = css->binary_params_cs[cfg - 1][m0].vaddr;
+	vaddr = css_pipe->binary_params_cs[cfg - 1][m0].vaddr;
 
-	cfg_ref_state = ipu3_css_fw_pipeline_params(css, cfg, m0,
+	cfg_ref_state = ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
 						    &sofs->dmem.ref,
 						    sizeof(*cfg_ref_state),
 						    vaddr);
@@ -873,9 +879,9 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	cfg_ref_state->ref_out_buf_idx = 1;
 
 	/* Configure tnr dmem state parameters */
-	if (css->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
+	if (css_pipe->pipe_id == IPU3_CSS_PIPE_ID_VIDEO) {
 		cfg_tnr_state =
-			ipu3_css_fw_pipeline_params(css, cfg, m0,
+			ipu3_css_fw_pipeline_params(css, pipe, cfg, m0,
 						    &sofs->dmem.tnr3,
 						    sizeof(*cfg_tnr_state),
 						    vaddr);
@@ -892,22 +898,22 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 
 	/* Configure ISP stage */
 
-	isp_stage = css->xmem_isp_stage_ptrs[pipe][stage].vaddr;
+	isp_stage = css_pipe->xmem_isp_stage_ptrs[pipe][stage].vaddr;
 	memset(isp_stage, 0, sizeof(*isp_stage));
 	isp_stage->blob_info = bi->blob;
 	isp_stage->binary_info = bi->info.isp.sp;
 	strlcpy(isp_stage->binary_name,
-		(char *)css->fwp + bi->blob.prog_name_offset,
-		sizeof(isp_stage->binary_name));
+	       (char *)css->fwp + bi->blob.prog_name_offset,
+	       sizeof(isp_stage->binary_name));
 	isp_stage->mem_initializers = bi->info.isp.sp.mem_initializers;
 	for (i = IMGU_ABI_PARAM_CLASS_CONFIG; i < IMGU_ABI_PARAM_CLASS_NUM; i++)
 		for (j = 0; j < IMGU_ABI_NUM_MEMORIES; j++)
 			isp_stage->mem_initializers.params[i][j].address =
-					css->binary_params_cs[i - 1][j].daddr;
+					css_pipe->binary_params_cs[i - 1][j].daddr;
 
 	/* Configure SP stage */
 
-	sp_stage = css->xmem_sp_stage_ptrs[pipe][stage].vaddr;
+	sp_stage = css_pipe->xmem_sp_stage_ptrs[pipe][stage].vaddr;
 	memset(sp_stage, 0, sizeof(*sp_stage));
 
 	sp_stage->frames.in.buf_attr = buffer_sp_init;
@@ -923,48 +929,45 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	sp_stage->isp_copy_vf = 0;
 	sp_stage->isp_copy_output = 0;
 
-	/* Enable VF output only when VF or PV queue requested by user */
-
-	sp_stage->enable.vf_output =
-				(css->vf_output_en != IPU3_NODE_VF_DISABLED);
+	sp_stage->enable.vf_output = css_pipe->vf_output_en;
 
 	sp_stage->frames.effective_in_res.width =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].width;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].width;
 	sp_stage->frames.effective_in_res.height =
-				css->rect[IPU3_CSS_RECT_EFFECTIVE].height;
+				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height;
 	sp_stage->frames.in.info.res.width =
-				css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
 	sp_stage->frames.in.info.res.height =
-				css->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
 	sp_stage->frames.in.info.padded_width =
-					css->queue[IPU3_CSS_QUEUE_IN].width_pad;
+					css_pipe->queue[IPU3_CSS_QUEUE_IN].width_pad;
 	sp_stage->frames.in.info.format =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
 	sp_stage->frames.in.info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
 	sp_stage->frames.in.info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
 	sp_stage->frames.in.info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 	sp_stage->frames.in.buf_attr.buf_src.queue_id = IMGU_ABI_QUEUE_C_ID;
 	sp_stage->frames.in.buf_attr.buf_type =
 					IMGU_ABI_BUFFER_TYPE_INPUT_FRAME;
 
 	sp_stage->frames.out[0].info.res.width =
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	sp_stage->frames.out[0].info.res.height =
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	sp_stage->frames.out[0].info.padded_width =
-				css->queue[IPU3_CSS_QUEUE_OUT].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 	sp_stage->frames.out[0].info.format =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	sp_stage->frames.out[0].info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	sp_stage->frames.out[0].info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	sp_stage->frames.out[0].info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 	sp_stage->frames.out[0].planes.nv.uv.offset =
-				css->queue[IPU3_CSS_QUEUE_OUT].width_pad *
-				css->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad *
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	sp_stage->frames.out[0].buf_attr.buf_src.queue_id = IMGU_ABI_QUEUE_D_ID;
 	sp_stage->frames.out[0].buf_attr.buf_type =
 					IMGU_ABI_BUFFER_TYPE_OUTPUT_FRAME;
@@ -973,38 +976,38 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 							IMGU_ABI_QUEUE_EVENT_ID;
 
 	sp_stage->frames.internal_frame_info.res.width =
-					css->rect[IPU3_CSS_RECT_BDS].width;
+					css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	sp_stage->frames.internal_frame_info.res.height =
-					css->rect[IPU3_CSS_RECT_BDS].height;
+					css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	sp_stage->frames.internal_frame_info.padded_width = bds_width_pad;
 
 	sp_stage->frames.internal_frame_info.format =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	sp_stage->frames.internal_frame_info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	sp_stage->frames.internal_frame_info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	sp_stage->frames.internal_frame_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	sp_stage->frames.out_vf.info.res.width =
-				css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	sp_stage->frames.out_vf.info.res.height =
-				css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	sp_stage->frames.out_vf.info.padded_width =
-					css->queue[IPU3_CSS_QUEUE_VF].width_pad;
+					css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 	sp_stage->frames.out_vf.info.format =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
 	sp_stage->frames.out_vf.info.raw_bit_depth =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
 	sp_stage->frames.out_vf.info.raw_bayer_order =
-			css->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
 	sp_stage->frames.out_vf.info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 	sp_stage->frames.out_vf.planes.yuv.u.offset =
-				css->queue[IPU3_CSS_QUEUE_VF].width_pad *
-				css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad *
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	sp_stage->frames.out_vf.planes.yuv.v.offset =
-			css->queue[IPU3_CSS_QUEUE_VF].width_pad *
-			css->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height * 5 / 4;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad *
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height * 5 / 4;
 	sp_stage->frames.out_vf.buf_attr.buf_src.queue_id = IMGU_ABI_QUEUE_E_ID;
 	sp_stage->frames.out_vf.buf_attr.buf_type =
 					IMGU_ABI_BUFFER_TYPE_VF_OUTPUT_FRAME;
@@ -1015,16 +1018,16 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	sp_stage->frames.dvs_buf.buf_src.queue_id = IMGU_ABI_QUEUE_G_ID;
 	sp_stage->frames.dvs_buf.buf_type = IMGU_ABI_BUFFER_TYPE_DIS_STATISTICS;
 
-	sp_stage->dvs_envelope.width = css->rect[IPU3_CSS_RECT_ENVELOPE].width;
+	sp_stage->dvs_envelope.width = css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
 	sp_stage->dvs_envelope.height =
-				css->rect[IPU3_CSS_RECT_ENVELOPE].height;
+				css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].height;
 
 	sp_stage->isp_pipe_version =
 				bi->info.isp.sp.pipeline.isp_pipe_version;
 	sp_stage->isp_deci_log_factor =
-			clamp(max(fls(css->rect[IPU3_CSS_RECT_BDS].width /
+			clamp(max(fls(css_pipe->rect[IPU3_CSS_RECT_BDS].width /
 				      IMGU_MAX_BQ_GRID_WIDTH),
-				  fls(css->rect[IPU3_CSS_RECT_BDS].height /
+				  fls(css_pipe->rect[IPU3_CSS_RECT_BDS].height /
 				      IMGU_MAX_BQ_GRID_HEIGHT)) - 1, 3, 5);
 	sp_stage->isp_vf_downscale_bits = 0;
 	sp_stage->if_config_index = 255;
@@ -1033,52 +1036,54 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	sp_stage->enable.s3a = 1;
 	sp_stage->enable.dvs_stats = 0;
 
-	sp_stage->xmem_bin_addr = css->binary[css->current_binary].daddr;
-	sp_stage->xmem_map_addr = css->sp_ddr_ptrs.daddr;
-	sp_stage->isp_stage_addr = css->xmem_isp_stage_ptrs[pipe][stage].daddr;
+	sp_stage->xmem_bin_addr = css->binary[css_pipe->bindex].daddr;
+	sp_stage->xmem_map_addr = css_pipe->sp_ddr_ptrs.daddr;
+	sp_stage->isp_stage_addr =
+		css_pipe->xmem_isp_stage_ptrs[pipe][stage].daddr;
 
 	/* Configure SP group */
 
 	sp_group = css->xmem_sp_group_ptrs.vaddr;
-	memset(sp_group, 0, sizeof(*sp_group));
-
-	sp_group->pipe[thread].num_stages = 1;
-	sp_group->pipe[thread].pipe_id = PIPE_ID;
-	sp_group->pipe[thread].thread_id = thread;
-	sp_group->pipe[thread].pipe_num = pipe;
-	sp_group->pipe[thread].num_execs = -1;
-	sp_group->pipe[thread].pipe_qos_config = -1;
-	sp_group->pipe[thread].required_bds_factor = 0;
-	sp_group->pipe[thread].dvs_frame_delay = IPU3_CSS_AUX_FRAMES - 1;
-	sp_group->pipe[thread].inout_port_config =
+	memset(&sp_group->pipe[pipe], 0, sizeof(struct imgu_abi_sp_pipeline));
+
+	sp_group->pipe[pipe].num_stages = 1;
+	sp_group->pipe[pipe].pipe_id = css_pipe->pipe_id;
+	sp_group->pipe[pipe].thread_id = pipe;
+	sp_group->pipe[pipe].pipe_num = pipe;
+	sp_group->pipe[pipe].num_execs = -1;
+	sp_group->pipe[pipe].pipe_qos_config = -1;
+	sp_group->pipe[pipe].required_bds_factor = 0;
+	sp_group->pipe[pipe].dvs_frame_delay = IPU3_CSS_AUX_FRAMES - 1;
+	sp_group->pipe[pipe].inout_port_config =
 					IMGU_ABI_PORT_CONFIG_TYPE_INPUT_HOST |
 					IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_HOST;
-	sp_group->pipe[thread].scaler_pp_lut = 0;
-	sp_group->pipe[thread].shading.internal_frame_origin_x_bqs_on_sctbl = 0;
-	sp_group->pipe[thread].shading.internal_frame_origin_y_bqs_on_sctbl = 0;
-	sp_group->pipe[thread].sp_stage_addr[stage] =
-				css->xmem_sp_stage_ptrs[pipe][stage].daddr;
-	sp_group->pipe[thread].pipe_config =
-			bi->info.isp.sp.enable.params ? (1 << thread) : 0;
-	sp_group->pipe[thread].pipe_config |= IMGU_ABI_PIPE_CONFIG_ACQUIRE_ISP;
+	sp_group->pipe[pipe].scaler_pp_lut = 0;
+	sp_group->pipe[pipe].shading.internal_frame_origin_x_bqs_on_sctbl = 0;
+	sp_group->pipe[pipe].shading.internal_frame_origin_y_bqs_on_sctbl = 0;
+	sp_group->pipe[pipe].sp_stage_addr[stage] =
+			css_pipe->xmem_sp_stage_ptrs[pipe][stage].daddr;
+	sp_group->pipe[pipe].pipe_config =
+			bi->info.isp.sp.enable.params ? (1 << pipe) : 0;
+	sp_group->pipe[pipe].pipe_config |= IMGU_ABI_PIPE_CONFIG_ACQUIRE_ISP;
 
 	/* Initialize parameter pools */
 
-	if (ipu3_css_pool_init(imgu, &css->pool.parameter_set_info,
+	if (ipu3_css_pool_init(imgu, &css_pipe->pool.parameter_set_info,
 			       sizeof(struct imgu_abi_parameter_set_info)) ||
-	    ipu3_css_pool_init(imgu, &css->pool.acc,
+	    ipu3_css_pool_init(imgu, &css_pipe->pool.acc,
 			       sizeof(struct imgu_abi_acc_param)) ||
-	    ipu3_css_pool_init(imgu, &css->pool.gdc,
+	    ipu3_css_pool_init(imgu, &css_pipe->pool.gdc,
 			       sizeof(struct imgu_abi_gdc_warp_param) *
 			       3 * cfg_dvs->num_horizontal_blocks / 2 *
 			       cfg_dvs->num_vertical_blocks) ||
-	    ipu3_css_pool_init(imgu, &css->pool.obgrid,
+	    ipu3_css_pool_init(imgu, &css_pipe->pool.obgrid,
 			       ipu3_css_fw_obgrid_size(
-			       &css->fwp->binary_header[css->current_binary])))
+			       &css->fwp->binary_header[css_pipe->bindex])))
 		goto out_of_memory;
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-		if (ipu3_css_pool_init(imgu, &css->pool.binary_params_p[i],
+		if (ipu3_css_pool_init(imgu,
+				       &css_pipe->pool.binary_params_p[i],
 				       bi->info.isp.sp.mem_initializers.params
 				       [IMGU_ABI_PARAM_CLASS_PARAM][i].size))
 			goto out_of_memory;
@@ -1086,11 +1091,11 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css)
 	return 0;
 
 bad_firmware:
-	ipu3_css_pipeline_cleanup(css);
+	ipu3_css_pipeline_cleanup(css, pipe);
 	return -EPROTO;
 
 out_of_memory:
-	ipu3_css_pipeline_cleanup(css);
+	ipu3_css_pipeline_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
@@ -1193,134 +1198,147 @@ static int ipu3_css_dequeue_data(struct ipu3_css *css, int queue, u32 *data)
 }
 
 /* Free binary-specific resources */
-static void ipu3_css_binary_cleanup(struct ipu3_css *css)
+static void ipu3_css_binary_cleanup(struct ipu3_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i, j;
 
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+
 	for (j = 0; j < IMGU_ABI_PARAM_CLASS_NUM - 1; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-			ipu3_dmamap_free(imgu, &css->binary_params_cs[j][i]);
+			ipu3_dmamap_free(imgu,
+					 &css_pipe->binary_params_cs[j][i]);
 
 	j = IPU3_CSS_AUX_FRAME_REF;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		ipu3_dmamap_free(imgu, &css->aux_frames[j].mem[i]);
+		ipu3_dmamap_free(imgu,
+				 &css_pipe->aux_frames[j].mem[i]);
 
 	j = IPU3_CSS_AUX_FRAME_TNR;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		ipu3_dmamap_free(imgu, &css->aux_frames[j].mem[i]);
+		ipu3_dmamap_free(imgu,
+				 &css_pipe->aux_frames[j].mem[i]);
 }
 
-static int ipu3_css_binary_preallocate(struct ipu3_css *css)
+static int ipu3_css_binary_preallocate(struct ipu3_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
 	unsigned int i, j;
 
-	for (j = IMGU_ABI_PARAM_CLASS_CONFIG; j < IMGU_ABI_PARAM_CLASS_NUM; j++)
-		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++) {
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+
+	for (j = IMGU_ABI_PARAM_CLASS_CONFIG;
+	     j < IMGU_ABI_PARAM_CLASS_NUM; j++)
+		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
 			if (!ipu3_dmamap_alloc(imgu,
-				&css->binary_params_cs[j - 1][i],
-				CSS_ABI_SIZE))
+					       &css_pipe->binary_params_cs[j - 1][i],
+					       CSS_ABI_SIZE))
 				goto out_of_memory;
-		}
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
 		if (!ipu3_dmamap_alloc(imgu,
-			&css->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i],
-			CSS_BDS_SIZE))
+				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].
+				       mem[i], CSS_BDS_SIZE))
 			goto out_of_memory;
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
 		if (!ipu3_dmamap_alloc(imgu,
-			&css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].mem[i],
-			CSS_GDC_SIZE))
+				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].
+				       mem[i], CSS_GDC_SIZE))
 			goto out_of_memory;
 
 	return 0;
 
 out_of_memory:
-	ipu3_css_binary_cleanup(css);
+	ipu3_css_binary_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
 /* allocate binary-specific resources */
-static int ipu3_css_binary_setup(struct ipu3_css *css)
+static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 {
-	const struct imgu_abi_binary_info *sp =
-		&css->fwp->binary_header[css->current_binary].info.isp.sp;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	struct imgu_fw_info *bi = &css->fwp->binary_header[css_pipe->bindex];
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+	int i, j, size;
 	static const int BYPC = 2;	/* Bytes per component */
-	unsigned int w, h, size, i, j;
+	unsigned int w, h;
 
 	/* Allocate parameter memory blocks for this binary */
 
 	for (j = IMGU_ABI_PARAM_CLASS_CONFIG; j < IMGU_ABI_PARAM_CLASS_NUM; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++) {
 			if (ipu3_css_dma_buffer_resize(
-				imgu, &css->binary_params_cs[j - 1][i],
-				sp->mem_initializers.params[j][i].size))
+			    imgu,
+			    &css_pipe->binary_params_cs[j - 1][i],
+			    bi->info.isp.sp.mem_initializers.params[j][i].size))
 				goto out_of_memory;
 		}
 
 	/* Allocate internal frame buffers */
 
 	/* Reference frames for DVS, FRAME_FORMAT_YUV420_16 */
-	css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel = BYPC;
-	css->aux_frames[IPU3_CSS_AUX_FRAME_REF].width =
-					css->rect[IPU3_CSS_RECT_BDS].width;
-	css->aux_frames[IPU3_CSS_AUX_FRAME_REF].height =
-				ALIGN(css->rect[IPU3_CSS_RECT_BDS].height,
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel = BYPC;
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].width =
+					css_pipe->rect[IPU3_CSS_RECT_BDS].width;
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height =
+				ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].height,
 				      IMGU_DVS_BLOCK_H) + 2 * IMGU_GDC_BUF_Y;
-	h = css->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
-	w = ALIGN(css->rect[IPU3_CSS_RECT_BDS].width,
+	h = css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
+	w = ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width,
 		  2 * IPU3_UAPI_ISP_VEC_ELEMS) + 2 * IMGU_GDC_BUF_X;
-	css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline =
-		css->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel * w;
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline =
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel * w;
 	size = w * h * BYPC + (w / 2) * (h / 2) * BYPC * 2;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
 		if (ipu3_css_dma_buffer_resize(
 			imgu,
-			&css->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i], size))
+			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i],
+			size))
 			goto out_of_memory;
 
 	/* TNR frames for temporal noise reduction, FRAME_FORMAT_YUV_LINE */
-	css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperpixel = 1;
-	css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width =
-			roundup(css->rect[IPU3_CSS_RECT_GDC].width,
-				sp->block.block_width *
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperpixel = 1;
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width =
+			roundup(css_pipe->rect[IPU3_CSS_RECT_GDC].width,
+				bi->info.isp.sp.block.block_width *
 				IPU3_UAPI_ISP_VEC_ELEMS);
-	css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height =
-			roundup(css->rect[IPU3_CSS_RECT_GDC].height,
-				sp->block.output_block_height);
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height =
+			roundup(css_pipe->rect[IPU3_CSS_RECT_GDC].height,
+				bi->info.isp.sp.block.output_block_height);
 
-	w = css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width;
-	css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline = w;
-	h = css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
+	w = css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width;
+	css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline = w;
+	h = css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
 	size = w * ALIGN(h * 3 / 2 + 3, 2);	/* +3 for vf_pp prefetch */
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
 		if (ipu3_css_dma_buffer_resize(
 			imgu,
-			&css->aux_frames[IPU3_CSS_AUX_FRAME_TNR].mem[i], size))
+			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].mem[i],
+			size))
 			goto out_of_memory;
 
 	return 0;
 
 out_of_memory:
-	ipu3_css_binary_cleanup(css);
+	ipu3_css_binary_cleanup(css, pipe);
 	return -ENOMEM;
 }
 
 int ipu3_css_start_streaming(struct ipu3_css *css)
 {
 	u32 data;
-	int r;
+	int r, pipe;
 
 	if (css->streaming)
 		return -EPROTO;
 
-	r = ipu3_css_binary_setup(css);
-	if (r < 0)
-		return r;
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = ipu3_css_binary_setup(css, pipe);
+		if (r < 0)
+			return r;
+	}
 
 	r = ipu3_css_hw_init(css);
 	if (r < 0)
@@ -1330,19 +1348,23 @@ int ipu3_css_start_streaming(struct ipu3_css *css)
 	if (r < 0)
 		goto fail;
 
-	r = ipu3_css_pipeline_init(css);
-	if (r < 0)
-		goto fail;
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		css->pipes[pipe].frame = 0;
+		r = ipu3_css_pipeline_init(css, pipe);
+		if (r < 0)
+			goto fail;
+	}
 
 	css->streaming = true;
-	css->frame = 0;
 
 	ipu3_css_hw_enable_irq(css);
 
 	/* Initialize parameters to default */
-	r = ipu3_css_set_parameters(css, NULL);
-	if (r < 0)
-		goto fail;
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = ipu3_css_set_parameters(css, pipe, NULL);
+		if (r < 0)
+			goto fail;
+	}
 
 	while (!(r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_A_ID, &data)))
 		;
@@ -1354,18 +1376,23 @@ int ipu3_css_start_streaming(struct ipu3_css *css)
 	if (r != -EBUSY)
 		goto fail;
 
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, 0,
-				IMGU_ABI_EVENT_START_STREAM);
-	if (r < 0)
-		goto fail;
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+					IMGU_ABI_EVENT_START_STREAM |
+					pipe << 16);
+		if (r < 0)
+			goto fail;
+	}
 
 	return 0;
 
 fail:
 	css->streaming = false;
 	ipu3_css_hw_cleanup(css);
-	ipu3_css_pipeline_cleanup(css);
-	ipu3_css_binary_cleanup(css);
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		ipu3_css_pipeline_cleanup(css, pipe);
+		ipu3_css_binary_cleanup(css, pipe);
+	}
 
 	return r;
 }
@@ -1373,13 +1400,14 @@ int ipu3_css_start_streaming(struct ipu3_css *css)
 void ipu3_css_stop_streaming(struct ipu3_css *css)
 {
 	struct ipu3_css_buffer *b, *b0;
-	int q, r;
-
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, 0,
-				IMGU_ABI_EVENT_STOP_STREAM);
+	int q, r, pipe;
 
-	if (r < 0)
-		dev_warn(css->dev, "failed on stop stream event\n");
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+					IMGU_ABI_EVENT_STOP_STREAM);
+		if (r < 0)
+			dev_warn(css->dev, "failed on stop stream event\n");
+	}
 
 	if (!css->streaming)
 		return;
@@ -1388,58 +1416,132 @@ void ipu3_css_stop_streaming(struct ipu3_css *css)
 
 	ipu3_css_hw_cleanup(css);
 
-	ipu3_css_pipeline_cleanup(css);
+	for_each_set_bit(pipe, css->enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
-	spin_lock(&css->qlock);
-	for (q = 0; q < IPU3_CSS_QUEUES; q++)
-		list_for_each_entry_safe(b, b0, &css->queue[q].bufs, list) {
-			b->state = IPU3_CSS_BUFFER_FAILED;
-			list_del(&b->list);
-		}
-	spin_unlock(&css->qlock);
+		ipu3_css_pipeline_cleanup(css, pipe);
+
+		spin_lock(&css_pipe->qlock);
+		for (q = 0; q < IPU3_CSS_QUEUES; q++)
+			list_for_each_entry_safe(b, b0,
+						 &css_pipe->queue[q].bufs,
+						 list) {
+				b->state = IPU3_CSS_BUFFER_FAILED;
+				list_del(&b->list);
+			}
+		spin_unlock(&css_pipe->qlock);
+	}
 
 	css->streaming = false;
 }
 
-bool ipu3_css_queue_empty(struct ipu3_css *css)
+bool ipu3_css_pipe_queue_empty(struct ipu3_css *css, unsigned int pipe)
 {
 	int q;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
-	spin_lock(&css->qlock);
+	spin_lock(&css_pipe->qlock);
 	for (q = 0; q < IPU3_CSS_QUEUES; q++)
-		if (!list_empty(&css->queue[q].bufs))
+		if (!list_empty(&css_pipe->queue[q].bufs))
 			break;
-	spin_unlock(&css->qlock);
-
+	spin_unlock(&css_pipe->qlock);
 	return (q == IPU3_CSS_QUEUES);
 }
 
+bool ipu3_css_queue_empty(struct ipu3_css *css)
+{
+	unsigned int pipe;
+	bool ret = 0;
+
+	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++)
+		ret &= ipu3_css_pipe_queue_empty(css, pipe);
+
+	return ret;
+}
+
 bool ipu3_css_is_streaming(struct ipu3_css *css)
 {
 	return css->streaming;
 }
 
-void ipu3_css_cleanup(struct ipu3_css *css)
+static int ipu3_css_map_init(struct ipu3_css *css, unsigned int pipe)
 {
 	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 	unsigned int p, q, i;
 
-	ipu3_css_stop_streaming(css);
-	ipu3_css_binary_cleanup(css);
+	/* Allocate and map common structures with imgu hardware */
+	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
+		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
+			if (!ipu3_dmamap_alloc(imgu,
+					       &css_pipe->
+					       xmem_sp_stage_ptrs[p][i],
+					       sizeof(struct imgu_abi_sp_stage)))
+				return -ENOMEM;
+			if (!ipu3_dmamap_alloc(imgu,
+					       &css_pipe->
+					       xmem_isp_stage_ptrs[p][i],
+					       sizeof(struct imgu_abi_isp_stage)))
+				return -ENOMEM;
+		}
 
-	for (q = 0; q < IPU3_CSS_QUEUES; q++)
-		for (i = 0; i < ARRAY_SIZE(css->abi_buffers[q]); i++)
-			ipu3_dmamap_free(imgu, &css->abi_buffers[q][i]);
+	if (!ipu3_dmamap_alloc(imgu, &css_pipe->sp_ddr_ptrs,
+			       ALIGN(sizeof(struct imgu_abi_ddr_address_map),
+				     IMGU_ABI_ISP_DDR_WORD_BYTES)))
+		return -ENOMEM;
+
+	for (q = 0; q < IPU3_CSS_QUEUES; q++) {
+		unsigned int abi_buf_num = ARRAY_SIZE(css_pipe->abi_buffers[q]);
+
+		for (i = 0; i < abi_buf_num; i++)
+			if (!ipu3_dmamap_alloc(imgu,
+					       &css_pipe->abi_buffers[q][i],
+					       sizeof(struct imgu_abi_buffer)))
+				return -ENOMEM;
+	}
+
+	if (ipu3_css_binary_preallocate(css, pipe)) {
+		ipu3_css_binary_cleanup(css, pipe);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void ipu3_css_pipe_cleanup(struct ipu3_css *css, unsigned int pipe)
+{
+	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	unsigned int p, q, i, abi_buf_num;
+
+	ipu3_css_binary_cleanup(css, pipe);
+
+	for (q = 0; q < IPU3_CSS_QUEUES; q++) {
+		abi_buf_num = ARRAY_SIZE(css_pipe->abi_buffers[q]);
+		for (i = 0; i < abi_buf_num; i++)
+			ipu3_dmamap_free(imgu, &css_pipe->abi_buffers[q][i]);
+	}
 
 	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
 		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
-			ipu3_dmamap_free(imgu, &css->xmem_sp_stage_ptrs[p][i]);
-			ipu3_dmamap_free(imgu, &css->xmem_isp_stage_ptrs[p][i]);
+			ipu3_dmamap_free(imgu,
+					 &css_pipe->xmem_sp_stage_ptrs[p][i]);
+			ipu3_dmamap_free(imgu,
+					 &css_pipe->xmem_isp_stage_ptrs[p][i]);
 		}
 
-	ipu3_dmamap_free(imgu, &css->sp_ddr_ptrs);
-	ipu3_dmamap_free(imgu, &css->xmem_sp_group_ptrs);
+	ipu3_dmamap_free(imgu, &css_pipe->sp_ddr_ptrs);
+}
+
+void ipu3_css_cleanup(struct ipu3_css *css)
+{
+	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+	unsigned int pipe;
 
+	ipu3_css_stop_streaming(css);
+	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++)
+		ipu3_css_pipe_cleanup(css, pipe);
+	ipu3_dmamap_free(imgu, &css->xmem_sp_group_ptrs);
 	ipu3_css_fw_cleanup(css);
 }
 
@@ -1447,67 +1549,40 @@ int ipu3_css_init(struct device *dev, struct ipu3_css *css,
 		  void __iomem *base, int length)
 {
 	struct imgu_device *imgu = dev_get_drvdata(dev);
-	int r, p, q, i;
+	int r, q, pipe;
 
 	/* Initialize main data structure */
 	css->dev = dev;
 	css->base = base;
 	css->iomem_length = length;
-	css->current_binary = IPU3_CSS_DEFAULT_BINARY;
-	css->pipe_id = IPU3_CSS_PIPE_ID_NUM;
-	css->vf_output_en = IPU3_NODE_VF_DISABLED;
-	spin_lock_init(&css->qlock);
 
-	for (q = 0; q < IPU3_CSS_QUEUES; q++) {
-		r = ipu3_css_queue_init(&css->queue[q], NULL, 0);
-		if (r)
+	for (pipe = 0; pipe < IMGU_MAX_PIPE_NUM; pipe++) {
+		struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+
+		css_pipe->vf_output_en = false;
+		spin_lock_init(&css_pipe->qlock);
+		css_pipe->bindex = IPU3_CSS_DEFAULT_BINARY;
+		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_VIDEO;
+		for (q = 0; q < IPU3_CSS_QUEUES; q++) {
+			r = ipu3_css_queue_init(&css_pipe->queue[q], NULL, 0);
+			if (r)
+				return r;
+		}
+		r = ipu3_css_map_init(css, pipe);
+		if (r) {
+			ipu3_css_cleanup(css);
 			return r;
+		}
 	}
+	if (!ipu3_dmamap_alloc(imgu, &css->xmem_sp_group_ptrs,
+			       sizeof(struct imgu_abi_sp_group)))
+		return -ENOMEM;
 
 	r = ipu3_css_fw_init(css);
 	if (r)
 		return r;
 
-	/* Allocate and map common structures with imgu hardware */
-
-	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
-		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
-			if (!ipu3_dmamap_alloc(imgu,
-					&css->xmem_sp_stage_ptrs[p][i],
-					sizeof(struct imgu_abi_sp_stage)))
-				goto error_no_memory;
-			if (!ipu3_dmamap_alloc(imgu,
-					&css->xmem_isp_stage_ptrs[p][i],
-					sizeof(struct imgu_abi_isp_stage)))
-				goto error_no_memory;
-		}
-
-	if (!ipu3_dmamap_alloc(imgu, &css->sp_ddr_ptrs,
-			       ALIGN(sizeof(struct imgu_abi_ddr_address_map),
-				     IMGU_ABI_ISP_DDR_WORD_BYTES)))
-		goto error_no_memory;
-
-	if (!ipu3_dmamap_alloc(imgu, &css->xmem_sp_group_ptrs,
-			       sizeof(struct imgu_abi_sp_group)))
-		goto error_no_memory;
-
-	for (q = 0; q < IPU3_CSS_QUEUES; q++)
-		for (i = 0; i < ARRAY_SIZE(css->abi_buffers[q]); i++)
-			if (!ipu3_dmamap_alloc(imgu, &css->abi_buffers[q][i],
-					       sizeof(struct imgu_abi_buffer)))
-				goto error_no_memory;
-
-	if (ipu3_css_binary_preallocate(css))
-		goto error_binary_setup;
-
 	return 0;
-
-error_binary_setup:
-	ipu3_css_binary_cleanup(css);
-error_no_memory:
-	ipu3_css_cleanup(css);
-
-	return -ENOMEM;
 }
 
 static u32 ipu3_css_adjust(u32 res, u32 align)
@@ -1519,11 +1594,13 @@ static u32 ipu3_css_adjust(u32 res, u32 align)
 
 /* Select a binary matching the required resolutions and formats */
 static int ipu3_css_find_binary(struct ipu3_css *css,
+				unsigned int pipe,
 				struct ipu3_css_queue queue[IPU3_CSS_QUEUES],
 				struct v4l2_rect rects[IPU3_CSS_RECTS])
 {
 	const int binary_nr = css->fwp->file_header.binary_nr;
-	unsigned int binary_mode = (css->pipe_id == IPU3_CSS_PIPE_ID_CAPTURE) ?
+	unsigned int binary_mode =
+		(css->pipes[pipe].pipe_id == IPU3_CSS_PIPE_ID_CAPTURE) ?
 		IA_CSS_BINARY_MODE_PRIMARY : IA_CSS_BINARY_MODE_VIDEO;
 	const struct v4l2_pix_format_mplane *in =
 					&queue[IPU3_CSS_QUEUE_IN].fmt.mpix;
@@ -1624,7 +1701,8 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
 		}
 
 		/* All checks passed, select the binary */
-		dev_dbg(css->dev, "using binary %s\n", name);
+		dev_dbg(css->dev, "using binary %s id = %u\n", name,
+			bi->info.isp.sp.id);
 		return i;
 	}
 
@@ -1641,7 +1719,8 @@ static int ipu3_css_find_binary(struct ipu3_css *css,
  */
 int ipu3_css_fmt_try(struct ipu3_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
-		     struct v4l2_rect *rects[IPU3_CSS_RECTS])
+		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
+		     unsigned int pipe)
 {
 	static const u32 EFF_ALIGN_W = 2;
 	static const u32 BDS_ALIGN_W = 4;
@@ -1673,13 +1752,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 					&q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
 	struct v4l2_pix_format_mplane *const vf =
 					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
-	int binary, i, s;
-
-	/* Decide which pipe to use */
-	if (css->vf_output_en == IPU3_NODE_PV_ENABLED)
-		css->pipe_id = IPU3_CSS_PIPE_ID_CAPTURE;
-	else if (css->vf_output_en == IPU3_NODE_VF_ENABLED)
-		css->pipe_id = IPU3_CSS_PIPE_ID_VIDEO;
+	int i, s;
 
 	/* Adjust all formats, get statistics buffer sizes and formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
@@ -1714,9 +1787,8 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 
 	/* Always require one input and vf only if out is also enabled */
 	if (!ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
-	    (ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_VF]) &&
-	    !ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT]))) {
-		dev_dbg(css->dev, "required queues are disabled\n");
+	    !ipu3_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
+		dev_warn(css->dev, "required queues are disabled\n");
 		return -EINVAL;
 	}
 
@@ -1755,12 +1827,16 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
 	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
 
-	binary = ipu3_css_find_binary(css, q, r);
-	if (binary < 0) {
+	css->pipes[pipe].bindex =
+		ipu3_css_find_binary(css, pipe, q, r);
+	if (css->pipes[pipe].bindex < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
 		return -EINVAL;
 	}
 
+	dev_dbg(css->dev, "Binary index %d for pipe %d found.",
+		css->pipes[pipe].bindex, pipe);
+
 	/* Final adjustment and set back the queried formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		if (fmts[i]) {
@@ -1784,16 +1860,18 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 		 bds->width, bds->height, gdc->width, gdc->height,
 		 out->width, out->height, vf->width, vf->height);
 
-	return binary;
+	return 0;
 }
 
 int ipu3_css_fmt_set(struct ipu3_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
-		     struct v4l2_rect *rects[IPU3_CSS_RECTS])
+		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
+		     unsigned int pipe)
 {
 	struct v4l2_rect rect_data[IPU3_CSS_RECTS];
 	struct v4l2_rect *all_rects[IPU3_CSS_RECTS];
 	int i, r;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
 		if (rects[i])
@@ -1802,17 +1880,16 @@ int ipu3_css_fmt_set(struct ipu3_css *css,
 			memset(&rect_data[i], 0, sizeof(rect_data[i]));
 		all_rects[i] = &rect_data[i];
 	}
-	r = ipu3_css_fmt_try(css, fmts, all_rects);
+	r = ipu3_css_fmt_try(css, fmts, all_rects, pipe);
 	if (r < 0)
 		return r;
-	css->current_binary = (unsigned int)r;
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++)
-		if (ipu3_css_queue_init(&css->queue[i], fmts[i],
+		if (ipu3_css_queue_init(&css_pipe->queue[i], fmts[i],
 					IPU3_CSS_QUEUE_TO_FLAGS(i)))
 			return -EINVAL;
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
-		css->rect[i] = rect_data[i];
+		css_pipe->rect[i] = rect_data[i];
 		if (rects[i])
 			*rects[i] = rect_data[i];
 	}
@@ -1842,13 +1919,14 @@ int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt)
  * Returns 0 on success, -EBUSY if the buffer queue is full, or some other
  * code on error conditions.
  */
-int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b)
+int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_css_buffer *b)
 {
-	static const int thread;
 	struct imgu_abi_buffer *abi_buf;
 	struct imgu_addr_t *buf_addr;
 	u32 data;
 	int r;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
 
 	if (!css->streaming)
 		return -EPROTO;	/* CSS or buffer in wrong state */
@@ -1857,11 +1935,11 @@ int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b)
 		return -EINVAL;
 
 	b->queue_pos = ipu3_css_queue_pos(css, ipu3_css_queues[b->queue].qid,
-					  thread);
+					  pipe);
 
-	if (b->queue_pos >= ARRAY_SIZE(css->abi_buffers[b->queue]))
+	if (b->queue_pos >= ARRAY_SIZE(css->pipes[pipe].abi_buffers[b->queue]))
 		return -EIO;
-	abi_buf = css->abi_buffers[b->queue][b->queue_pos].vaddr;
+	abi_buf = css->pipes[pipe].abi_buffers[b->queue][b->queue_pos].vaddr;
 
 	/* Fill struct abi_buffer for firmware */
 	memset(abi_buf, 0, sizeof(*abi_buf));
@@ -1874,30 +1952,31 @@ int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b)
 
 	if (b->queue == IPU3_CSS_QUEUE_OUT)
 		abi_buf->payload.frame.padded_width =
-				css->queue[IPU3_CSS_QUEUE_OUT].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 
 	if (b->queue == IPU3_CSS_QUEUE_VF)
 		abi_buf->payload.frame.padded_width =
-					css->queue[IPU3_CSS_QUEUE_VF].width_pad;
+					css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 
-	spin_lock(&css->qlock);
-	list_add_tail(&b->list, &css->queue[b->queue].bufs);
-	spin_unlock(&css->qlock);
+	spin_lock(&css_pipe->qlock);
+	list_add_tail(&b->list, &css_pipe->queue[b->queue].bufs);
+	spin_unlock(&css_pipe->qlock);
 	b->state = IPU3_CSS_BUFFER_QUEUED;
 
-	data = css->abi_buffers[b->queue][b->queue_pos].daddr;
+	data = css->pipes[pipe].abi_buffers[b->queue][b->queue_pos].daddr;
 	r = ipu3_css_queue_data(css, ipu3_css_queues[b->queue].qid,
-				thread, data);
+				pipe, data);
 	if (r < 0)
 		goto queueing_failed;
 
-	data = IMGU_ABI_EVENT_BUFFER_ENQUEUED(thread,
+	data = IMGU_ABI_EVENT_BUFFER_ENQUEUED(pipe,
 					      ipu3_css_queues[b->queue].qid);
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, 0, data);
+	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe, data);
 	if (r < 0)
 		goto queueing_failed;
 
-	dev_dbg(css->dev, "queued buffer %p to css queue %i\n", b, b->queue);
+	dev_dbg(css->dev, "queued buffer %p to css queue %i in pipe %d\n",
+		b, b->queue, pipe);
 
 	return 0;
 
@@ -1916,7 +1995,6 @@ int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b)
  */
 struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 {
-	static const int thread;
 	static const unsigned char evtype_to_queue[] = {
 		[IMGU_ABI_EVTTYPE_INPUT_FRAME_DONE] = IPU3_CSS_QUEUE_IN,
 		[IMGU_ABI_EVTTYPE_OUT_FRAME_DONE] = IPU3_CSS_QUEUE_OUT,
@@ -1926,6 +2004,7 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 	struct ipu3_css_buffer *b = ERR_PTR(-EAGAIN);
 	u32 event, daddr;
 	int evtype, pipe, pipeid, queue, qid, r;
+	struct ipu3_css_pipe *css_pipe;
 
 	if (!css->streaming)
 		return ERR_PTR(-EPROTO);
@@ -1949,11 +2028,16 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 		queue = evtype_to_queue[evtype];
 		qid = ipu3_css_queues[queue].qid;
 
+		if (pipe >= IMGU_MAX_PIPE_NUM) {
+			dev_err(css->dev, "Invalid pipe: %i\n", pipe);
+			return ERR_PTR(-EIO);
+		}
+
 		if (qid >= IMGU_ABI_QUEUE_NUM) {
 			dev_err(css->dev, "Invalid qid: %i\n", qid);
 			return ERR_PTR(-EIO);
 		}
-
+		css_pipe = &css->pipes[pipe];
 		dev_dbg(css->dev,
 			"event: buffer done 0x%x queue %i pipe %i pipeid %i\n",
 			event, queue, pipe, pipeid);
@@ -1965,39 +2049,52 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 			return ERR_PTR(-EIO);
 		}
 
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, thread,
+		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_BUFFER_DEQUEUED(qid));
 		if (r < 0) {
 			dev_err(css->dev, "failed to queue event\n");
 			return ERR_PTR(-EIO);
 		}
 
-		spin_lock(&css->qlock);
-		if (list_empty(&css->queue[queue].bufs)) {
-			spin_unlock(&css->qlock);
+		spin_lock(&css_pipe->qlock);
+		if (list_empty(&css_pipe->queue[queue].bufs)) {
+			spin_unlock(&css_pipe->qlock);
 			dev_err(css->dev, "event on empty queue\n");
 			return ERR_PTR(-EIO);
 		}
-		b = list_first_entry(&css->queue[queue].bufs,
+		b = list_first_entry(&css_pipe->queue[queue].bufs,
 				     struct ipu3_css_buffer, list);
 		if (queue != b->queue ||
-		    daddr != css->abi_buffers[b->queue][b->queue_pos].daddr) {
-			spin_unlock(&css->qlock);
+		    daddr != css_pipe->abi_buffers
+			[b->queue][b->queue_pos].daddr) {
+			spin_unlock(&css_pipe->qlock);
 			dev_err(css->dev, "dequeued bad buffer 0x%x\n", daddr);
 			return ERR_PTR(-EIO);
 		}
+
+		dev_dbg(css->dev, "buffer 0x%8x done from pipe %d\n", daddr, pipe);
+		b->pipe = pipe;
 		b->state = IPU3_CSS_BUFFER_DONE;
 		list_del(&b->list);
-		spin_unlock(&css->qlock);
+		spin_unlock(&css_pipe->qlock);
 		break;
 	case IMGU_ABI_EVTTYPE_PIPELINE_DONE:
-		dev_dbg(css->dev, "event: pipeline done 0x%x for frame %ld\n",
-			event, css->frame);
+		pipe = (event & IMGU_ABI_EVTTYPE_PIPE_MASK) >>
+			IMGU_ABI_EVTTYPE_PIPE_SHIFT;
+		if (pipe >= IMGU_MAX_PIPE_NUM) {
+			dev_err(css->dev, "Invalid pipe: %i\n", pipe);
+			return ERR_PTR(-EIO);
+		}
+
+		css_pipe = &css->pipes[pipe];
+		dev_dbg(css->dev,
+			"event: pipeline done 0x%8x for frame %ld pipe %d\n",
+			event, css_pipe->frame, pipe);
 
-		if (css->frame == LONG_MAX)
-			css->frame = 0;
+		if (css_pipe->frame == LONG_MAX)
+			css_pipe->frame = 0;
 		else
-			css->frame++;
+			css_pipe->frame++;
 		break;
 	case IMGU_ABI_EVTTYPE_TIMER:
 		r = ipu3_css_dequeue_data(css, IMGU_ABI_QUEUE_EVENT_ID, &event);
@@ -2038,15 +2135,16 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
  * Return index to css->parameter_set_info which has the newly created
  * parameters or negative value on error.
  */
-int ipu3_css_set_parameters(struct ipu3_css *css,
+int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 			    struct ipu3_uapi_params *set_params)
 {
-	struct ipu3_uapi_flags *use = set_params ? &set_params->use : NULL;
 	static const unsigned int queue_id = IMGU_ABI_QUEUE_A_ID;
-	const int stage = 0, thread = 0;
+	struct ipu3_css_pipe *css_pipe = &css->pipes[pipe];
+	const int stage = 0;
 	const struct imgu_fw_info *bi;
-	unsigned int stripes, i;
 	int obgrid_size;
+	unsigned int stripes, i;
+	struct ipu3_uapi_flags *use = set_params ? &set_params->use : NULL;
 
 	/* Destination buffers which are filled here */
 	struct imgu_abi_parameter_set_info *param_set;
@@ -2063,7 +2161,9 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 	if (!css->streaming)
 		return -EPROTO;
 
-	bi = &css->fwp->binary_header[css->current_binary];
+	dev_dbg(css->dev, "%s for pipe %d", __func__, pipe);
+
+	bi = &css->fwp->binary_header[css_pipe->bindex];
 	obgrid_size = ipu3_css_fw_obgrid_size(bi);
 	stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
 
@@ -2072,49 +2172,53 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 	 * If this succeeds, then all of the other pool_get() calls below
 	 * should also succeed.
 	 */
-	if (ipu3_css_pool_get(&css->pool.parameter_set_info, css->frame) < 0)
+	if (ipu3_css_pool_get(&css_pipe->pool.parameter_set_info,
+			      css_pipe->frame) < 0)
 		goto fail_no_put;
-	param_set = ipu3_css_pool_last(&css->pool.parameter_set_info, 0)->vaddr;
+	param_set = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info,
+				       0)->vaddr;
 
-	map = ipu3_css_pool_last(&css->pool.acc, 0);
 	/* Get a new acc only if new parameters given, or none yet */
+	map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
 	if (set_params || !map->vaddr) {
-		if (ipu3_css_pool_get(&css->pool.acc, css->frame) < 0)
+		if (ipu3_css_pool_get(&css_pipe->pool.acc, css_pipe->frame) < 0)
 			goto fail;
-		map = ipu3_css_pool_last(&css->pool.acc, 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
 		acc = map->vaddr;
 	}
 
 	/* Get new VMEM0 only if needed, or none yet */
 	m = IMGU_ABI_MEM_ISP_VMEM0;
-	map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 0);
+	map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 	if (!map->vaddr || (set_params && (set_params->use.lin_vmem_params ||
 					   set_params->use.tnr3_vmem_params ||
 					   set_params->use.xnr3_vmem_params))) {
-		if (ipu3_css_pool_get(&css->pool.binary_params_p[m],
-				      css->frame) < 0)
+		if (ipu3_css_pool_get(&css_pipe->pool.binary_params_p[m],
+				      css_pipe->frame) < 0)
 			goto fail;
-		map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		vmem0 = map->vaddr;
 	}
 
 	/* Get new DMEM0 only if needed, or none yet */
 	m = IMGU_ABI_MEM_ISP_DMEM0;
-	map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 0);
+	map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 	if (!map->vaddr || (set_params && (set_params->use.tnr3_dmem_params ||
 					   set_params->use.xnr3_dmem_params))) {
-		if (ipu3_css_pool_get(&css->pool.binary_params_p[m],
-				      css->frame) < 0)
+		if (ipu3_css_pool_get(&css_pipe->pool.binary_params_p[m],
+				      css_pipe->frame) < 0)
 			goto fail;
-		map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		dmem0 = map->vaddr;
 	}
 
 	/* Configure acc parameter cluster */
 	if (acc) {
-		map = ipu3_css_pool_last(&css->pool.acc, 1);
-		r = ipu3_css_cfg_acc(css, use, acc, map->vaddr, set_params ?
-				     &set_params->acc_param : NULL);
+		/* get acc_old */
+		map = ipu3_css_pool_last(&css_pipe->pool.acc, 1);
+		/* user acc */
+		r = ipu3_css_cfg_acc(css, pipe, use, acc, map->vaddr,
+			set_params ? &set_params->acc_param : NULL);
 		if (r < 0)
 			goto fail;
 	}
@@ -2122,16 +2226,18 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 	/* Configure late binding parameters */
 	if (vmem0) {
 		m = IMGU_ABI_MEM_ISP_VMEM0;
-		map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 1);
-		r = ipu3_css_cfg_vmem0(css, use, vmem0, map->vaddr, set_params);
+		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
+		r = ipu3_css_cfg_vmem0(css, pipe, use, vmem0,
+				       map->vaddr, set_params);
 		if (r < 0)
 			goto fail;
 	}
 
 	if (dmem0) {
 		m = IMGU_ABI_MEM_ISP_DMEM0;
-		map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 1);
-		r = ipu3_css_cfg_dmem0(css, use, dmem0, map->vaddr, set_params);
+		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 1);
+		r = ipu3_css_cfg_dmem0(css, pipe, use, dmem0,
+				       map->vaddr, set_params);
 		if (r < 0)
 			goto fail;
 	}
@@ -2142,30 +2248,30 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 		unsigned int g = IPU3_CSS_RECT_GDC;
 		unsigned int e = IPU3_CSS_RECT_ENVELOPE;
 
-		map = ipu3_css_pool_last(&css->pool.gdc, 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
 		if (!map->vaddr) {
-			if (ipu3_css_pool_get(&css->pool.gdc, css->frame) < 0)
+			if (ipu3_css_pool_get(&css_pipe->pool.gdc, css_pipe->frame) < 0)
 				goto fail;
-			map = ipu3_css_pool_last(&css->pool.gdc, 0);
+			map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
 			gdc = map->vaddr;
-			ipu3_css_cfg_gdc_table(gdc,
-					       css->aux_frames[a].bytesperline /
-					       css->aux_frames[a].bytesperpixel,
-					       css->aux_frames[a].height,
-					       css->rect[g].width,
-					       css->rect[g].height,
-					       css->rect[e].width + FILTER_SIZE,
-					       css->rect[e].height +
-					       FILTER_SIZE);
+			ipu3_css_cfg_gdc_table(map->vaddr,
+				css_pipe->aux_frames[a].bytesperline /
+				css_pipe->aux_frames[a].bytesperpixel,
+				css_pipe->aux_frames[a].height,
+				css_pipe->rect[g].width,
+				css_pipe->rect[g].height,
+				css_pipe->rect[e].width + FILTER_SIZE,
+				css_pipe->rect[e].height +
+				FILTER_SIZE);
 		}
 	}
 
 	/* Get a new obgrid only if a new obgrid is given, or none yet */
-	map = ipu3_css_pool_last(&css->pool.obgrid, 0);
+	map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
 	if (!map->vaddr || (set_params && set_params->use.obgrid_param)) {
-		if (ipu3_css_pool_get(&css->pool.obgrid, css->frame) < 0)
+		if (ipu3_css_pool_get(&css_pipe->pool.obgrid, css_pipe->frame) < 0)
 			goto fail;
-		map = ipu3_css_pool_last(&css->pool.obgrid, 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
 		obgrid = map->vaddr;
 
 		/* Configure optical black level grid (obgrid) */
@@ -2179,29 +2285,31 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 	/* Configure parameter set info, queued to `queue_id' */
 
 	memset(param_set, 0, sizeof(*param_set));
-	map = ipu3_css_pool_last(&css->pool.acc, 0);
+	map = ipu3_css_pool_last(&css_pipe->pool.acc, 0);
 	param_set->mem_map.acc_cluster_params_for_sp = map->daddr;
 
-	map = ipu3_css_pool_last(&css->pool.gdc, 0);
+	map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
 	param_set->mem_map.dvs_6axis_params_y = map->daddr;
 
-	map = ipu3_css_pool_last(&css->pool.obgrid, 0);
-	for (i = 0; i < stripes; i++)
+	for (i = 0; i < stripes; i++) {
+		map = ipu3_css_pool_last(&css_pipe->pool.obgrid, 0);
 		param_set->mem_map.obgrid_tbl[i] =
-				map->daddr + (obgrid_size / stripes) * i;
+			map->daddr + (obgrid_size / stripes) * i;
+	}
 
 	for (m = 0; m < IMGU_ABI_NUM_MEMORIES; m++) {
-		map = ipu3_css_pool_last(&css->pool.binary_params_p[m], 0);
+		map = ipu3_css_pool_last(&css_pipe->pool.binary_params_p[m], 0);
 		param_set->mem_map.isp_mem_param[stage][m] = map->daddr;
 	}
+
 	/* Then queue the new parameter buffer */
-	map = ipu3_css_pool_last(&css->pool.parameter_set_info, 0);
-	r = ipu3_css_queue_data(css, queue_id, thread, map->daddr);
+	map = ipu3_css_pool_last(&css_pipe->pool.parameter_set_info, 0);
+	r = ipu3_css_queue_data(css, queue_id, pipe, map->daddr);
 	if (r < 0)
 		goto fail;
 
-	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, 0,
-				IMGU_ABI_EVENT_BUFFER_ENQUEUED(thread,
+	r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
+				IMGU_ABI_EVENT_BUFFER_ENQUEUED(pipe,
 							       queue_id));
 	if (r < 0)
 		goto fail_no_put;
@@ -2216,7 +2324,7 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 			break;
 		if (r)
 			goto fail_no_put;
-		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, thread,
+		r = ipu3_css_queue_data(css, IMGU_ABI_QUEUE_EVENT_ID, pipe,
 					IMGU_ABI_EVENT_BUFFER_DEQUEUED
 					(queue_id));
 		if (r < 0) {
@@ -2234,19 +2342,21 @@ int ipu3_css_set_parameters(struct ipu3_css *css,
 	 * parameters again later.
 	 */
 
-	ipu3_css_pool_put(&css->pool.parameter_set_info);
+	ipu3_css_pool_put(&css_pipe->pool.parameter_set_info);
 	if (acc)
-		ipu3_css_pool_put(&css->pool.acc);
+		ipu3_css_pool_put(&css_pipe->pool.acc);
 	if (gdc)
-		ipu3_css_pool_put(&css->pool.gdc);
+		ipu3_css_pool_put(&css_pipe->pool.gdc);
 	if (obgrid)
-		ipu3_css_pool_put(&css->pool.obgrid);
+		ipu3_css_pool_put(&css_pipe->pool.obgrid);
 	if (vmem0)
 		ipu3_css_pool_put(
-			&css->pool.binary_params_p[IMGU_ABI_MEM_ISP_VMEM0]);
+			&css_pipe->pool.binary_params_p
+			[IMGU_ABI_MEM_ISP_VMEM0]);
 	if (dmem0)
 		ipu3_css_pool_put(
-			&css->pool.binary_params_p[IMGU_ABI_MEM_ISP_DMEM0]);
+			&css_pipe->pool.binary_params_p
+			[IMGU_ABI_MEM_ISP_DMEM0]);
 
 fail_no_put:
 	return r;
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.h b/drivers/media/pci/intel/ipu3/ipu3-css.h
index d16d0c4..11b1437 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-css.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-css.h
@@ -13,6 +13,7 @@
 /* 2 stages for split isp pipeline, 1 for scaling */
 #define IMGU_NUM_SP			2
 #define IMGU_MAX_PIPELINE_NUM		20
+#define IMGU_MAX_PIPE_NUM		2
 
 /* For DVS etc., format FRAME_FMT_YUV420_16 */
 #define IPU3_CSS_AUX_FRAME_REF		0
@@ -57,12 +58,6 @@ struct ipu3_css_resolution {
 	u32 h;
 };
 
-enum ipu3_css_vf_status {
-	IPU3_NODE_VF_ENABLED,
-	IPU3_NODE_PV_ENABLED,
-	IPU3_NODE_VF_DISABLED
-};
-
 enum ipu3_css_buffer_state {
 	IPU3_CSS_BUFFER_NEW,	/* Not yet queued */
 	IPU3_CSS_BUFFER_QUEUED,	/* Queued, waiting to be filled */
@@ -77,6 +72,7 @@ struct ipu3_css_buffer {
 	enum ipu3_css_buffer_state state;
 	struct list_head list;
 	u8 queue_pos;
+	unsigned int pipe;
 };
 
 struct ipu3_css_format {
@@ -100,34 +96,32 @@ struct ipu3_css_queue {
 
 	} fmt;
 	const struct ipu3_css_format *css_fmt;
-	unsigned int width_pad;	/* bytesperline / byp */
+	unsigned int width_pad;
 	struct list_head bufs;
 };
 
-/* IPU3 Camera Sub System structure */
-struct ipu3_css {
-	struct device *dev;
-	void __iomem *base;
-	const struct firmware *fw;
-	struct imgu_fw_header *fwp;
-	int iomem_length;
-	int fw_bl, fw_sp[IMGU_NUM_SP];	/* Indices of bl and SP binaries */
-	struct ipu3_css_map *binary;	/* fw binaries mapped to device */
-	unsigned int current_binary;	/* Currently selected binary */
-	bool streaming;		/* true when streaming is enabled */
-	long frame;	/* Latest frame not yet processed */
-	enum ipu3_css_pipe_id pipe_id;  /* CSS pipe ID. */
+struct ipu3_css_pipe {
+	enum ipu3_css_pipe_id pipe_id;
+	unsigned int bindex;
+
+	struct ipu3_css_queue queue[IPU3_CSS_QUEUES];
+	struct v4l2_rect rect[IPU3_CSS_RECTS];
+
+	bool vf_output_en;
+	/* Protect access to queue[IPU3_CSS_QUEUES] */
+	spinlock_t qlock;
 
 	/* Data structures shared with IMGU and driver, always allocated */
+	struct ipu3_css_map sp_ddr_ptrs;
 	struct ipu3_css_map xmem_sp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
 					    [IMGU_ABI_MAX_STAGES];
 	struct ipu3_css_map xmem_isp_stage_ptrs[IPU3_CSS_PIPE_ID_NUM]
 					    [IMGU_ABI_MAX_STAGES];
-	struct ipu3_css_map sp_ddr_ptrs;
-	struct ipu3_css_map xmem_sp_group_ptrs;
 
-	/* Data structures shared with IMGU and driver, binary specific */
-	/* PARAM_CLASS_CONFIG and PARAM_CLASS_STATE parameters */
+	/*
+	 * Data structures shared with IMGU and driver, binary specific.
+	 * PARAM_CLASS_CONFIG and PARAM_CLASS_STATE parameters.
+	 */
 	struct ipu3_css_map binary_params_cs[IMGU_ABI_PARAM_CLASS_NUM - 1]
 					    [IMGU_ABI_NUM_MEMORIES];
 
@@ -139,10 +133,6 @@ struct ipu3_css {
 		unsigned int bytesperpixel;
 	} aux_frames[IPU3_CSS_AUX_FRAME_TYPES];
 
-	struct ipu3_css_queue queue[IPU3_CSS_QUEUES];
-	struct v4l2_rect rect[IPU3_CSS_RECTS];
-	struct ipu3_css_map abi_buffers[IPU3_CSS_QUEUES]
-				    [IMGU_ABI_HOST2SP_BUFQ_SIZE];
 
 	struct {
 		struct ipu3_css_pool parameter_set_info;
@@ -153,9 +143,27 @@ struct ipu3_css {
 		struct ipu3_css_pool binary_params_p[IMGU_ABI_NUM_MEMORIES];
 	} pool;
 
-	enum ipu3_css_vf_status vf_output_en;
-	/* Protect access to css->queue[] */
-	spinlock_t qlock;
+	struct ipu3_css_map abi_buffers[IPU3_CSS_QUEUES]
+				    [IMGU_ABI_HOST2SP_BUFQ_SIZE];
+	long frame; /* Latest frame not yet processed */
+};
+
+/* IPU3 Camera Sub System structure */
+struct ipu3_css {
+	struct device *dev;
+	void __iomem *base;
+	const struct firmware *fw;
+	struct imgu_fw_header *fwp;
+	int iomem_length;
+	int fw_bl, fw_sp[IMGU_NUM_SP];	/* Indices of bl and SP binaries */
+	struct ipu3_css_map *binary;	/* fw binaries mapped to device */
+	bool streaming;		/* true when streaming is enabled */
+
+	struct ipu3_css_pipe pipes[IMGU_MAX_PIPE_NUM];
+	struct ipu3_css_map xmem_sp_group_ptrs;
+
+	/* enabled pipe(s) */
+	DECLARE_BITMAP(enabled_pipes, IMGU_MAX_PIPE_NUM);
 };
 
 /******************* css v4l *******************/
@@ -164,17 +172,21 @@ int ipu3_css_init(struct device *dev, struct ipu3_css *css,
 void ipu3_css_cleanup(struct ipu3_css *css);
 int ipu3_css_fmt_try(struct ipu3_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
-		     struct v4l2_rect *rects[IPU3_CSS_RECTS]);
+		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
+		     unsigned int pipe);
 int ipu3_css_fmt_set(struct ipu3_css *css,
 		     struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES],
-		     struct v4l2_rect *rects[IPU3_CSS_RECTS]);
+		     struct v4l2_rect *rects[IPU3_CSS_RECTS],
+		     unsigned int pipe);
 int ipu3_css_meta_fmt_set(struct v4l2_meta_format *fmt);
-int ipu3_css_buf_queue(struct ipu3_css *css, struct ipu3_css_buffer *b);
+int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
+		       struct ipu3_css_buffer *b);
 struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css);
 int ipu3_css_start_streaming(struct ipu3_css *css);
 void ipu3_css_stop_streaming(struct ipu3_css *css);
 bool ipu3_css_queue_empty(struct ipu3_css *css);
 bool ipu3_css_is_streaming(struct ipu3_css *css);
+bool ipu3_css_pipe_queue_empty(struct ipu3_css *css, unsigned int pipe);
 
 /******************* css hw *******************/
 int ipu3_css_set_powerup(struct device *dev, void __iomem *base);
@@ -182,10 +194,10 @@ void ipu3_css_set_powerdown(struct device *dev, void __iomem *base);
 int ipu3_css_irq_ack(struct ipu3_css *css);
 
 /******************* set parameters ************/
-int ipu3_css_set_parameters(struct ipu3_css *css,
+int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 			    struct ipu3_uapi_params *set_params);
 
-/******************* css misc *******************/
+/******************* auxiliary helpers *******************/
 static inline enum ipu3_css_buffer_state
 ipu3_css_buf_state(struct ipu3_css_buffer *b)
 {
diff --git a/drivers/media/pci/intel/ipu3/ipu3-v4l2.c b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
index 31a3514..4066383 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 
 #include "ipu3.h"
@@ -13,19 +14,28 @@
 
 static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
+	struct imgu_media_pipe *imgu_pipe;
 	struct v4l2_rect try_crop = {
 		.top = 0,
 		.left = 0,
-		.height = imgu->nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.height,
-		.width = imgu->nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.width,
 	};
 	unsigned int i;
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
+	unsigned int pipe = imgu_sd->pipe;
+
+	imgu_pipe = &imgu->imgu_pipe[pipe];
+	try_crop.width =
+		imgu_pipe->nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.width;
+	try_crop.height =
+		imgu_pipe->nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.height;
 
 	/* Initialize try_fmt */
 	for (i = 0; i < IMGU_NODE_NUM; i++)
 		*v4l2_subdev_get_try_format(sd, fh->pad, i) =
-			imgu->nodes[i].pad_fmt;
+			imgu_pipe->nodes[i].pad_fmt;
 
 	*v4l2_subdev_get_try_crop(sd, fh->pad, IMGU_NODE_IN) = try_crop;
 
@@ -34,26 +44,89 @@ static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 static int ipu3_subdev_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
+	int i;
+	unsigned int node;
 	int r = 0;
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
+	unsigned int pipe = imgu_sd->pipe;
+	struct device *dev = &imgu->pci_dev->dev;
+	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
+	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
+	struct ipu3_css_pipe *css_pipe = &imgu->css.pipes[pipe];
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
-	r = imgu_s_stream(imgu, enable);
-	if (!r)
-		imgu->streaming = enable;
+	dev_dbg(dev, "%s %d for pipe %d", __func__, enable, pipe);
+	/* grab ctrl after streamon and return after off */
+	v4l2_ctrl_grab(imgu_sd->ctrl, enable);
 
-	return r;
+	if (!enable) {
+		imgu_sd->active = false;
+		return 0;
+	}
+
+	for (i = 0; i < IMGU_NODE_NUM; i++)
+		imgu_pipe->queue_enabled[i] = imgu_pipe->nodes[i].enabled;
+
+	/* This is handled specially */
+	imgu_pipe->queue_enabled[IPU3_CSS_QUEUE_PARAMS] = false;
+
+	/* Initialize CSS formats */
+	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
+		node = imgu_map_node(imgu, i);
+		/* No need to reconfig meta nodes */
+		if (node == IMGU_NODE_STAT_3A || node == IMGU_NODE_PARAMS)
+			continue;
+		fmts[i] = imgu_pipe->queue_enabled[node] ?
+			&imgu_pipe->nodes[node].vdev_fmt.fmt.pix_mp : NULL;
+	}
+
+	/* Enable VF output only when VF queue requested by user */
+	css_pipe->vf_output_en = false;
+	if (imgu_pipe->nodes[IMGU_NODE_VF].enabled)
+		css_pipe->vf_output_en = true;
+
+	if (atomic_read(&imgu_sd->running_mode) == IPU3_RUNNING_MODE_VIDEO)
+		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_VIDEO;
+	else
+		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_CAPTURE;
+
+	dev_dbg(dev, "IPU3 pipe %d pipe_id %d", pipe, css_pipe->pipe_id);
+
+	rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu_sd->rect.eff;
+	rects[IPU3_CSS_RECT_BDS] = &imgu_sd->rect.bds;
+	rects[IPU3_CSS_RECT_GDC] = &imgu_sd->rect.gdc;
+
+	r = ipu3_css_fmt_set(&imgu->css, fmts, rects, pipe);
+	if (r) {
+		dev_err(dev, "failed to set initial formats pipe %d with (%d)",
+			pipe, r);
+		return r;
+	}
+
+	imgu_sd->active = true;
+
+	return 0;
 }
 
 static int ipu3_subdev_get_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf;
+	struct imgu_media_pipe *imgu_pipe;
 	u32 pad = fmt->pad;
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
+	unsigned int pipe = imgu_sd->pipe;
 
+	imgu_pipe = &imgu->imgu_pipe[pipe];
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		fmt->format = imgu->nodes[pad].pad_fmt;
+		fmt->format = imgu_pipe->nodes[pad].pad_fmt;
 	} else {
 		mf = v4l2_subdev_get_try_format(sd, cfg, pad);
 		fmt->format = *mf;
@@ -66,18 +139,28 @@ static int ipu3_subdev_set_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
+	struct imgu_media_pipe *imgu_pipe;
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
+
 	struct v4l2_mbus_framefmt *mf;
 	u32 pad = fmt->pad;
+	unsigned int pipe = imgu_sd->pipe;
+
+	dev_dbg(&imgu->pci_dev->dev, "set subdev %d pad %d fmt to [%dx%d]",
+		pipe, pad, fmt->format.width, fmt->format.height);
 
+	imgu_pipe = &imgu->imgu_pipe[pipe];
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		mf = v4l2_subdev_get_try_format(sd, cfg, pad);
 	else
-		mf = &imgu->nodes[pad].pad_fmt;
+		mf = &imgu_pipe->nodes[pad].pad_fmt;
 
 	fmt->format.code = mf->code;
 	/* Clamp the w and h based on the hardware capabilities */
-	if (imgu->subdev_pads[pad].flags & MEDIA_PAD_FL_SOURCE) {
+	if (imgu_sd->subdev_pads[pad].flags & MEDIA_PAD_FL_SOURCE) {
 		fmt->format.width = clamp(fmt->format.width,
 					  IPU3_OUTPUT_MIN_WIDTH,
 					  IPU3_OUTPUT_MAX_WIDTH);
@@ -102,8 +185,10 @@ static int ipu3_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
 	struct v4l2_rect *try_sel, *r;
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
 
 	if (sel->pad != IMGU_NODE_IN)
 		return -EINVAL;
@@ -111,11 +196,11 @@ static int ipu3_subdev_get_selection(struct v4l2_subdev *sd,
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
-		r = &imgu->rect.eff;
+		r = &imgu_sd->rect.eff;
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(sd, cfg, sel->pad);
-		r = &imgu->rect.bds;
+		r = &imgu_sd->rect.bds;
 		break;
 	default:
 		return -EINVAL;
@@ -133,20 +218,28 @@ static int ipu3_subdev_set_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
-	struct imgu_device *imgu = container_of(sd, struct imgu_device, subdev);
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
 	struct v4l2_rect *rect, *try_sel;
 
+	dev_dbg(&imgu->pci_dev->dev,
+		 "set subdev %d sel which %d target 0x%4x rect [%dx%d]",
+		 imgu_sd->pipe, sel->which, sel->target,
+		 sel->r.width, sel->r.height);
+
 	if (sel->pad != IMGU_NODE_IN)
 		return -EINVAL;
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
-		rect = &imgu->rect.eff;
+		rect = &imgu_sd->rect.eff;
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(sd, cfg, sel->pad);
-		rect = &imgu->rect.bds;
+		rect = &imgu_sd->rect.bds;
 		break;
 	default:
 		return -EINVAL;
@@ -166,13 +259,35 @@ static int ipu3_link_setup(struct media_entity *entity,
 			   const struct media_pad *local,
 			   const struct media_pad *remote, u32 flags)
 {
-	struct imgu_device *imgu = container_of(entity, struct imgu_device,
-						subdev.entity);
+	struct imgu_media_pipe *imgu_pipe;
+	struct v4l2_subdev *sd = container_of(entity, struct v4l2_subdev,
+					      entity);
+	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
+	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
+							struct imgu_v4l2_subdev,
+							subdev);
+	unsigned int pipe = imgu_sd->pipe;
 	u32 pad = local->index;
 
 	WARN_ON(pad >= IMGU_NODE_NUM);
 
-	imgu->nodes[pad].enabled = flags & MEDIA_LNK_FL_ENABLED;
+	dev_dbg(&imgu->pci_dev->dev, "pipe %d pad %d is %s", pipe, pad,
+		 flags & MEDIA_LNK_FL_ENABLED ? "enabled" : "disabled");
+
+	imgu_pipe = &imgu->imgu_pipe[pipe];
+	imgu_pipe->nodes[pad].enabled = flags & MEDIA_LNK_FL_ENABLED;
+
+	/* enable input node to enable the pipe */
+	if (pad != IMGU_NODE_IN)
+		return 0;
+
+	if (flags & MEDIA_LNK_FL_ENABLED)
+		__set_bit(pipe, imgu->css.enabled_pipes);
+	else
+		__clear_bit(pipe, imgu->css.enabled_pipes);
+
+	dev_dbg(&imgu->pci_dev->dev, "pipe %d is %s", pipe,
+		 flags & MEDIA_LNK_FL_ENABLED ? "enabled" : "disabled");
 
 	return 0;
 }
@@ -187,7 +302,7 @@ static int ipu3_vb2_buf_init(struct vb2_buffer *vb)
 		struct imgu_buffer, vid_buf.vbb.vb2_buf);
 	struct imgu_video_device *node =
 		container_of(vb->vb2_queue, struct imgu_video_device, vbq);
-	unsigned int queue = imgu_node_to_queue(node - imgu->nodes);
+	unsigned int queue = imgu_node_to_queue(node->id);
 
 	if (queue == IPU3_CSS_QUEUE_PARAMS)
 		return 0;
@@ -203,7 +318,7 @@ static void ipu3_vb2_buf_cleanup(struct vb2_buffer *vb)
 		struct imgu_buffer, vid_buf.vbb.vb2_buf);
 	struct imgu_video_device *node =
 		container_of(vb->vb2_queue, struct imgu_video_device, vbq);
-	unsigned int queue = imgu_node_to_queue(node - imgu->nodes);
+	unsigned int queue = imgu_node_to_queue(node->id);
 
 	if (queue == IPU3_CSS_QUEUE_PARAMS)
 		return;
@@ -217,8 +332,9 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 	struct imgu_device *imgu = vb2_get_drv_priv(vb->vb2_queue);
 	struct imgu_video_device *node =
 		container_of(vb->vb2_queue, struct imgu_video_device, vbq);
-	unsigned int queue = imgu_node_to_queue(node - imgu->nodes);
+	unsigned int queue = imgu_node_to_queue(node->id);
 	unsigned long need_bytes;
+	unsigned int pipe = node->pipe;
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_META_CAPTURE ||
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_META_OUTPUT)
@@ -237,7 +353,7 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 			vb2_set_plane_payload(vb, 0, payload);
 		}
 		if (payload >= need_bytes)
-			r = ipu3_css_set_parameters(&imgu->css,
+			r = ipu3_css_set_parameters(&imgu->css, pipe,
 						    vb2_plane_vaddr(vb, 0));
 		buf->flags = V4L2_BUF_FLAG_DONE;
 		vb2_buffer_done(vb, r == 0 ? VB2_BUF_STATE_DONE
@@ -250,14 +366,18 @@ static void ipu3_vb2_buf_queue(struct vb2_buffer *vb)
 		mutex_lock(&imgu->lock);
 		ipu3_css_buf_init(&buf->css_buf, queue, buf->map.daddr);
 		list_add_tail(&buf->vid_buf.list,
-			      &imgu->nodes[node - imgu->nodes].buffers);
+			      &node->buffers);
 		mutex_unlock(&imgu->lock);
 
 		vb2_set_plane_payload(&buf->vid_buf.vbb.vb2_buf, 0, need_bytes);
 
 		if (imgu->streaming)
-			imgu_queue_buffers(imgu, false);
+			imgu_queue_buffers(imgu, false, pipe);
 	}
+
+	dev_dbg(&imgu->pci_dev->dev, "%s for pipe %d node %d", __func__,
+		node->pipe, node->id);
+
 }
 
 static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
@@ -289,6 +409,7 @@ static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
 
 	*num_planes = 1;
 	sizes[0] = size;
+
 	/* Initialize buffer queue */
 	INIT_LIST_HEAD(&node->buffers);
 
@@ -299,15 +420,27 @@ static int ipu3_vb2_queue_setup(struct vb2_queue *vq,
 static bool ipu3_all_nodes_streaming(struct imgu_device *imgu,
 				     struct imgu_video_device *except)
 {
-	unsigned int i;
-
-	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		struct imgu_video_device *node = &imgu->nodes[i];
+	unsigned int i, pipe, p;
+	struct imgu_video_device *node;
+	struct device *dev = &imgu->pci_dev->dev;
+
+	pipe = except->pipe;
+	if (!test_bit(pipe, imgu->css.enabled_pipes)) {
+		dev_warn(&imgu->pci_dev->dev,
+			 "pipe %d link is not ready yet", pipe);
+		return false;
+	}
 
-		if (node == except)
-			continue;
-		if (node->enabled && !vb2_start_streaming_called(&node->vbq))
-			return false;
+	for_each_set_bit(p, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		for (i = 0; i < IMGU_NODE_NUM; i++) {
+			node = &imgu->imgu_pipe[p].nodes[i];
+			dev_dbg(dev, "%s pipe %u queue %u name %s enabled = %u",
+				__func__, p, i, node->name, node->enabled);
+			if (node == except)
+				continue;
+			if (node->enabled && !vb2_start_streaming_called(&node->vbq))
+				return false;
+		}
 	}
 
 	return true;
@@ -330,10 +463,16 @@ static void ipu3_return_all_buffers(struct imgu_device *imgu,
 
 static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
+	struct imgu_media_pipe *imgu_pipe;
 	struct imgu_device *imgu = vb2_get_drv_priv(vq);
+	struct device *dev = &imgu->pci_dev->dev;
 	struct imgu_video_device *node =
 		container_of(vq, struct imgu_video_device, vbq);
 	int r;
+	unsigned int pipe;
+
+	dev_dbg(dev, "%s node name %s pipe %d id %u", __func__,
+		node->name, node->pipe, node->id);
 
 	if (imgu->streaming) {
 		r = -EBUSY;
@@ -341,21 +480,33 @@ static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	if (!node->enabled) {
+		dev_err(dev, "IMGU node is not enabled");
 		r = -EINVAL;
 		goto fail_return_bufs;
 	}
-	r = media_pipeline_start(&node->vdev.entity, &imgu->pipeline);
+
+	pipe = node->pipe;
+	imgu_pipe = &imgu->imgu_pipe[pipe];
+	r = media_pipeline_start(&node->vdev.entity, &imgu_pipe->pipeline);
 	if (r < 0)
 		goto fail_return_bufs;
 
+
 	if (!ipu3_all_nodes_streaming(imgu, node))
 		return 0;
 
-	/* Start streaming of the whole pipeline now */
+	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = v4l2_subdev_call(&imgu->imgu_pipe[pipe].imgu_sd.subdev,
+				     video, s_stream, 1);
+		if (r < 0)
+			goto fail_stop_pipeline;
+	}
 
-	r = v4l2_subdev_call(&imgu->subdev, video, s_stream, 1);
-	if (r < 0)
-		goto fail_stop_pipeline;
+	/* Start streaming of the whole pipeline now */
+	dev_dbg(dev, "IMGU streaming is ready to start");
+	r = imgu_s_stream(imgu, true);
+	if (!r)
+		imgu->streaming = true;
 
 	return 0;
 
@@ -369,20 +520,31 @@ static int ipu3_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
 {
+	struct imgu_media_pipe *imgu_pipe;
 	struct imgu_device *imgu = vb2_get_drv_priv(vq);
+	struct device *dev = &imgu->pci_dev->dev;
 	struct imgu_video_device *node =
 		container_of(vq, struct imgu_video_device, vbq);
 	int r;
+	unsigned int pipe;
 
 	WARN_ON(!node->enabled);
 
+	pipe = node->pipe;
+	dev_dbg(dev, "Try to stream off node [%d][%d]", pipe, node->id);
+	imgu_pipe = &imgu->imgu_pipe[pipe];
+	r = v4l2_subdev_call(&imgu_pipe->imgu_sd.subdev, video, s_stream, 0);
+	if (r)
+		dev_err(&imgu->pci_dev->dev,
+			"failed to stop subdev streaming\n");
+
 	/* Was this the first node with streaming disabled? */
-	if (ipu3_all_nodes_streaming(imgu, node)) {
+	if (imgu->streaming && ipu3_all_nodes_streaming(imgu, node)) {
 		/* Yes, really stop streaming now */
-		r = v4l2_subdev_call(&imgu->subdev, video, s_stream, 0);
-		if (r)
-			dev_err(&imgu->pci_dev->dev,
-				"failed to stop streaming\n");
+		dev_dbg(dev, "IMGU streaming is ready to stop");
+		r = imgu_s_stream(imgu, false);
+		if (!r)
+			imgu->streaming = false;
 	}
 
 	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
@@ -490,29 +652,35 @@ static int ipu3_vidioc_g_fmt(struct file *file, void *fh,
  * Set input/output format. Unless it is just a try, this also resets
  * selections (ie. effective and BDS resolutions) to defaults.
  */
-static int imgu_fmt(struct imgu_device *imgu, int node,
+static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		    struct v4l2_format *f, bool try)
 {
+	struct device *dev = &imgu->pci_dev->dev;
 	struct v4l2_pix_format_mplane try_fmts[IPU3_CSS_QUEUES];
 	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
 	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
 	struct v4l2_mbus_framefmt pad_fmt;
 	unsigned int i, css_q;
 	int r;
+	struct ipu3_css_pipe *css_pipe = &imgu->css.pipes[pipe];
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
+	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
 
-	if (imgu->nodes[IMGU_NODE_PV].enabled &&
-	    imgu->nodes[IMGU_NODE_VF].enabled) {
-		dev_err(&imgu->pci_dev->dev,
-			"Postview and vf are not supported simultaneously\n");
-		return -EINVAL;
-	}
-	/*
-	 * Tell css that the vf q is used for PV
-	 */
-	if (imgu->nodes[IMGU_NODE_PV].enabled)
-		imgu->css.vf_output_en = IPU3_NODE_PV_ENABLED;
-	else if (imgu->nodes[IMGU_NODE_VF].enabled)
-		imgu->css.vf_output_en = IPU3_NODE_VF_ENABLED;
+	dev_dbg(dev, "set fmt node [%u][%u](try = %d)", pipe, node, try);
+
+	for (i = 0; i < IMGU_NODE_NUM; i++)
+		dev_dbg(dev, "IMGU pipe %d node %d enabled = %d",
+			pipe, i, imgu_pipe->nodes[i].enabled);
+
+	if (imgu_pipe->nodes[IMGU_NODE_VF].enabled)
+		css_pipe->vf_output_en = true;
+
+	if (atomic_read(&imgu_sd->running_mode) == IPU3_RUNNING_MODE_VIDEO)
+		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_VIDEO;
+	else
+		css_pipe->pipe_id = IPU3_CSS_PIPE_ID_CAPTURE;
+
+	dev_dbg(dev, "IPU3 pipe %d pipe_id = %d", pipe, css_pipe->pipe_id);
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		unsigned int inode = imgu_map_node(imgu, i);
@@ -520,32 +688,31 @@ static int imgu_fmt(struct imgu_device *imgu, int node,
 		/* Skip the meta node */
 		if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
 			continue;
-		/* imgu_map_node defauls to PV if VF not enabled */
-		if (inode == IMGU_NODE_PV && node == IMGU_NODE_VF &&
-		    imgu->css.vf_output_en == IPU3_NODE_VF_DISABLED)
-			inode = node;
 
 		if (try) {
-			try_fmts[i] = imgu->nodes[inode].vdev_fmt.fmt.pix_mp;
+			try_fmts[i] =
+				imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 			fmts[i] = &try_fmts[i];
 		} else {
-			fmts[i] = &imgu->nodes[inode].vdev_fmt.fmt.pix_mp;
+			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 		}
 
 		/* CSS expects some format on OUT queue */
 		if (i != IPU3_CSS_QUEUE_OUT &&
-		    !imgu->nodes[inode].enabled && inode != node)
+		    !imgu_pipe->nodes[inode].enabled)
 			fmts[i] = NULL;
 	}
 
 	if (!try) {
 		/* eff and bds res got by imgu_s_sel */
-		rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
-		rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
-		rects[IPU3_CSS_RECT_GDC] = &imgu->rect.gdc;
+		struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
+
+		rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu_sd->rect.eff;
+		rects[IPU3_CSS_RECT_BDS] = &imgu_sd->rect.bds;
+		rects[IPU3_CSS_RECT_GDC] = &imgu_sd->rect.gdc;
 
 		/* suppose that pad fmt was set by subdev s_fmt before */
-		pad_fmt = imgu->nodes[IMGU_NODE_IN].pad_fmt;
+		pad_fmt = imgu_pipe->nodes[IMGU_NODE_IN].pad_fmt;
 		rects[IPU3_CSS_RECT_GDC]->width = pad_fmt.width;
 		rects[IPU3_CSS_RECT_GDC]->height = pad_fmt.height;
 	}
@@ -561,9 +728,9 @@ static int imgu_fmt(struct imgu_device *imgu, int node,
 		return -EINVAL;
 
 	if (try)
-		r = ipu3_css_fmt_try(&imgu->css, fmts, rects);
+		r = ipu3_css_fmt_try(&imgu->css, fmts, rects, pipe);
 	else
-		r = ipu3_css_fmt_set(&imgu->css, fmts, rects);
+		r = ipu3_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
 	/* r is the binary number in the firmware blob */
 	if (r < 0)
@@ -572,7 +739,7 @@ static int imgu_fmt(struct imgu_device *imgu, int node,
 	if (try)
 		f->fmt.pix_mp = *fmts[css_q];
 	else
-		f->fmt = imgu->nodes[node].vdev_fmt.fmt;
+		f->fmt = imgu_pipe->nodes[node].vdev_fmt.fmt;
 
 	return 0;
 }
@@ -601,27 +768,37 @@ static int ipu3_vidioc_try_fmt(struct file *file, void *fh,
 			       struct v4l2_format *f)
 {
 	struct imgu_device *imgu = video_drvdata(file);
+	struct device *dev = &imgu->pci_dev->dev;
 	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	int r;
 
+	dev_dbg(dev, "%s [%ux%u] for node %d\n", __func__,
+		pix_mp->width, pix_mp->height, node->id);
+
 	r = ipu3_try_fmt(file, fh, f);
 	if (r)
 		return r;
 
-	return imgu_fmt(imgu, node - imgu->nodes, f, true);
+	return imgu_fmt(imgu, node->pipe, node->id, f, true);
 }
 
 static int ipu3_vidioc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct imgu_device *imgu = video_drvdata(file);
+	struct device *dev = &imgu->pci_dev->dev;
 	struct imgu_video_device *node = file_to_intel_ipu3_node(file);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	int r;
 
+	dev_dbg(dev, "%s [%ux%u] for node %d\n", __func__,
+		pix_mp->width, pix_mp->height, node->id);
+
 	r = ipu3_try_fmt(file, fh, f);
 	if (r)
 		return r;
 
-	return imgu_fmt(imgu, node - imgu->nodes, f, false);
+	return imgu_fmt(imgu, node->pipe, node->id, f, false);
 }
 
 static int ipu3_meta_enum_format(struct file *file, void *fh,
@@ -705,6 +882,11 @@ static struct v4l2_subdev_internal_ops ipu3_subdev_internal_ops = {
 	.open = ipu3_subdev_open,
 };
 
+static const struct v4l2_subdev_core_ops ipu3_subdev_core_ops = {
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
+};
+
 static const struct v4l2_subdev_video_ops ipu3_subdev_video_ops = {
 	.s_stream = ipu3_subdev_s_stream,
 };
@@ -718,6 +900,7 @@ static const struct v4l2_subdev_pad_ops ipu3_subdev_pad_ops = {
 };
 
 static const struct v4l2_subdev_ops ipu3_subdev_ops = {
+	.core = &ipu3_subdev_core_ops,
 	.video = &ipu3_subdev_video_ops,
 	.pad = &ipu3_subdev_pad_ops,
 };
@@ -811,6 +994,40 @@ static const struct v4l2_ioctl_ops ipu3_v4l2_meta_ioctl_ops = {
 	.vidioc_expbuf = vb2_ioctl_expbuf,
 };
 
+static int ipu3_sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(ctrl->handler, struct imgu_v4l2_subdev, ctrl_handler);
+	struct imgu_device *imgu = v4l2_get_subdevdata(&imgu_sd->subdev);
+	struct device *dev = &imgu->pci_dev->dev;
+
+	dev_dbg(dev, "set val %d to ctrl 0x%8x for subdev %d",
+		ctrl->val, ctrl->id, imgu_sd->pipe);
+
+	switch (ctrl->id) {
+	case V4L2_CID_INTEL_IPU3_MODE:
+		atomic_set(&imgu_sd->running_mode, ctrl->val);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct v4l2_ctrl_ops ipu3_subdev_ctrl_ops = {
+	.s_ctrl = ipu3_sd_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config ipu3_subdev_ctrl_mode = {
+	.ops = &ipu3_subdev_ctrl_ops,
+	.id = V4L2_CID_INTEL_IPU3_MODE,
+	.name = "IPU3 Pipe Mode",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = IPU3_RUNNING_MODE_VIDEO,
+	.max = IPU3_RUNNING_MODE_STILL,
+	.step = 1,
+	.def = IPU3_RUNNING_MODE_VIDEO,
+};
+
 /******************** Framework registration ********************/
 
 /* helper function to config node's video properties */
@@ -851,70 +1068,85 @@ static void ipu3_node_to_v4l2(u32 node, struct video_device *vdev,
 	vdev->device_caps = V4L2_CAP_STREAMING | cap;
 }
 
-int ipu3_v4l2_register(struct imgu_device *imgu)
+static int ipu3_v4l2_subdev_register(struct imgu_device *imgu,
+				     struct imgu_v4l2_subdev *imgu_sd,
+				     unsigned int pipe)
 {
-	struct v4l2_mbus_framefmt def_bus_fmt = { 0 };
-	struct v4l2_pix_format_mplane def_pix_fmt = { 0 };
-
 	int i, r;
-
-	/* Initialize miscellaneous variables */
-	imgu->streaming = false;
-
-	/* Init media device */
-	media_device_pci_init(&imgu->media_dev, imgu->pci_dev, IMGU_NAME);
-
-	/* Set up v4l2 device */
-	imgu->v4l2_dev.mdev = &imgu->media_dev;
-	imgu->v4l2_dev.ctrl_handler = imgu->ctrl_handler;
-	r = v4l2_device_register(&imgu->pci_dev->dev, &imgu->v4l2_dev);
-	if (r) {
-		dev_err(&imgu->pci_dev->dev,
-			"failed to register V4L2 device (%d)\n", r);
-		goto fail_v4l2_dev;
-	}
+	struct v4l2_ctrl_handler *hdl = &imgu_sd->ctrl_handler;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	/* Initialize subdev media entity */
-	imgu->subdev_pads = kzalloc(sizeof(*imgu->subdev_pads) *
+	imgu_sd->subdev_pads = kzalloc(sizeof(*imgu_sd->subdev_pads) *
 					IMGU_NODE_NUM, GFP_KERNEL);
-	if (!imgu->subdev_pads) {
-		r = -ENOMEM;
-		goto fail_subdev_pads;
-	}
-	r = media_entity_pads_init(&imgu->subdev.entity, IMGU_NODE_NUM,
-				   imgu->subdev_pads);
+	if (!imgu_sd->subdev_pads)
+		return -ENOMEM;
+
+	r = media_entity_pads_init(&imgu_sd->subdev.entity, IMGU_NODE_NUM,
+				   imgu_sd->subdev_pads);
 	if (r) {
 		dev_err(&imgu->pci_dev->dev,
 			"failed initialize subdev media entity (%d)\n", r);
 		goto fail_media_entity;
 	}
-	imgu->subdev.entity.ops = &ipu3_media_ops;
+	imgu_sd->subdev.entity.ops = &ipu3_media_ops;
 	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		imgu->subdev_pads[i].flags = imgu->nodes[i].output ?
+		imgu_sd->subdev_pads[i].flags = imgu_pipe->nodes[i].output ?
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 	}
 
 	/* Initialize subdev */
-	v4l2_subdev_init(&imgu->subdev, &ipu3_subdev_ops);
-	imgu->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_STATISTICS;
-	imgu->subdev.internal_ops = &ipu3_subdev_internal_ops;
-	imgu->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strlcpy(imgu->subdev.name, IMGU_NAME, sizeof(imgu->subdev.name));
-	v4l2_set_subdevdata(&imgu->subdev, imgu);
-	imgu->subdev.ctrl_handler = imgu->ctrl_handler;
-	r = v4l2_device_register_subdev(&imgu->v4l2_dev, &imgu->subdev);
-	if (r) {
+	v4l2_subdev_init(&imgu_sd->subdev, &ipu3_subdev_ops);
+	imgu_sd->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_STATISTICS;
+	imgu_sd->subdev.internal_ops = &ipu3_subdev_internal_ops;
+	imgu_sd->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE |
+				V4L2_SUBDEV_FL_HAS_EVENTS;
+	snprintf(imgu_sd->subdev.name, sizeof(imgu_sd->subdev.name),
+		 "%s %d", IMGU_NAME, pipe);
+	v4l2_set_subdevdata(&imgu_sd->subdev, imgu);
+	atomic_set(&imgu_sd->running_mode, IPU3_RUNNING_MODE_VIDEO);
+	v4l2_ctrl_handler_init(hdl, 1);
+	imgu_sd->subdev.ctrl_handler = hdl;
+	imgu_sd->ctrl = v4l2_ctrl_new_custom(hdl, &ipu3_subdev_ctrl_mode, NULL);
+	if (hdl->error) {
+		r = hdl->error;
 		dev_err(&imgu->pci_dev->dev,
-			"failed initialize subdev (%d)\n", r);
+			"failed to create subdev v4l2 ctrl with err %d", r);
 		goto fail_subdev;
 	}
-	r = v4l2_device_register_subdev_nodes(&imgu->v4l2_dev);
+	r = v4l2_device_register_subdev(&imgu->v4l2_dev, &imgu_sd->subdev);
 	if (r) {
 		dev_err(&imgu->pci_dev->dev,
-			"failed to register subdevs (%d)\n", r);
-		goto fail_subdevs;
+			"failed initialize subdev (%d)\n", r);
+		goto fail_subdev;
 	}
 
+	imgu_sd->pipe = pipe;
+	return 0;
+
+fail_subdev:
+	v4l2_ctrl_handler_free(imgu_sd->subdev.ctrl_handler);
+	media_entity_cleanup(&imgu_sd->subdev.entity);
+fail_media_entity:
+	kfree(imgu_sd->subdev_pads);
+
+	return r;
+}
+
+static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
+				int node_num)
+{
+	int r;
+	u32 flags;
+	struct v4l2_mbus_framefmt def_bus_fmt = { 0 };
+	struct v4l2_pix_format_mplane def_pix_fmt = { 0 };
+	struct device *dev = &imgu->pci_dev->dev;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
+	struct v4l2_subdev *sd = &imgu_pipe->imgu_sd.subdev;
+	struct imgu_video_device *node = &imgu_pipe->nodes[node_num];
+	struct video_device *vdev = &node->vdev;
+	struct vb2_queue *vbq = &node->vbq;
+
 	/* Initialize formats to default values */
 	def_bus_fmt.width = 1920;
 	def_bus_fmt.height = 1080;
@@ -938,117 +1170,240 @@ int ipu3_v4l2_register(struct imgu_device *imgu)
 	def_pix_fmt.quantization = def_bus_fmt.quantization;
 	def_pix_fmt.xfer_func = def_bus_fmt.xfer_func;
 
-	/* Create video nodes and links */
+	/* Initialize miscellaneous variables */
+	mutex_init(&node->lock);
+	INIT_LIST_HEAD(&node->buffers);
+
+	/* Initialize formats to default values */
+	node->pad_fmt = def_bus_fmt;
+	node->id = node_num;
+	node->pipe = pipe;
+	ipu3_node_to_v4l2(node_num, vdev, &node->vdev_fmt);
+	if (node->vdev_fmt.type ==
+	    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
+	    node->vdev_fmt.type ==
+	    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		def_pix_fmt.pixelformat = node->output ?
+			V4L2_PIX_FMT_IPU3_SGRBG10 :
+			V4L2_PIX_FMT_NV12;
+		node->vdev_fmt.fmt.pix_mp = def_pix_fmt;
+	}
+
+	/* Initialize media entities */
+	r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
+	if (r) {
+		dev_err(dev, "failed initialize media entity (%d)\n", r);
+		mutex_destroy(&node->lock);
+		return r;
+	}
+	node->vdev_pad.flags = node->output ?
+		MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
+	vdev->entity.ops = NULL;
+
+	/* Initialize vbq */
+	vbq->type = node->vdev_fmt.type;
+	vbq->io_modes = VB2_USERPTR | VB2_MMAP | VB2_DMABUF;
+	vbq->ops = &ipu3_vb2_ops;
+	vbq->mem_ops = &vb2_dma_sg_memops;
+	if (imgu->buf_struct_size <= 0)
+		imgu->buf_struct_size =
+			sizeof(struct ipu3_vb2_buffer);
+	vbq->buf_struct_size = imgu->buf_struct_size;
+	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	/* can streamon w/o buffers */
+	vbq->min_buffers_needed = 0;
+	vbq->drv_priv = imgu;
+	vbq->lock = &node->lock;
+	r = vb2_queue_init(vbq);
+	if (r) {
+		dev_err(dev, "failed to initialize video queue (%d)", r);
+		media_entity_cleanup(&vdev->entity);
+		return r;
+	}
+
+	/* Initialize vdev */
+	snprintf(vdev->name, sizeof(vdev->name), "%s %d %s",
+		 IMGU_NAME, pipe, node->name);
+	vdev->release = video_device_release_empty;
+	vdev->fops = &ipu3_v4l2_fops;
+	vdev->lock = &node->lock;
+	vdev->v4l2_dev = &imgu->v4l2_dev;
+	vdev->queue = &node->vbq;
+	vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
+	video_set_drvdata(vdev, imgu);
+	r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (r) {
+		dev_err(dev, "failed to register video device (%d)", r);
+		media_entity_cleanup(&vdev->entity);
+		return r;
+	}
+
+	/* Create link between video node and the subdev pad */
+	flags = 0;
+	if (node->enabled)
+		flags |= MEDIA_LNK_FL_ENABLED;
+	if (node->output) {
+		r = media_create_pad_link(&vdev->entity, 0, &sd->entity,
+					  node_num, flags);
+	} else {
+		r = media_create_pad_link(&sd->entity, node_num, &vdev->entity,
+					  0, flags);
+	}
+	if (r) {
+		dev_err(dev, "failed to create pad link (%d)", r);
+		video_unregister_device(vdev);
+		return r;
+	}
+
+	return 0;
+}
+
+static void ipu3_v4l2_nodes_cleanup_pipe(struct imgu_device *imgu,
+					 unsigned int pipe, int node)
+{
+	int i;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
+
+	for (i = 0; i < node; i++) {
+		video_unregister_device(&imgu_pipe->nodes[i].vdev);
+		media_entity_cleanup(&imgu_pipe->nodes[i].vdev.entity);
+		mutex_destroy(&imgu_pipe->nodes[i].lock);
+	}
+}
+
+static void ipu3_v4l2_nodes_cleanup(struct imgu_device *imgu, unsigned int pipe)
+{
+	int i;
+
+	for (i = 0; i < pipe; i++) {
+		ipu3_v4l2_nodes_cleanup_pipe(imgu, i, IMGU_NODE_NUM);
+	}
+}
+
+static int ipu3_v4l2_nodes_setup_pipe(struct imgu_device *imgu, int pipe)
+{
+	int i, r;
+
 	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		struct imgu_video_device *node = &imgu->nodes[i];
-		struct video_device *vdev = &node->vdev;
-		struct vb2_queue *vbq = &node->vbq;
-		u32 flags;
-
-		/* Initialize miscellaneous variables */
-		mutex_init(&node->lock);
-		INIT_LIST_HEAD(&node->buffers);
-
-		/* Initialize formats to default values */
-		node->pad_fmt = def_bus_fmt;
-		ipu3_node_to_v4l2(i, vdev, &node->vdev_fmt);
-		if (node->vdev_fmt.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
-		    node->vdev_fmt.type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-			def_pix_fmt.pixelformat = node->output ?
-						V4L2_PIX_FMT_IPU3_SGRBG10 :
-						V4L2_PIX_FMT_NV12;
-			node->vdev_fmt.fmt.pix_mp = def_pix_fmt;
-		}
-		/* Initialize media entities */
-		r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
-		if (r) {
-			dev_err(&imgu->pci_dev->dev,
-				"failed initialize media entity (%d)\n", r);
-			goto fail_vdev_media_entity;
-		}
-		node->vdev_pad.flags = node->output ?
-			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
-		vdev->entity.ops = NULL;
-
-		/* Initialize vbq */
-		vbq->type = node->vdev_fmt.type;
-		vbq->io_modes = VB2_USERPTR | VB2_MMAP | VB2_DMABUF;
-		vbq->ops = &ipu3_vb2_ops;
-		vbq->mem_ops = &vb2_dma_sg_memops;
-		if (imgu->buf_struct_size <= 0)
-			imgu->buf_struct_size = sizeof(struct ipu3_vb2_buffer);
-		vbq->buf_struct_size = imgu->buf_struct_size;
-		vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers */
-		vbq->drv_priv = imgu;
-		vbq->lock = &node->lock;
-		r = vb2_queue_init(vbq);
-		if (r) {
-			dev_err(&imgu->pci_dev->dev,
-				"failed to initialize video queue (%d)\n", r);
-			goto fail_vdev;
-		}
+		r = ipu3_v4l2_node_setup(imgu, pipe, i);
+		if (r)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	ipu3_v4l2_nodes_cleanup_pipe(imgu, pipe, i);
+	return r;
+}
+
+static int ipu3_v4l2_nodes_setup(struct imgu_device *imgu)
+{
+	int i, r;
+
+	/* Create video nodes and links */
+	for (i = 0; i < IMGU_MAX_PIPE_NUM; i++) {
+		r = ipu3_v4l2_nodes_setup_pipe(imgu, i);
+		if (r)
+			goto cleanup;
+	}
+
+	return 0;
 
-		/* Initialize vdev */
-		snprintf(vdev->name, sizeof(vdev->name), "%s %s",
-			 IMGU_NAME, node->name);
-		vdev->release = video_device_release_empty;
-		vdev->fops = &ipu3_v4l2_fops;
-		vdev->lock = &node->lock;
-		vdev->v4l2_dev = &imgu->v4l2_dev;
-		vdev->queue = &node->vbq;
-		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
-		video_set_drvdata(vdev, imgu);
-		r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+cleanup:
+	ipu3_v4l2_nodes_cleanup(imgu, i);
+	return r;
+}
+
+static void ipu3_v4l2_subdevs_cleanup(struct imgu_device *imgu,
+				      unsigned int pipe)
+{
+	int i;
+	struct imgu_media_pipe *imgu_pipe;
+
+	for (i = 0; i < pipe; i++) {
+		imgu_pipe = &imgu->imgu_pipe[i];
+		v4l2_device_unregister_subdev(&imgu_pipe->imgu_sd.subdev);
+		v4l2_ctrl_handler_free(imgu_pipe->imgu_sd.subdev.ctrl_handler);
+		media_entity_cleanup(&imgu_pipe->imgu_sd.subdev.entity);
+		kfree(imgu_pipe->imgu_sd.subdev_pads);
+	}
+}
+
+static int ipu3_v4l2_register_pipes(struct imgu_device *imgu)
+{
+	struct imgu_media_pipe *imgu_pipe;
+	int i, r;
+
+	for (i = 0; i < IMGU_MAX_PIPE_NUM; i++) {
+		imgu_pipe = &imgu->imgu_pipe[i];
+		r = ipu3_v4l2_subdev_register(imgu, &imgu_pipe->imgu_sd, i);
 		if (r) {
 			dev_err(&imgu->pci_dev->dev,
-				"failed to register video device (%d)\n", r);
-			goto fail_vdev;
+				"failed to register subdev%d ret (%d)\n", i, r);
+			break;
 		}
+	}
 
-		/* Create link between video node and the subdev pad */
-		flags = 0;
-		if (node->enabled)
-			flags |= MEDIA_LNK_FL_ENABLED;
-		if (node->immutable)
-			flags |= MEDIA_LNK_FL_IMMUTABLE;
-		if (node->output) {
-			r = media_create_pad_link(&vdev->entity, 0,
-						  &imgu->subdev.entity,
-						 i, flags);
-		} else {
-			r = media_create_pad_link(&imgu->subdev.entity,
-						  i, &vdev->entity, 0, flags);
-		}
-		if (r)
-			goto fail_link;
+	if (i == IMGU_MAX_PIPE_NUM)
+		return 0;
+
+	ipu3_v4l2_subdevs_cleanup(imgu, i);
+	return r;
+}
+
+int ipu3_v4l2_register(struct imgu_device *imgu)
+{
+	int r;
+
+	/* Initialize miscellaneous variables */
+	imgu->streaming = false;
+
+	/* Set up media device */
+	media_device_pci_init(&imgu->media_dev, imgu->pci_dev, IMGU_NAME);
+
+	/* Set up v4l2 device */
+	imgu->v4l2_dev.mdev = &imgu->media_dev;
+	imgu->v4l2_dev.ctrl_handler = NULL;
+	r = v4l2_device_register(&imgu->pci_dev->dev, &imgu->v4l2_dev);
+	if (r) {
+		dev_err(&imgu->pci_dev->dev,
+			"failed to register V4L2 device (%d)\n", r);
+		goto fail_v4l2_dev;
+	}
+
+	r = ipu3_v4l2_register_pipes(imgu);
+	if (r) {
+		dev_err(&imgu->pci_dev->dev,
+			"failed to register pipes (%d)\n", r);
+		goto fail_v4l2_pipes;
+	}
+
+	r = v4l2_device_register_subdev_nodes(&imgu->v4l2_dev);
+	if (r) {
+		dev_err(&imgu->pci_dev->dev,
+			"failed to register subdevs (%d)\n", r);
+		goto fail_subdevs;
+	}
+
+	r = ipu3_v4l2_nodes_setup(imgu);
+	if (r) {
+		dev_err(&imgu->pci_dev->dev, "failed to setup nodes (%d)", r);
+		goto fail_subdevs;
 	}
 
 	r = media_device_register(&imgu->media_dev);
 	if (r) {
 		dev_err(&imgu->pci_dev->dev,
 			"failed to register media device (%d)\n", r);
-		i--;
-		goto fail_link;
+		goto fail_subdevs;
 	}
 
 	return 0;
 
-	for (; i >= 0; i--) {
-fail_link:
-		video_unregister_device(&imgu->nodes[i].vdev);
-fail_vdev:
-		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
-fail_vdev_media_entity:
-		mutex_destroy(&imgu->nodes[i].lock);
-	}
 fail_subdevs:
-	v4l2_device_unregister_subdev(&imgu->subdev);
-fail_subdev:
-	media_entity_cleanup(&imgu->subdev.entity);
-fail_media_entity:
-	kfree(imgu->subdev_pads);
-fail_subdev_pads:
+	ipu3_v4l2_subdevs_cleanup(imgu, IMGU_MAX_PIPE_NUM);
+fail_v4l2_pipes:
 	v4l2_device_unregister(&imgu->v4l2_dev);
 fail_v4l2_dev:
 	media_device_cleanup(&imgu->media_dev);
@@ -1059,21 +1414,11 @@ EXPORT_SYMBOL_GPL(ipu3_v4l2_register);
 
 int ipu3_v4l2_unregister(struct imgu_device *imgu)
 {
-	unsigned int i;
-
 	media_device_unregister(&imgu->media_dev);
-	media_device_cleanup(&imgu->media_dev);
-
-	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		video_unregister_device(&imgu->nodes[i].vdev);
-		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
-		mutex_destroy(&imgu->nodes[i].lock);
-	}
-
-	v4l2_device_unregister_subdev(&imgu->subdev);
-	media_entity_cleanup(&imgu->subdev.entity);
-	kfree(imgu->subdev_pads);
+	ipu3_v4l2_nodes_cleanup(imgu, IMGU_MAX_PIPE_NUM);
+	ipu3_v4l2_subdevs_cleanup(imgu, IMGU_MAX_PIPE_NUM);
 	v4l2_device_unregister(&imgu->v4l2_dev);
+	media_device_cleanup(&imgu->media_dev);
 
 	return 0;
 }
diff --git a/drivers/media/pci/intel/ipu3/ipu3.c b/drivers/media/pci/intel/ipu3/ipu3.c
index eda7299..ff2c35a 100644
--- a/drivers/media/pci/intel/ipu3/ipu3.c
+++ b/drivers/media/pci/intel/ipu3/ipu3.c
@@ -45,7 +45,6 @@ static const struct imgu_node_mapping imgu_node_map[IMGU_NODE_NUM] = {
 	[IMGU_NODE_PARAMS] = {IPU3_CSS_QUEUE_PARAMS, "parameters"},
 	[IMGU_NODE_OUT] = {IPU3_CSS_QUEUE_OUT, "output"},
 	[IMGU_NODE_VF] = {IPU3_CSS_QUEUE_VF, "viewfinder"},
-	[IMGU_NODE_PV] = {IPU3_CSS_QUEUE_VF, "postview"},
 	[IMGU_NODE_STAT_3A] = {IPU3_CSS_QUEUE_STAT_3A, "3a stat"},
 };
 
@@ -58,10 +57,6 @@ unsigned int imgu_map_node(struct imgu_device *imgu, unsigned int css_queue)
 {
 	unsigned int i;
 
-	if (css_queue == IPU3_CSS_QUEUE_VF)
-		return imgu->nodes[IMGU_NODE_VF].enabled ?
-			IMGU_NODE_VF : IMGU_NODE_PV;
-
 	for (i = 0; i < IMGU_NODE_NUM; i++)
 		if (imgu_node_map[i].css_queue == css_queue)
 			break;
@@ -71,18 +66,22 @@ unsigned int imgu_map_node(struct imgu_device *imgu, unsigned int css_queue)
 
 /**************** Dummy buffers ****************/
 
-static void imgu_dummybufs_cleanup(struct imgu_device *imgu)
+static void imgu_dummybufs_cleanup(struct imgu_device *imgu, unsigned int pipe)
 {
 	unsigned int i;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++)
-		ipu3_dmamap_free(imgu, &imgu->queues[i].dmap);
+		ipu3_dmamap_free(imgu,
+				 &imgu_pipe->queues[i].dmap);
 }
 
-static int imgu_dummybufs_preallocate(struct imgu_device *imgu)
+static int imgu_dummybufs_preallocate(struct imgu_device *imgu,
+				      unsigned int pipe)
 {
 	unsigned int i;
 	size_t size;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		size = css_queue_buf_size_map[i];
@@ -94,8 +93,9 @@ static int imgu_dummybufs_preallocate(struct imgu_device *imgu)
 		if (i == IMGU_QUEUE_MASTER || size == 0)
 			continue;
 
-		if (!ipu3_dmamap_alloc(imgu, &imgu->queues[i].dmap, size)) {
-			imgu_dummybufs_cleanup(imgu);
+		if (!ipu3_dmamap_alloc(imgu,
+				       &imgu_pipe->queues[i].dmap, size)) {
+			imgu_dummybufs_cleanup(imgu, pipe);
 			return -ENOMEM;
 		}
 	}
@@ -103,45 +103,46 @@ static int imgu_dummybufs_preallocate(struct imgu_device *imgu)
 	return 0;
 }
 
-static int imgu_dummybufs_init(struct imgu_device *imgu)
+static int imgu_dummybufs_init(struct imgu_device *imgu, unsigned int pipe)
 {
 	const struct v4l2_pix_format_mplane *mpix;
 	const struct v4l2_meta_format	*meta;
-	unsigned int i, j, node;
+	unsigned int i, k, node;
 	size_t size;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	/* Allocate a dummy buffer for each queue where buffer is optional */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		node = imgu_map_node(imgu, i);
-		if (!imgu->queue_enabled[node] || i == IMGU_QUEUE_MASTER)
+		if (!imgu_pipe->queue_enabled[node] || i == IMGU_QUEUE_MASTER)
 			continue;
 
-		if (!imgu->nodes[IMGU_NODE_VF].enabled &&
-		    !imgu->nodes[IMGU_NODE_PV].enabled &&
+		if (!imgu_pipe->nodes[IMGU_NODE_VF].enabled &&
 		    i == IPU3_CSS_QUEUE_VF)
 			/*
-			 * Do not enable dummy buffers for VF/PV if it is not
+			 * Do not enable dummy buffers for VF if it is not
 			 * requested by the user.
 			 */
 			continue;
 
-		meta = &imgu->nodes[node].vdev_fmt.fmt.meta;
-		mpix = &imgu->nodes[node].vdev_fmt.fmt.pix_mp;
+		meta = &imgu_pipe->nodes[node].vdev_fmt.fmt.meta;
+		mpix = &imgu_pipe->nodes[node].vdev_fmt.fmt.pix_mp;
 
 		if (node == IMGU_NODE_STAT_3A || node == IMGU_NODE_PARAMS)
 			size = meta->buffersize;
 		else
 			size = mpix->plane_fmt[0].sizeimage;
 
-		if (ipu3_css_dma_buffer_resize(imgu, &imgu->queues[i].dmap,
+		if (ipu3_css_dma_buffer_resize(imgu,
+					       &imgu_pipe->queues[i].dmap,
 					       size)) {
-			imgu_dummybufs_cleanup(imgu);
+			imgu_dummybufs_cleanup(imgu, pipe);
 			return -ENOMEM;
 		}
 
-		for (j = 0; j < IMGU_MAX_QUEUE_DEPTH; j++)
-			ipu3_css_buf_init(&imgu->queues[i].dummybufs[j], i,
-					  imgu->queues[i].dmap.daddr);
+		for (k = 0; k < IMGU_MAX_QUEUE_DEPTH; k++)
+			ipu3_css_buf_init(&imgu_pipe->queues[i].dummybufs[k], i,
+					  imgu_pipe->queues[i].dmap.daddr);
 	}
 
 	return 0;
@@ -149,40 +150,43 @@ static int imgu_dummybufs_init(struct imgu_device *imgu)
 
 /* May be called from atomic context */
 static struct ipu3_css_buffer *imgu_dummybufs_get(struct imgu_device *imgu,
-						  int queue)
+						   int queue, unsigned int pipe)
 {
 	unsigned int i;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	/* dummybufs are not allocated for master q */
 	if (queue == IPU3_CSS_QUEUE_IN)
 		return NULL;
 
-	if (WARN_ON(!imgu->queues[queue].dmap.vaddr))
+	if (WARN_ON(!imgu_pipe->queues[queue].dmap.vaddr))
 		/* Buffer should not be allocated here */
 		return NULL;
 
 	for (i = 0; i < IMGU_MAX_QUEUE_DEPTH; i++)
-		if (ipu3_css_buf_state(&imgu->queues[queue].dummybufs[i]) !=
+		if (ipu3_css_buf_state(&imgu_pipe->queues[queue].dummybufs[i]) !=
 			IPU3_CSS_BUFFER_QUEUED)
 			break;
 
 	if (i == IMGU_MAX_QUEUE_DEPTH)
 		return NULL;
 
-	ipu3_css_buf_init(&imgu->queues[queue].dummybufs[i], queue,
-			  imgu->queues[queue].dmap.daddr);
+	ipu3_css_buf_init(&imgu_pipe->queues[queue].dummybufs[i], queue,
+			  imgu_pipe->queues[queue].dmap.daddr);
 
-	return &imgu->queues[queue].dummybufs[i];
+	return &imgu_pipe->queues[queue].dummybufs[i];
 }
 
 /* Check if given buffer is a dummy buffer */
 static bool imgu_dummybufs_check(struct imgu_device *imgu,
-				 struct ipu3_css_buffer *buf)
+				 struct ipu3_css_buffer *buf,
+				 unsigned int pipe)
 {
 	unsigned int i;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	for (i = 0; i < IMGU_MAX_QUEUE_DEPTH; i++)
-		if (buf == &imgu->queues[buf->queue].dummybufs[i])
+		if (buf == &imgu_pipe->queues[buf->queue].dummybufs[i])
 			break;
 
 	return i < IMGU_MAX_QUEUE_DEPTH;
@@ -197,63 +201,64 @@ static void imgu_buffer_done(struct imgu_device *imgu, struct vb2_buffer *vb,
 }
 
 static struct ipu3_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
-						 unsigned int node)
+						 unsigned int node,
+						 unsigned int pipe)
 {
 	struct imgu_buffer *buf;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	if (WARN_ON(node >= IMGU_NODE_NUM))
 		return NULL;
 
 	/* Find first free buffer from the node */
-	list_for_each_entry(buf, &imgu->nodes[node].buffers, vid_buf.list) {
+	list_for_each_entry(buf, &imgu_pipe->nodes[node].buffers, vid_buf.list) {
 		if (ipu3_css_buf_state(&buf->css_buf) == IPU3_CSS_BUFFER_NEW)
 			return &buf->css_buf;
 	}
 
 	/* There were no free buffers, try to return a dummy buffer */
-	return imgu_dummybufs_get(imgu, imgu_node_map[node].css_queue);
+	return imgu_dummybufs_get(imgu, imgu_node_map[node].css_queue, pipe);
 }
 
 /*
  * Queue as many buffers to CSS as possible. If all buffers don't fit into
  * CSS buffer queues, they remain unqueued and will be queued later.
  */
-int imgu_queue_buffers(struct imgu_device *imgu, bool initial)
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe)
 {
 	unsigned int node;
 	int r = 0;
 	struct imgu_buffer *ibuf;
+	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	if (!ipu3_css_is_streaming(&imgu->css))
 		return 0;
 
+	dev_dbg(&imgu->pci_dev->dev, "Queue buffers to pipe %d", pipe);
 	mutex_lock(&imgu->lock);
 
 	/* Buffer set is queued to FW only when input buffer is ready */
 	for (node = IMGU_NODE_NUM - 1;
-	     imgu_queue_getbuf(imgu, IMGU_NODE_IN);
+	     imgu_queue_getbuf(imgu, IMGU_NODE_IN, pipe);
 	     node = node ? node - 1 : IMGU_NODE_NUM - 1) {
 
 		if (node == IMGU_NODE_VF &&
-		    (imgu->css.pipe_id == IPU3_CSS_PIPE_ID_CAPTURE ||
-		     !imgu->nodes[IMGU_NODE_VF].enabled)) {
-			continue;
-		} else if (node == IMGU_NODE_PV &&
-			   (imgu->css.pipe_id == IPU3_CSS_PIPE_ID_VIDEO ||
-			    !imgu->nodes[IMGU_NODE_PV].enabled)) {
+		    !imgu_pipe->nodes[IMGU_NODE_VF].enabled) {
+			dev_warn(&imgu->pci_dev->dev,
+				 "Vf not enabled, ignore queue");
 			continue;
-		} else if (imgu->queue_enabled[node]) {
+		} else if (imgu_pipe->queue_enabled[node]) {
 			struct ipu3_css_buffer *buf =
-					imgu_queue_getbuf(imgu, node);
+				imgu_queue_getbuf(imgu, node, pipe);
 			int dummy;
 
 			if (!buf)
 				break;
 
-			r = ipu3_css_buf_queue(&imgu->css, buf);
+			r = ipu3_css_buf_queue(&imgu->css, pipe, buf);
 			if (r)
 				break;
-			dummy = imgu_dummybufs_check(imgu, buf);
+			dummy = imgu_dummybufs_check(imgu, buf, pipe);
 			if (!dummy)
 				ibuf = container_of(buf, struct imgu_buffer,
 						    css_buf);
@@ -288,14 +293,15 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial)
 	for (node = 0; node < IMGU_NODE_NUM; node++) {
 		struct imgu_buffer *buf, *buf0;
 
-		if (!imgu->queue_enabled[node])
+		if (!imgu_pipe->queue_enabled[node])
 			continue;	/* Skip disabled queues */
 
 		mutex_lock(&imgu->lock);
-		list_for_each_entry_safe(buf, buf0, &imgu->nodes[node].buffers,
+		list_for_each_entry_safe(buf, buf0,
+					 &imgu_pipe->nodes[node].buffers,
 					 vid_buf.list) {
 			if (ipu3_css_buf_state(&buf->css_buf) ==
-					IPU3_CSS_BUFFER_QUEUED)
+			    IPU3_CSS_BUFFER_QUEUED)
 				continue;	/* Was already queued, skip */
 
 			ipu3_v4l2_buffer_done(&buf->vid_buf.vbb.vb2_buf,
@@ -328,10 +334,7 @@ static void imgu_powerdown(struct imgu_device *imgu)
 int imgu_s_stream(struct imgu_device *imgu, int enable)
 {
 	struct device *dev = &imgu->pci_dev->dev;
-	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
-	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
-	unsigned int i, node;
-	int r;
+	int r, pipe;
 
 	if (!enable) {
 		/* Stop streaming */
@@ -347,54 +350,6 @@ int imgu_s_stream(struct imgu_device *imgu, int enable)
 		return 0;
 	}
 
-	/* Start streaming */
-
-	dev_dbg(dev, "stream on\n");
-	for (i = 0; i < IMGU_NODE_NUM; i++)
-		imgu->queue_enabled[i] = imgu->nodes[i].enabled;
-
-	/*
-	 * CSS library expects that the following queues are
-	 * always enabled; if buffers are not provided to some of the
-	 * queues, it stalls due to lack of buffers.
-	 * Force the queues to be enabled and if the user really hasn't
-	 * enabled them, use dummy buffers.
-	 */
-	imgu->queue_enabled[IMGU_NODE_OUT] = true;
-	imgu->queue_enabled[IMGU_NODE_VF] = true;
-	imgu->queue_enabled[IMGU_NODE_PV] = true;
-	imgu->queue_enabled[IMGU_NODE_STAT_3A] = true;
-
-	/* This is handled specially */
-	imgu->queue_enabled[IPU3_CSS_QUEUE_PARAMS] = false;
-
-	/* Initialize CSS formats */
-	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
-		node = imgu_map_node(imgu, i);
-		/* No need to reconfig meta nodes */
-		if (node == IMGU_NODE_STAT_3A || node == IMGU_NODE_PARAMS)
-			continue;
-		fmts[i] = imgu->queue_enabled[node] ?
-			&imgu->nodes[node].vdev_fmt.fmt.pix_mp : NULL;
-	}
-
-	/* Enable VF output only when VF or PV queue requested by user */
-	imgu->css.vf_output_en = IPU3_NODE_VF_DISABLED;
-	if (imgu->nodes[IMGU_NODE_VF].enabled)
-		imgu->css.vf_output_en = IPU3_NODE_VF_ENABLED;
-	else if (imgu->nodes[IMGU_NODE_PV].enabled)
-		imgu->css.vf_output_en = IPU3_NODE_PV_ENABLED;
-
-	rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
-	rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
-	rects[IPU3_CSS_RECT_GDC] = &imgu->rect.gdc;
-
-	r = ipu3_css_fmt_set(&imgu->css, fmts, rects);
-	if (r) {
-		dev_err(dev, "failed to set initial formats (%d)", r);
-		return r;
-	}
-
 	/* Set Power */
 	r = pm_runtime_get_sync(dev);
 	if (r < 0) {
@@ -417,24 +372,26 @@ int imgu_s_stream(struct imgu_device *imgu, int enable)
 		goto fail_start_streaming;
 	}
 
-	/* Initialize dummy buffers */
-	r = imgu_dummybufs_init(imgu);
-	if (r) {
-		dev_err(dev, "failed to initialize dummy buffers (%d)", r);
-		goto fail_dummybufs;
-	}
+	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		/* Initialize dummy buffers */
+		r = imgu_dummybufs_init(imgu, pipe);
+		if (r) {
+			dev_err(dev, "failed to initialize dummy buffers (%d)", r);
+			goto fail_dummybufs;
+		}
 
-	/* Queue as many buffers from queue as possible */
-	r = imgu_queue_buffers(imgu, true);
-	if (r) {
-		dev_err(dev, "failed to queue initial buffers (%d)", r);
-		goto fail_queueing;
+		/* Queue as many buffers from queue as possible */
+		r = imgu_queue_buffers(imgu, true, pipe);
+		if (r) {
+			dev_err(dev, "failed to queue initial buffers (%d)", r);
+			goto fail_queueing;
+		}
 	}
 
 	return 0;
-
 fail_queueing:
-	imgu_dummybufs_cleanup(imgu);
+	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM)
+		imgu_dummybufs_cleanup(imgu, pipe);
 fail_dummybufs:
 	ipu3_css_stop_streaming(&imgu->css);
 fail_start_streaming:
@@ -447,51 +404,66 @@ static int imgu_video_nodes_init(struct imgu_device *imgu)
 {
 	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
 	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
-	unsigned int i;
+	struct imgu_media_pipe *imgu_pipe;
+	unsigned int i, j;
 	int r;
 
 	imgu->buf_struct_size = sizeof(struct imgu_buffer);
 
-	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		imgu->nodes[i].name = imgu_node_map[i].name;
-		imgu->nodes[i].output = i < IMGU_QUEUE_FIRST_INPUT;
-		imgu->nodes[i].immutable = false;
-		imgu->nodes[i].enabled = false;
+	for (j = 0; j < IMGU_MAX_PIPE_NUM; j++) {
+		imgu_pipe = &imgu->imgu_pipe[j];
 
-		if (i != IMGU_NODE_PARAMS && i != IMGU_NODE_STAT_3A)
-			fmts[imgu_node_map[i].css_queue] =
-				&imgu->nodes[i].vdev_fmt.fmt.pix_mp;
-		atomic_set(&imgu->nodes[i].sequence, 0);
-	}
+		for (i = 0; i < IMGU_NODE_NUM; i++) {
+			imgu_pipe->nodes[i].name = imgu_node_map[i].name;
+			imgu_pipe->nodes[i].output = i < IMGU_QUEUE_FIRST_INPUT;
+			imgu_pipe->nodes[i].enabled = false;
 
-	/* Master queue is always enabled */
-	imgu->nodes[IMGU_QUEUE_MASTER].immutable = true;
-	imgu->nodes[IMGU_QUEUE_MASTER].enabled = true;
+			if (i != IMGU_NODE_PARAMS && i != IMGU_NODE_STAT_3A)
+				fmts[imgu_node_map[i].css_queue] =
+					&imgu_pipe->nodes[i].vdev_fmt.fmt.pix_mp;
+			atomic_set(&imgu_pipe->nodes[i].sequence, 0);
+		}
+	}
 
 	r = ipu3_v4l2_register(imgu);
 	if (r)
 		return r;
 
 	/* Set initial formats and initialize formats of video nodes */
-	rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
-	rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
-	ipu3_css_fmt_set(&imgu->css, fmts, rects);
+	for (j = 0; j < IMGU_MAX_PIPE_NUM; j++) {
+		imgu_pipe = &imgu->imgu_pipe[j];
 
-	/* Pre-allocate dummy buffers */
-	r = imgu_dummybufs_preallocate(imgu);
-	if (r) {
-		dev_err(&imgu->pci_dev->dev,
-			"failed to pre-allocate dummy buffers (%d)", r);
-		imgu_dummybufs_cleanup(imgu);
-		ipu3_v4l2_unregister(imgu);
+		rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu_pipe->imgu_sd.rect.eff;
+		rects[IPU3_CSS_RECT_BDS] = &imgu_pipe->imgu_sd.rect.bds;
+		ipu3_css_fmt_set(&imgu->css, fmts, rects, j);
+
+		/* Pre-allocate dummy buffers */
+		r = imgu_dummybufs_preallocate(imgu, j);
+		if (r) {
+			dev_err(&imgu->pci_dev->dev,
+				"failed to pre-allocate dummy buffers (%d)", r);
+			goto out_cleanup;
+		}
 	}
 
 	return 0;
+
+out_cleanup:
+	for (j = 0; j < IMGU_MAX_PIPE_NUM; j++)
+		imgu_dummybufs_cleanup(imgu, j);
+
+	ipu3_v4l2_unregister(imgu);
+
+	return r;
 }
 
 static void imgu_video_nodes_exit(struct imgu_device *imgu)
 {
-	imgu_dummybufs_cleanup(imgu);
+	int i;
+
+	for (i = 0; i < IMGU_MAX_PIPE_NUM; i++)
+		imgu_dummybufs_cleanup(imgu, i);
+
 	ipu3_v4l2_unregister(imgu);
 }
 
@@ -500,13 +472,15 @@ static void imgu_video_nodes_exit(struct imgu_device *imgu)
 static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 {
 	struct imgu_device *imgu = imgu_ptr;
+	struct imgu_media_pipe *imgu_pipe;
+	int p;
 
 	/* Dequeue / queue buffers */
 	do {
 		u64 ns = ktime_get_ns();
 		struct ipu3_css_buffer *b;
 		struct imgu_buffer *buf;
-		unsigned int node;
+		unsigned int node, pipe;
 		bool dummy;
 
 		do {
@@ -525,25 +499,31 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 		}
 
 		node = imgu_map_node(imgu, b->queue);
-		dummy = imgu_dummybufs_check(imgu, b);
+		pipe = b->pipe;
+		dummy = imgu_dummybufs_check(imgu, b, pipe);
 		if (!dummy)
 			buf = container_of(b, struct imgu_buffer, css_buf);
 		dev_dbg(&imgu->pci_dev->dev,
-			"dequeue %s %s buffer %d from css\n",
+			"dequeue %s %s buffer %d daddr 0x%x from css\n",
 			dummy ? "dummy" : "user",
 			imgu_node_map[node].name,
-			dummy ? 0 : buf->vid_buf.vbb.vb2_buf.index);
+			dummy ? 0 : buf->vid_buf.vbb.vb2_buf.index,
+			(u32)b->daddr);
 
 		if (dummy)
 			/* It was a dummy buffer, skip it */
 			continue;
 
 		/* Fill vb2 buffer entries and tell it's ready */
-		if (!imgu->nodes[node].output) {
+		imgu_pipe = &imgu->imgu_pipe[pipe];
+		if (!imgu_pipe->nodes[node].output) {
 			buf->vid_buf.vbb.vb2_buf.timestamp = ns;
 			buf->vid_buf.vbb.field = V4L2_FIELD_NONE;
 			buf->vid_buf.vbb.sequence =
-				atomic_inc_return(&imgu->nodes[node].sequence);
+				atomic_inc_return(
+				&imgu_pipe->nodes[node].sequence);
+			dev_dbg(&imgu->pci_dev->dev, "vb2 buffer sequence %d",
+				buf->vid_buf.vbb.sequence);
 		}
 		imgu_buffer_done(imgu, &buf->vid_buf.vbb.vb2_buf,
 				 ipu3_css_buf_state(&buf->css_buf) ==
@@ -562,7 +542,8 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 	 * to be queued to CSS.
 	 */
 	if (!atomic_read(&imgu->qbuf_barrier))
-		imgu_queue_buffers(imgu, false);
+		for_each_set_bit(p, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM)
+			imgu_queue_buffers(imgu, false, p);
 
 	return IRQ_HANDLED;
 }
@@ -772,6 +753,7 @@ static int __maybe_unused imgu_resume(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
 	int r = 0;
+	unsigned int pipe;
 
 	dev_dbg(dev, "enter %s\n", __func__);
 
@@ -793,9 +775,13 @@ static int __maybe_unused imgu_resume(struct device *dev)
 		goto out;
 	}
 
-	r = imgu_queue_buffers(imgu, true);
-	if (r)
-		dev_err(dev, "failed to queue buffers (%d)", r);
+	for_each_set_bit(pipe, imgu->css.enabled_pipes, IMGU_MAX_PIPE_NUM) {
+		r = imgu_queue_buffers(imgu, true, pipe);
+		if (r)
+			dev_err(dev, "failed to queue buffers to pipe %d (%d)",
+				pipe, r);
+	}
+
 out:
 	dev_dbg(dev, "leave %s\n", __func__);
 
diff --git a/drivers/media/pci/intel/ipu3/ipu3.h b/drivers/media/pci/intel/ipu3/ipu3.h
index 5c2b420..8abae6d 100644
--- a/drivers/media/pci/intel/ipu3/ipu3.h
+++ b/drivers/media/pci/intel/ipu3/ipu3.h
@@ -7,6 +7,7 @@
 #include <linux/iova.h>
 #include <linux/pci.h>
 
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf2-dma-sg.h>
 
@@ -28,9 +29,8 @@
 #define IMGU_NODE_PARAMS		1 /* Input parameters */
 #define IMGU_NODE_OUT			2 /* Main output for still or video */
 #define IMGU_NODE_VF			3 /* Preview */
-#define IMGU_NODE_PV			4 /* Postview for still capture */
-#define IMGU_NODE_STAT_3A		5 /* 3A statistics */
-#define IMGU_NODE_NUM			6
+#define IMGU_NODE_STAT_3A		4 /* 3A statistics */
+#define IMGU_NODE_NUM			5
 
 #define file_to_intel_ipu3_node(__file) \
 	container_of(video_devdata(__file), struct imgu_video_device, vdev)
@@ -71,7 +71,6 @@ struct imgu_node_mapping {
 struct imgu_video_device {
 	const char *name;
 	bool output;		/* Frames to the driver? */
-	bool immutable;		/* Can not be enabled/disabled */
 	bool enabled;
 	int queued;		/* Buffers already queued */
 	struct v4l2_format vdev_fmt;	/* Currently set format */
@@ -85,14 +84,27 @@ struct imgu_video_device {
 	/* Protect vb2_queue and vdev structs*/
 	struct mutex lock;
 	atomic_t sequence;
+	unsigned int id;
+	unsigned int pipe;
 };
 
-/*
- * imgu_device -- ImgU (Imaging Unit) driver
- */
-struct imgu_device {
-	struct pci_dev *pci_dev;
-	void __iomem *base;
+struct imgu_v4l2_subdev {
+	unsigned int pipe;
+	struct v4l2_subdev subdev;
+	struct media_pad *subdev_pads;
+	struct {
+		struct v4l2_rect eff; /* effective resolution */
+		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
+		struct v4l2_rect gdc; /* gdc output resolution */
+	} rect;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *ctrl;
+	atomic_t running_mode;
+	bool active;
+};
+
+struct imgu_media_pipe {
+	unsigned int pipe;
 
 	/* Internally enabled queues */
 	struct {
@@ -101,18 +113,26 @@ struct imgu_device {
 	} queues[IPU3_CSS_QUEUES];
 	struct imgu_video_device nodes[IMGU_NODE_NUM];
 	bool queue_enabled[IMGU_NODE_NUM];
+	struct media_pipeline pipeline;
+	struct imgu_v4l2_subdev imgu_sd;
+};
+
+/*
+ * imgu_device -- ImgU (Imaging Unit) driver
+ */
+struct imgu_device {
+	struct pci_dev *pci_dev;
+	void __iomem *base;
 
 	/* Public fields, fill before registering */
 	unsigned int buf_struct_size;
 	bool streaming;		/* Public read only */
-	struct v4l2_ctrl_handler *ctrl_handler;
+
+	struct imgu_media_pipe imgu_pipe[IMGU_MAX_PIPE_NUM];
 
 	/* Private fields */
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
-	struct media_pipeline pipeline;
-	struct v4l2_subdev subdev;
-	struct media_pad *subdev_pads;
 	struct v4l2_file_operations v4l2_file_ops;
 
 	/* MMU driver for css */
@@ -129,11 +149,6 @@ struct imgu_device {
 	struct mutex lock;
 	/* Forbit streaming and buffer queuing during system suspend. */
 	atomic_t qbuf_barrier;
-	struct {
-		struct v4l2_rect eff; /* effective resolution */
-		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
-		struct v4l2_rect gdc; /* gdc output resolution */
-	} rect;
 	/* Indicate if system suspend take place while imgu is streaming. */
 	bool suspend_in_stream;
 	/* Used to wait for FW buffer queue drain. */
@@ -142,7 +157,8 @@ struct imgu_device {
 
 unsigned int imgu_node_to_queue(unsigned int node);
 unsigned int imgu_map_node(struct imgu_device *imgu, unsigned int css_queue);
-int imgu_queue_buffers(struct imgu_device *imgu, bool initial);
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial,
+		       unsigned int pipe);
 
 int ipu3_v4l2_register(struct imgu_device *dev);
 int ipu3_v4l2_unregister(struct imgu_device *dev);
diff --git a/include/uapi/linux/intel-ipu3.h b/include/uapi/linux/intel-ipu3.h
index c2608b6..7ad42b6 100644
--- a/include/uapi/linux/intel-ipu3.h
+++ b/include/uapi/linux/intel-ipu3.h
@@ -2816,4 +2816,12 @@ struct ipu3_uapi_params {
 	/* Optical black level compensation */
 	struct ipu3_uapi_obgrid_param obgrid_param;
 } __packed;
+
+/* custom ctrl to set pipe mode */
+#define V4L2_CID_INTEL_IPU3_BASE (V4L2_CID_USER_BASE + 0x10a0)
+#define V4L2_CID_INTEL_IPU3_MODE (V4L2_CID_INTEL_IPU3_BASE + 1)
+enum ipu3_running_mode {
+	IPU3_RUNNING_MODE_VIDEO = 0,
+	IPU3_RUNNING_MODE_STILL = 1,
+};
 #endif
-- 
2.7.4
