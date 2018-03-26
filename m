Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58607 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752096AbeCZVLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Aishwarya Pant <aishpant@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Paolo Cretaro <melko@frugalware.org>,
        Jeremy Sowden <jeremy@azazel.net>, devel@driverdev.osuosl.org
Subject: [PATCH 02/18] media: staging: atomisp: do some coding style improvements
Date: Mon, 26 Mar 2018 17:10:35 -0400
Message-Id: <f281409a68bb8dc49b9f7342cc881ffefd91efda.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use make coccicheck in patch mode to do some coding style
improvements. Adjust the results manually.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 14 +++++-----
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      | 14 +++++-----
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  2 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |  2 +-
 .../atomisp2/css2400/runtime/isys/src/isys_init.c  |  4 +--
 .../css2400/runtime/isys/src/virtual_isys.c        | 12 ++++-----
 .../css2400/runtime/pipeline/src/pipeline.c        |  2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 30 ++++++++++------------
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |  3 +--
 9 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 22f2dbcecc15..2f6c88a0f4ee 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -515,7 +515,7 @@ irqreturn_t atomisp_isr(int irq, void *dev)
 
 	spin_lock_irqsave(&isp->lock, flags);
 	if (isp->sw_contex.power_state != ATOM_ISP_POWER_UP ||
-	    isp->css_initialized == false) {
+	    !isp->css_initialized) {
 		spin_unlock_irqrestore(&isp->lock, flags);
 		return IRQ_HANDLED;
 	}
@@ -4603,7 +4603,7 @@ int atomisp_fixed_pattern(struct atomisp_sub_device *asd, int flag,
 	}
 
 	if (*value == 0) {
-		asd->params.fpn_en = 0;
+		asd->params.fpn_en = false;
 		return 0;
 	}
 
@@ -5524,7 +5524,7 @@ static void atomisp_get_dis_envelop(struct atomisp_sub_device *asd,
 
 	/* if subdev type is SOC camera,we do not need to set DVS */
 	if (isp->inputs[asd->input_curr].type == SOC_CAMERA)
-		asd->params.video_dis_en = 0;
+		asd->params.video_dis_en = false;
 
 	if (asd->params.video_dis_en &&
 	    asd->run_mode->val == ATOMISP_RUN_MODE_VIDEO) {
@@ -5624,7 +5624,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 			ffmt = req_ffmt;
 			dev_warn(isp->dev,
 			  "can not enable video dis due to sensor limitation.");
-			asd->params.video_dis_en = 0;
+			asd->params.video_dis_en = false;
 		}
 	}
 	dev_dbg(isp->dev, "sensor width: %d, height: %d\n",
@@ -5649,7 +5649,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 	    (ffmt->width < req_ffmt->width || ffmt->height < req_ffmt->height)) {
 		dev_warn(isp->dev,
 			 "can not enable video dis due to sensor limitation.");
-		asd->params.video_dis_en = 0;
+		asd->params.video_dis_en = false;
 	}
 
 	atomisp_subdev_set_ffmt(&asd->subdev, fh.pad,
@@ -6152,7 +6152,7 @@ int atomisp_set_shading_table(struct atomisp_sub_device *asd,
 
 	if (!user_shading_table->enable) {
 		atomisp_css_set_shading_table(asd, NULL);
-		asd->params.sc_en = 0;
+		asd->params.sc_en = false;
 		return 0;
 	}
 
@@ -6190,7 +6190,7 @@ int atomisp_set_shading_table(struct atomisp_sub_device *asd,
 	free_table = asd->params.css_param.shading_table;
 	asd->params.css_param.shading_table = shading_table;
 	atomisp_css_set_shading_table(asd, shading_table);
-	asd->params.sc_en = 1;
+	asd->params.sc_en = true;
 
 out:
 	if (free_table != NULL)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 545ef024841d..709137f25700 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -689,7 +689,7 @@ static void atomisp_dev_init_struct(struct atomisp_device *isp)
 {
 	unsigned int i;
 
-	isp->sw_contex.file_input = 0;
+	isp->sw_contex.file_input = false;
 	isp->need_gfx_throttle = true;
 	isp->isp_fatal_error = false;
 	isp->mipi_frame_size = 0;
@@ -708,12 +708,12 @@ static void atomisp_subdev_init_struct(struct atomisp_sub_device *asd)
 	v4l2_ctrl_s_ctrl(asd->run_mode, ATOMISP_RUN_MODE_STILL_CAPTURE);
 	memset(&asd->params.css_param, 0, sizeof(asd->params.css_param));
 	asd->params.color_effect = V4L2_COLORFX_NONE;
-	asd->params.bad_pixel_en = 1;
-	asd->params.gdc_cac_en = 0;
-	asd->params.video_dis_en = 0;
-	asd->params.sc_en = 0;
-	asd->params.fpn_en = 0;
-	asd->params.xnr_en = 0;
+	asd->params.bad_pixel_en = true;
+	asd->params.gdc_cac_en = false;
+	asd->params.video_dis_en = false;
+	asd->params.sc_en = false;
+	asd->params.fpn_en = false;
+	asd->params.xnr_en = false;
 	asd->params.false_color = 0;
 	asd->params.online_process = 1;
 	asd->params.yuv_ds_en = 0;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 5c84dd63778e..4222724347cc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -2731,7 +2731,7 @@ static int atomisp_s_parm_file(struct file *file, void *fh,
 	}
 
 	rt_mutex_lock(&isp->mutex);
-	isp->sw_contex.file_input = 1;
+	isp->sw_contex.file_input = true;
 	rt_mutex_unlock(&isp->mutex);
 
 	return 0;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index e50d9f2e2609..01d20b62a630 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -207,7 +207,7 @@ static void map_buffer_type_to_queue_id(
 	}
 
 	for (i = SH_CSS_QUEUE_C_ID; i < SH_CSS_MAX_NUM_QUEUES; i++) {
-		if (queue_availability[thread_id][i] == true) {
+		if (queue_availability[thread_id][i]) {
 			queue_availability[thread_id][i] = false;
 			buffer_type_to_queue_id_map[thread_id][buf_type] = i;
 			break;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_init.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_init.c
index 4122084fd237..2ae5e59d5e31 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_init.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_init.c
@@ -105,8 +105,6 @@ input_system_error_t ia_css_isys_init(void)
 #elif defined(USE_INPUT_SYSTEM_VERSION_2401)
 input_system_error_t ia_css_isys_init(void)
 {
-	input_system_error_t error = INPUT_SYSTEM_ERR_NO_ERROR;
-
 	ia_css_isys_csi_rx_lut_rmgr_init();
 	ia_css_isys_ibuf_rmgr_init();
 	ia_css_isys_dma_channel_rmgr_init();
@@ -120,7 +118,7 @@ input_system_error_t ia_css_isys_init(void)
 	isys_irqc_status_enable(ISYS_IRQ1_ID);
 	isys_irqc_status_enable(ISYS_IRQ2_ID);
 
-	return error;
+	return INPUT_SYSTEM_ERR_NO_ERROR;
 }
 #endif
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/virtual_isys.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/virtual_isys.c
index 90922a7acefd..2484949453b7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/virtual_isys.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/virtual_isys.c
@@ -331,7 +331,7 @@ static bool create_input_system_channel(
 		break;
 	}
 
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	if (!acquire_sid(me->stream2mmio_id, &(me->stream2mmio_sid_id))) {
@@ -474,7 +474,7 @@ static bool calculate_input_system_channel_cfg(
 
 	rc = calculate_stream2mmio_cfg(isys_cfg, metadata,
 			&(channel_cfg->stream2mmio_cfg));
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	rc = calculate_ibuf_ctrl_cfg(
@@ -482,7 +482,7 @@ static bool calculate_input_system_channel_cfg(
 			input_port,
 			isys_cfg,
 			&(channel_cfg->ibuf_ctrl_cfg));
-	if (rc == false)
+	if (!rc)
 		return false;
 	if (metadata)
 		channel_cfg->ibuf_ctrl_cfg.stores_per_frame = isys_cfg->metadata.lines_per_frame;
@@ -491,7 +491,7 @@ static bool calculate_input_system_channel_cfg(
 			channel,
 			isys_cfg,
 			&(channel_cfg->dma_cfg));
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	rc = calculate_isys2401_dma_port_cfg(
@@ -499,7 +499,7 @@ static bool calculate_input_system_channel_cfg(
 			false,
 			metadata,
 			&(channel_cfg->dma_src_port_cfg));
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	rc = calculate_isys2401_dma_port_cfg(
@@ -507,7 +507,7 @@ static bool calculate_input_system_channel_cfg(
 			isys_cfg->raw_packed,
 			metadata,
 			&(channel_cfg->dma_dest_port_cfg));
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	return true;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
index 81a50c73ad0b..269829770082 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
@@ -574,7 +574,7 @@ static void pipeline_map_num_to_sp_thread(unsigned int pipe_num)
 
 		But the below is more descriptive.
 	*/
-	assert(found_sp_thread != false);
+	assert(found_sp_thread);
 }
 
 static void pipeline_unmap_num_to_sp_thread(unsigned int pipe_num)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 37116faab631..034437f8ca07 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1082,7 +1082,7 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 
 	/* get the SP thread id */
 	rc = ia_css_pipeline_get_sp_thread_id(ia_css_pipe_get_pipe_num(pipe), &sp_thread_id);
-	if (rc != true)
+	if (!rc)
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	/* get the target input terminal */
 	sp_pipeline_input_terminal = &(sh_css_sp_group.pipe_io[sp_thread_id].input);
@@ -1108,7 +1108,7 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 					&(isys_stream_descr));
 		}
 
-		if (rc != true)
+		if (!rc)
 			return IA_CSS_ERR_INTERNAL_ERROR;
 
 		isys_stream_id = ia_css_isys_generate_stream_id(sp_thread_id, i);
@@ -1118,7 +1118,7 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 				&(isys_stream_descr),
 				&(sp_pipeline_input_terminal->context.virtual_input_system_stream[i]),
 				isys_stream_id);
-		if (rc != true)
+		if (!rc)
 			return IA_CSS_ERR_INTERNAL_ERROR;
 
 		/* calculate the configuration of the virtual Input System (2401) */
@@ -1126,7 +1126,7 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 				&(sp_pipeline_input_terminal->context.virtual_input_system_stream[i]),
 				&(isys_stream_descr),
 				&(sp_pipeline_input_terminal->ctrl.virtual_input_system_stream_cfg[i]));
-		if (rc != true) {
+		if (!rc) {
 			ia_css_isys_stream_destroy(&(sp_pipeline_input_terminal->context.virtual_input_system_stream[i]));
 			return IA_CSS_ERR_INTERNAL_ERROR;
 		}
@@ -2562,7 +2562,7 @@ ia_css_uninit(void)
 	ifmtr_set_if_blocking_mode_reset = true;
 #endif
 
-	if (fw_explicitly_loaded == false) {
+	if (!fw_explicitly_loaded) {
 		ia_css_unload_firmware();
 	}
 	ia_css_spctrl_unload_fw(SP0_ID);
@@ -7739,7 +7739,7 @@ create_host_yuvpp_pipeline(struct ia_css_pipe *pipe)
 
 		for (i = 0, j = 0; i < num_stage; i++) {
 			assert(j < num_output_stage);
-			if (pipe->pipe_settings.yuvpp.is_output_stage[i] == true) {
+			if (pipe->pipe_settings.yuvpp.is_output_stage[i]) {
 				tmp_out_frame = out_frame[j];
 				tmp_vf_frame = vf_frame[j];
 			} else {
@@ -7758,7 +7758,7 @@ create_host_yuvpp_pipeline(struct ia_css_pipe *pipe)
 			}
 			/* we use output port 1 as internal output port */
 			tmp_in_frame = yuv_scaler_stage->args.out_frame[1];
-			if (pipe->pipe_settings.yuvpp.is_output_stage[i] == true) {
+			if (pipe->pipe_settings.yuvpp.is_output_stage[i]) {
 				if (tmp_vf_frame && (tmp_vf_frame->info.res.width != 0)) {
 					in_frame = yuv_scaler_stage->args.out_vf_frame;
 					err = add_vf_pp_stage(pipe, in_frame, tmp_vf_frame, &vf_pp_binary[j],
@@ -8321,8 +8321,6 @@ sh_css_pipe_get_output_frame_info(struct ia_css_pipe *pipe,
 				  struct ia_css_frame_info *info,
 				  unsigned int idx)
 {
-	enum ia_css_err err = IA_CSS_SUCCESS;
-
 	assert(pipe != NULL);
 	assert(info != NULL);
 
@@ -8347,7 +8345,7 @@ sh_css_pipe_get_output_frame_info(struct ia_css_pipe *pipe,
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
 						"sh_css_pipe_get_output_frame_info() leave:\n");
-	return err;
+	return IA_CSS_SUCCESS;
 }
 
 #if !defined(HAS_NO_INPUT_SYSTEM)
@@ -10218,8 +10216,6 @@ ia_css_stream_get_3a_binary(const struct ia_css_stream *stream)
 enum ia_css_err
 ia_css_stream_set_output_padded_width(struct ia_css_stream *stream, unsigned int output_padded_width)
 {
-	enum ia_css_err err = IA_CSS_SUCCESS;
-
 	struct ia_css_pipe *pipe;
 
 	assert(stream != NULL);
@@ -10232,7 +10228,7 @@ ia_css_stream_set_output_padded_width(struct ia_css_stream *stream, unsigned int
 	pipe->config.output_info[IA_CSS_PIPE_OUTPUT_STAGE_0].padded_width = output_padded_width;
 	pipe->output_info[IA_CSS_PIPE_OUTPUT_STAGE_0].padded_width = output_padded_width;
 
-	return err;
+	return IA_CSS_SUCCESS;
 }
 
 static struct ia_css_binary *
@@ -10734,7 +10730,7 @@ ia_css_pipe_set_qos_ext_state(struct ia_css_pipe *pipe, uint32_t fw_handle, bool
 				(uint8_t) IA_CSS_PSYS_SW_EVENT_STAGE_ENABLE_DISABLE,
 				(uint8_t) thread_id,
 				(uint8_t) stage->stage_num,
-				(enable == true) ? 1 : 0);
+				enable ? 1 : 0);
 			if (err == IA_CSS_SUCCESS) {
 				if(enable)
 					SH_CSS_QOS_STAGE_ENABLE(&(sh_css_sp_group.pipe[thread_id]),stage->stage_num);
@@ -11059,7 +11055,7 @@ static struct sh_css_hmm_buffer_record
 
 	buffer_record = &hmm_buffer_record[0];
 	for (i = 0; i < MAX_HMM_BUFFER_NUM; i++) {
-		if (buffer_record->in_use == false) {
+		if (!buffer_record->in_use) {
 			buffer_record->in_use = true;
 			buffer_record->type = type;
 			buffer_record->h_vbuf = h_vbuf;
@@ -11083,7 +11079,7 @@ static struct sh_css_hmm_buffer_record
 
 	buffer_record = &hmm_buffer_record[0];
 	for (i = 0; i < MAX_HMM_BUFFER_NUM; i++) {
-		if ((buffer_record->in_use == true) &&
+		if ((buffer_record->in_use) &&
 		    (buffer_record->type == type) &&
 		    (buffer_record->h_vbuf != NULL) &&
 		    (buffer_record->h_vbuf->vptr == ddr_buffer_addr)) {
@@ -11093,7 +11089,7 @@ static struct sh_css_hmm_buffer_record
 		buffer_record++;
 	}
 
-	if (found_record == true)
+	if (found_record)
 		return buffer_record;
 	else
 		return NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index 6fc00fc402b1..9c6330783358 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -817,7 +817,6 @@ configure_isp_from_args(
 	bool two_ppc,
 	bool deinterleaved)
 {
-	enum ia_css_err err = IA_CSS_SUCCESS;
 #ifdef ISP2401
 	struct ia_css_pipe *pipe = find_pipe_by_num(pipeline->pipe_num);
 	const struct ia_css_resolution *res;
@@ -841,7 +840,7 @@ configure_isp_from_args(
 	ia_css_ref_configure(binary, (const struct ia_css_frame **)args->delay_frames, pipeline->dvs_frame_delay);
 	ia_css_tnr_configure(binary, (const struct ia_css_frame **)args->tnr_frames);
 	ia_css_bayer_io_config(binary, args);
-	return err;
+	return IA_CSS_SUCCESS;
 }
 
 static void
-- 
2.14.3
