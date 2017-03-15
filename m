Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36815 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdCOGA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 02:00:28 -0400
Date: Wed, 15 Mar 2017 14:56:19 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] staging: atomisp: fix "alignment should match open
 parenthesis"
Message-ID: <20170315055619.GA8677@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix checkpatch.pl issues in atomisp_cmd.c
 : "CHECK: Alignment should match open parenthesis"

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 179 +++++++++++----------
 1 file changed, 90 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 82e7382..d97a8df 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -158,7 +158,7 @@ static unsigned short atomisp_get_sensor_fps(struct atomisp_sub_device *asd)
 	unsigned short fps;
 
 	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-		video, g_frame_interval, &frame_interval)) {
+	    video, g_frame_interval, &frame_interval)) {
 		fps = 0;
 	} else {
 		if (frame_interval.interval.numerator)
@@ -481,7 +481,7 @@ static void atomisp_3a_stats_ready_event(struct atomisp_sub_device *asd, uint8_t
 }
 
 static void atomisp_metadata_ready_event(struct atomisp_sub_device *asd,
-						enum atomisp_metadata_type md_type)
+					 enum atomisp_metadata_type md_type)
 {
 	struct v4l2_event event = {0};
 
@@ -622,14 +622,14 @@ irqreturn_t atomisp_isr(int irq, void *dev)
 		}
 		if (irq_infos & CSS_IRQ_INFO_EVENTS_READY)
 			atomic_set(&asd->sequence,
-					atomic_read(&asd->sequence_temp));
+				   atomic_read(&asd->sequence_temp));
 	}
 
 	if (irq_infos & CSS_IRQ_INFO_CSS_RECEIVER_SOF)
 		irq_infos &= ~CSS_IRQ_INFO_CSS_RECEIVER_SOF;
 
 	if ((irq_infos & CSS_IRQ_INFO_INPUT_SYSTEM_ERROR) ||
-		(irq_infos & CSS_IRQ_INFO_IF_ERROR)) {
+	    (irq_infos & CSS_IRQ_INFO_IF_ERROR)) {
 		/* handle mipi receiver error */
 		u32 rx_infos;
 		enum ia_css_csi2_port port;
@@ -684,7 +684,7 @@ void atomisp_clear_css_buffer_counters(struct atomisp_sub_device *asd)
 	memset(asd->s3a_bufs_in_css, 0, sizeof(asd->s3a_bufs_in_css));
 	for (i = 0; i < ATOMISP_INPUT_STREAM_NUM; i++)
 		memset(asd->metadata_bufs_in_css[i], 0,
-			sizeof(asd->metadata_bufs_in_css[i]));
+		       sizeof(asd->metadata_bufs_in_css[i]));
 	asd->dis_bufs_in_css = 0;
 	asd->video_out_capture.buffers_in_css = 0;
 	asd->video_out_vf.buffers_in_css = 0;
@@ -804,7 +804,7 @@ void atomisp_flush_params_queue(struct atomisp_video_pipe *pipe)
 
 	while (!list_empty(&pipe->per_frame_params)) {
 		param = list_entry(pipe->per_frame_params.next,
-				struct atomisp_css_params_with_list, list);
+				   struct atomisp_css_params_with_list, list);
 		list_del(&param->list);
 		atomisp_free_css_parameters(&param->params);
 		atomisp_kernel_free(param);
@@ -983,7 +983,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 	memset(&buffer, 0, sizeof(struct atomisp_css_buffer));
 	buffer.css_buffer.type = buf_type;
 	err = atomisp_css_dequeue_buffer(asd, stream_id, css_pipe_id,
-			buf_type, &buffer);
+					 buf_type, &buffer);
 	if (err) {
 		dev_err(isp->dev,
 			"atomisp_css_dequeue_buffer failed: 0x%x\n", err);
@@ -1000,12 +1000,12 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 	switch (buf_type) {
 	case CSS_BUFFER_TYPE_3A_STATISTICS:
 		list_for_each_entry_safe(s3a_buf, _s3a_buf_tmp,
-						&asd->s3a_stats_in_css, list) {
+					 &asd->s3a_stats_in_css, list) {
 			if (s3a_buf->s3a_data ==
 				buffer.css_buffer.data.stats_3a) {
 				list_del_init(&s3a_buf->list);
 				list_add_tail(&s3a_buf->list,
-						&asd->s3a_stats_ready);
+					      &asd->s3a_stats_ready);
 				break;
 			}
 		}
@@ -1021,12 +1021,12 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 
 		md_type = atomisp_get_metadata_type(asd, css_pipe_id);
 		list_for_each_entry_safe(md_buf, _md_buf_tmp,
-					&asd->metadata_in_css[md_type], list) {
+					 &asd->metadata_in_css[md_type], list) {
 			if (md_buf->metadata ==
 				buffer.css_buffer.data.metadata) {
 				list_del_init(&md_buf->list);
 				list_add_tail(&md_buf->list,
-					&asd->metadata_ready[md_type]);
+					      &asd->metadata_ready[md_type]);
 				break;
 			}
 		}
@@ -1041,12 +1041,12 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 			if (dis_buf->dis_data ==
 				buffer.css_buffer.data.stats_dvs) {
 				spin_lock_irqsave(&asd->dis_stats_lock,
-						irqflags);
+						  irqflags);
 				list_del_init(&dis_buf->list);
 				list_add(&dis_buf->list, &asd->dis_stats);
 				asd->params.dis_proj_data_valid = true;
 				spin_unlock_irqrestore(&asd->dis_stats_lock,
-						irqflags);
+						       irqflags);
 				break;
 			}
 		}
@@ -1073,7 +1073,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 		 * This is a WORKAROUND to set exp_id. see HSDES-1503911606.
 		 */
 		if (IS_BYT && buf_type == CSS_BUFFER_TYPE_SEC_VF_OUTPUT_FRAME &&
-			asd->continuous_mode->val && ATOMISP_USE_YUVPP(asd))
+		    asd->continuous_mode->val && ATOMISP_USE_YUVPP(asd))
 			frame->exp_id = (asd->postview_exp_id++) %
 						(ATOMISP_MAX_EXP_ID + 1);
 
@@ -1137,7 +1137,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 		 * This is a WORKAROUND to set exp_id. see HSDES-1503911606.
 		 */
 		if (IS_BYT && buf_type == CSS_BUFFER_TYPE_SEC_OUTPUT_FRAME &&
-			asd->continuous_mode->val && ATOMISP_USE_YUVPP(asd))
+		    asd->continuous_mode->val && ATOMISP_USE_YUVPP(asd))
 			frame->exp_id = (asd->preview_exp_id++) %
 						(ATOMISP_MAX_EXP_ID + 1);
 
@@ -1231,16 +1231,16 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 		 * be locked automatically, so record it here.
 		 */
 		if (((css_pipe_id == CSS_PIPE_ID_PREVIEW) ||
-			(css_pipe_id == CSS_PIPE_ID_VIDEO)) &&
-			asd->enable_raw_buffer_lock->val &&
-			asd->continuous_mode->val) {
+		    (css_pipe_id == CSS_PIPE_ID_VIDEO)) &&
+		    asd->enable_raw_buffer_lock->val &&
+		    asd->continuous_mode->val) {
 			atomisp_set_raw_buffer_bitmap(asd, frame->exp_id);
 			WARN_ON(frame->exp_id > ATOMISP_MAX_EXP_ID);
 		}
 
 		if (asd->params.css_update_params_needed) {
 			atomisp_apply_css_parameters(asd,
-				&asd->params.css_param);
+						     &asd->params.css_param);
 			if (asd->params.css_param.update_flag.dz_config)
 				atomisp_css_set_dz_config(asd,
 					&asd->params.css_param.dz_config);
@@ -1298,8 +1298,8 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 	 */
 	if (requeue) {
 		err = atomisp_css_queue_buffer(asd,
-					stream_id, css_pipe_id,
-					buf_type, &buffer);
+					       stream_id, css_pipe_id,
+					       buf_type, &buffer);
 		if (err)
 			dev_err(isp->dev, "%s, q to css fails: %d\n",
 					__func__, err);
@@ -1318,7 +1318,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 	else if (reset_wdt_timer)
 		/* SOF irq should not reset wdt timer. */
 		atomisp_wdt_refresh_pipe(pipe,
-				ATOMISP_WDT_KEEP_CURRENT_DELAY);
+					 ATOMISP_WDT_KEEP_CURRENT_DELAY);
 #endif
 }
 
@@ -1354,7 +1354,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 
 	if (!isp->sw_contex.file_input)
 		atomisp_css_irq_enable(isp,
-				CSS_IRQ_INFO_CSS_RECEIVER_SOF, false);
+				       CSS_IRQ_INFO_CSS_RECEIVER_SOF, false);
 
 	BUG_ON(isp->num_of_streams > MAX_STREAM_NUM);
 
@@ -1429,7 +1429,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 
 	/* Set the SRSE to 3 before resetting */
 	pci_write_config_dword(isp->pdev, PCI_I_CONTROL, isp->saved_regs.i_control |
-			MRFLD_PCI_I_CONTROL_SRSE_RESET_MASK);
+			       MRFLD_PCI_I_CONTROL_SRSE_RESET_MASK);
 
 	/* reset ISP and restore its state */
 	isp->isp_timeout = true;
@@ -1501,7 +1501,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 		atomisp_recover_params_queue(&asd->video_out_video_capture);
 
 		if ((asd->depth_mode->val) &&
-			(depth_cnt == ATOMISP_DEPTH_SENSOR_STREAMON_COUNT)) {
+		    (depth_cnt == ATOMISP_DEPTH_SENSOR_STREAMON_COUNT)) {
 			depth_mode = true;
 			continue;
 		}
@@ -1511,7 +1511,7 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 				s_stream, 1);
 		if (ret)
 			dev_warn(isp->dev,
-					"can't start streaming on sensor!\n");
+				 "can't start streaming on sensor!\n");
 
 	}
 
@@ -1556,10 +1556,10 @@ void atomisp_wdt_work(struct work_struct *work)
 			atomic_read(&asd->video_out_video_capture.wdt_count);
 		css_recover =
 			(pipe_wdt_cnt[i][0] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT &&
-			pipe_wdt_cnt[i][1] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT &&
-			pipe_wdt_cnt[i][2] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT &&
-			pipe_wdt_cnt[i][3] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT)
-			? true : false;
+			 pipe_wdt_cnt[i][1] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT &&
+			 pipe_wdt_cnt[i][2] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT &&
+			 pipe_wdt_cnt[i][3] <= ATOMISP_ISP_MAX_TIMEOUT_COUNT)
+			 ? true : false;
 		dev_err(isp->dev, "pipe on asd%d timeout cnt: (%d, %d, %d, %d) of %d, recover = %d\n",
 			asd->index, pipe_wdt_cnt[i][0], pipe_wdt_cnt[i][1],
 			pipe_wdt_cnt[i][2], pipe_wdt_cnt[i][3],
@@ -1569,7 +1569,7 @@ void atomisp_wdt_work(struct work_struct *work)
 
 #ifndef ISP2401
 	if (atomic_inc_return(&isp->wdt_count) <
-			ATOMISP_ISP_MAX_TIMEOUT_COUNT) {
+	    ATOMISP_ISP_MAX_TIMEOUT_COUNT) {
 #else
 	if (css_recover) {
 #endif
@@ -1719,9 +1719,9 @@ void atomisp_css_flush(struct atomisp_device *isp)
 			continue;
 
 		atomisp_wdt_refresh(asd,
-				isp->sw_contex.file_input ?
-				ATOMISP_ISP_FILE_TIMEOUT_DURATION :
-				ATOMISP_ISP_TIMEOUT_DURATION);
+				    isp->sw_contex.file_input ?
+				    ATOMISP_ISP_FILE_TIMEOUT_DURATION :
+				    ATOMISP_ISP_TIMEOUT_DURATION);
 	}
 	dev_dbg(isp->dev, "atomisp css flush done\n");
 }
@@ -2177,14 +2177,14 @@ int atomisp_set_sensor_runmode(struct atomisp_sub_device *asd,
 
 	mutex_lock(asd->ctrl_handler.lock);
 	c = v4l2_ctrl_find(isp->inputs[asd->input_curr].camera->ctrl_handler,
-			V4L2_CID_RUN_MODE);
+			   V4L2_CID_RUN_MODE);
 
 	if (c) {
 		ret = v4l2_ctrl_s_ctrl(c, runmode->mode);
 	} else {
 		p.parm.capture.capturemode = modes[runmode->mode];
 		ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-				video, s_parm, &p);
+				       video, s_parm, &p);
 	}
 
 	mutex_unlock(asd->ctrl_handler.lock);
@@ -2207,7 +2207,7 @@ int atomisp_gdc_cac(struct atomisp_sub_device *asd, int flag,
 	asd->params.gdc_cac_en = !!*value;
 	if (asd->params.gdc_cac_en) {
 		atomisp_css_set_morph_table(asd,
-				asd->params.css_param.morph_table);
+					    asd->params.css_param.morph_table);
 	} else {
 		atomisp_css_set_morph_table(asd, NULL);
 	}
@@ -2262,7 +2262,7 @@ int atomisp_nr(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set nr config to isp parameters */
 		memcpy(&asd->params.css_param.nr_config, arg,
-			sizeof(struct atomisp_css_nr_config));
+		       sizeof(struct atomisp_css_nr_config));
 		atomisp_css_set_nr_config(asd, &asd->params.css_param.nr_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -2304,7 +2304,7 @@ int atomisp_black_level(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set ob config to isp parameters */
 		memcpy(&asd->params.css_param.ob_config, config,
-			sizeof(struct atomisp_css_ob_config));
+		       sizeof(struct atomisp_css_ob_config));
 		atomisp_css_set_ob_config(asd, &asd->params.css_param.ob_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -2366,7 +2366,7 @@ int atomisp_ctc(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set ctc table to isp parameters */
 		memcpy(&asd->params.css_param.ctc_table, config,
-			sizeof(asd->params.css_param.ctc_table));
+		       sizeof(asd->params.css_param.ctc_table));
 		atomisp_css_set_ctc_table(asd, &asd->params.css_param.ctc_table);
 	}
 
@@ -2386,7 +2386,7 @@ int atomisp_gamma_correction(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set gamma correction params to isp parameters */
 		memcpy(&asd->params.css_param.gc_config, config,
-			sizeof(asd->params.css_param.gc_config));
+		       sizeof(asd->params.css_param.gc_config));
 		atomisp_css_set_gc_config(asd, &asd->params.css_param.gc_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -2398,7 +2398,7 @@ int atomisp_gamma_correction(struct atomisp_sub_device *asd, int flag,
  * Function to update narrow gamma flag
  */
 int atomisp_formats(struct atomisp_sub_device *asd, int flag,
-		struct atomisp_formats_config *config)
+		    struct atomisp_formats_config *config)
 {
 	if (flag == 0) {
 		/* Get narrow gamma flag from current setup */
@@ -2407,7 +2407,7 @@ int atomisp_formats(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set narrow gamma flag to isp parameters */
 		memcpy(&asd->params.css_param.formats_config, config,
-			sizeof(asd->params.css_param.formats_config));
+		       sizeof(asd->params.css_param.formats_config));
 		atomisp_css_set_formats_config(asd, &asd->params.css_param.formats_config);
 	}
 
@@ -2425,7 +2425,8 @@ void atomisp_free_internal_buffers(struct atomisp_sub_device *asd)
 }
 
 static void atomisp_update_grid_info(struct atomisp_sub_device *asd,
-				enum atomisp_css_pipe_id pipe_id, int source_pad)
+				     enum atomisp_css_pipe_id pipe_id,
+				     int source_pad)
 {
 	struct atomisp_device *isp = asd->isp;
 	int err;
@@ -2473,10 +2474,10 @@ static void atomisp_update_grid_info(struct atomisp_sub_device *asd,
 }
 
 static void atomisp_curr_user_grid_info(struct atomisp_sub_device *asd,
-				    struct atomisp_grid_info *info)
+					struct atomisp_grid_info *info)
 {
 	memcpy(info, &asd->params.curr_grid_info.s3a_grid,
-			sizeof(struct atomisp_css_3a_grid_info));
+	       sizeof(struct atomisp_css_3a_grid_info));
 }
 
 int atomisp_compare_grid(struct atomisp_sub_device *asd,
@@ -2536,7 +2537,7 @@ int atomisp_gdc_cac_table(struct atomisp_sub_device *asd, int flag,
 
 		/* allocate new one */
 		tab = atomisp_css_morph_table_allocate(config->width,
-						  config->height);
+						       config->height);
 
 		if (!tab) {
 			dev_err(isp->dev, "out of memory\n");
@@ -2938,20 +2939,20 @@ int atomisp_get_metadata(struct atomisp_sub_device *asd, int flag,
 	}
 
 	md_buf = list_entry(asd->metadata_ready[md_type].next,
-			struct atomisp_metadata_buf, list);
+			    struct atomisp_metadata_buf, list);
 	md->exp_id = md_buf->metadata->exp_id;
 	if (md_buf->md_vptr) {
 		ret = copy_to_user(md->data,
-				md_buf->md_vptr,
-				stream_info->metadata_info.size);
+				   md_buf->md_vptr,
+				   stream_info->metadata_info.size);
 	} else {
 		hrt_isp_css_mm_load(md_buf->metadata->address,
-				asd->params.metadata_user[md_type],
-				stream_info->metadata_info.size);
+				    asd->params.metadata_user[md_type],
+				    stream_info->metadata_info.size);
 
 		ret = copy_to_user(md->data,
-				asd->params.metadata_user[md_type],
-				stream_info->metadata_info.size);
+				   asd->params.metadata_user[md_type],
+				   stream_info->metadata_info.size);
 	}
 	if (ret) {
 		dev_err(isp->dev, "copy to user failed: copied %d bytes\n",
@@ -3021,20 +3022,20 @@ int atomisp_get_metadata_by_type(struct atomisp_sub_device *asd, int flag,
 	}
 
 	md_buf = list_entry(asd->metadata_ready[md_type].next,
-			struct atomisp_metadata_buf, list);
+			    struct atomisp_metadata_buf, list);
 	md->exp_id = md_buf->metadata->exp_id;
 	if (md_buf->md_vptr) {
 		ret = copy_to_user(md->data,
-				md_buf->md_vptr,
-				stream_info->metadata_info.size);
+				   md_buf->md_vptr,
+				   stream_info->metadata_info.size);
 	} else {
 		hrt_isp_css_mm_load(md_buf->metadata->address,
-				asd->params.metadata_user[md_type],
-				stream_info->metadata_info.size);
+				    asd->params.metadata_user[md_type],
+				    stream_info->metadata_info.size);
 
 		ret = copy_to_user(md->data,
-				asd->params.metadata_user[md_type],
-				stream_info->metadata_info.size);
+				   asd->params.metadata_user[md_type],
+				   stream_info->metadata_info.size);
 	}
 	if (ret) {
 		dev_err(isp->dev, "copy to user failed: copied %d bytes\n",
@@ -3053,8 +3054,8 @@ int atomisp_get_metadata_by_type(struct atomisp_sub_device *asd, int flag,
  * Function to calculate real zoom region for every pipe
  */
 int atomisp_calculate_real_zoom_region(struct atomisp_sub_device *asd,
-				struct ia_css_dz_config   *dz_config,
-				enum atomisp_css_pipe_id css_pipe_id)
+				       struct ia_css_dz_config   *dz_config,
+				       enum atomisp_css_pipe_id css_pipe_id)
 
 {
 	struct atomisp_stream_env *stream_env =
@@ -3254,11 +3255,11 @@ static bool atomisp_check_zoom_region(
 	else
 		/* setting error zoom region */
 		dev_err(asd->isp->dev, "%s zoom region ERROR:dz_config:(%d,%d),(%d,%d)array_res(%d, %d)\n",
-				__func__, dz_config->zoom_region.origin.x,
-				dz_config->zoom_region.origin.y,
-				dz_config->zoom_region.resolution.width,
-				dz_config->zoom_region.resolution.height,
-				config.width, config.height);
+			__func__, dz_config->zoom_region.origin.x,
+			dz_config->zoom_region.origin.y,
+			dz_config->zoom_region.resolution.width,
+			dz_config->zoom_region.resolution.height,
+			config.width, config.height);
 
 	return flag;
 }
@@ -3374,7 +3375,7 @@ void atomisp_apply_css_parameters(
 }
 
 static unsigned int long copy_from_compatible(void *to, const void *from,
-					unsigned long n, bool from_user)
+					      unsigned long n, bool from_user)
 {
 	if (from_user)
 		return copy_from_user(to, from, n);
@@ -3677,9 +3678,9 @@ int atomisp_cp_general_isp_parameters(struct atomisp_sub_device *asd,
 }
 
 int atomisp_cp_lsc_table(struct atomisp_sub_device *asd,
-			struct atomisp_shading_table *source_st,
-			struct atomisp_css_params *css_param,
-			bool from_user)
+			 struct atomisp_shading_table *source_st,
+			 struct atomisp_css_params *css_param,
+			 bool from_user)
 {
 	unsigned int i;
 	unsigned int len_table;
@@ -3809,7 +3810,7 @@ int atomisp_cp_lsc_table(struct atomisp_sub_device *asd,
 
 		for (i = 0; i < ATOMISP_NUM_SC_COLORS; i++) {
 			if (memcmp(shading_table->data[i], old_table->data[i],
-				len_table) != 0) {
+				   len_table) != 0) {
 				data_is_same = false;
 				break;
 			}
@@ -4832,7 +4833,7 @@ int atomisp_false_color_param(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set false color to isp parameters */
 		memcpy(&asd->params.css_param.de_config, config,
-				sizeof(asd->params.css_param.de_config));
+		       sizeof(asd->params.css_param.de_config));
 		atomisp_css_set_de_config(asd, &asd->params.css_param.de_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -4853,7 +4854,7 @@ int atomisp_white_balance_param(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set white balance to isp parameters */
 		memcpy(&asd->params.css_param.wb_config, config,
-				sizeof(asd->params.css_param.wb_config));
+		       sizeof(asd->params.css_param.wb_config));
 		atomisp_css_set_wb_config(asd, &asd->params.css_param.wb_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -4875,7 +4876,7 @@ int atomisp_3a_config_param(struct atomisp_sub_device *asd, int flag,
 	} else {
 		/* Set white balance to isp parameters */
 		memcpy(&asd->params.css_param.s3a_config, config,
-				sizeof(asd->params.css_param.s3a_config));
+		       sizeof(asd->params.css_param.s3a_config));
 		atomisp_css_set_3a_config(asd, &asd->params.css_param.s3a_config);
 		asd->params.css_update_params_needed = true;
 	}
@@ -5099,7 +5100,7 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_format *f,
 				   rounddown(width, (u32)ATOM_ISP_STEP_WIDTH),
 				   ATOM_ISP_MIN_WIDTH, ATOM_ISP_MAX_WIDTH);
 	f->fmt.pix.height = clamp_t(u32, rounddown(height,
-						   (u32)ATOM_ISP_STEP_HEIGHT),
+				    (u32)ATOM_ISP_STEP_HEIGHT),
 				    ATOM_ISP_MIN_HEIGHT, ATOM_ISP_MAX_HEIGHT);
 	f->fmt.pix.bytesperline = (width * depth) >> 3;
 
@@ -5174,8 +5175,8 @@ static inline int atomisp_set_sensor_mipi_to_isp(
 	} else {
 		struct v4l2_mbus_framefmt *sink;
 		sink = atomisp_subdev_get_ffmt(&asd->subdev, NULL,
-				V4L2_SUBDEV_FORMAT_ACTIVE,
-				ATOMISP_SUBDEV_PAD_SINK);
+					       V4L2_SUBDEV_FORMAT_ACTIVE,
+					       ATOMISP_SUBDEV_PAD_SINK);
 		fc = atomisp_find_in_fmt_conv(sink->code);
 		if (!fc)
 			return -EINVAL;
@@ -5247,15 +5248,15 @@ int configure_pp_input_nop(struct atomisp_sub_device *asd,
 }
 
 int configure_output_nop(struct atomisp_sub_device *asd,
-				unsigned int width, unsigned int height,
-				unsigned int min_width,
-				enum atomisp_css_frame_format sh_fmt)
+			 unsigned int width, unsigned int height,
+			 unsigned int min_width,
+			 enum atomisp_css_frame_format sh_fmt)
 {
 	return 0;
 }
 
 int get_frame_info_nop(struct atomisp_sub_device *asd,
-				struct atomisp_css_frame_info *finfo)
+		       struct atomisp_css_frame_info *finfo)
 {
 	return 0;
 }
@@ -5299,7 +5300,7 @@ static int css_input_resolution_changed(struct atomisp_sub_device *asd,
 	 */
 	for (i = 0; i < ATOMISP_METADATA_TYPE_NUM; i++) {
 		list_for_each_entry_safe(md_buf, _md_buf, &asd->metadata[i],
-					list) {
+					 list) {
 			atomisp_css_free_metadata_buffer(md_buf);
 			list_del(&md_buf->list);
 			kfree(md_buf);
@@ -5332,7 +5333,7 @@ static int atomisp_set_fmt_to_isp(struct video_device *vdev,
 				enum atomisp_css_frame_format sh_fmt) =
 							configure_output_nop;
 	int (*get_frame_info)(struct atomisp_sub_device *asd,
-				struct atomisp_css_frame_info *finfo) =
+			      struct atomisp_css_frame_info *finfo) =
 							get_frame_info_nop;
 	int (*configure_pp_input)(struct atomisp_sub_device *asd,
 				  unsigned int width, unsigned int height) =
@@ -5696,7 +5697,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 		if (ret)
 			return ret;
 		if (ffmt->width < req_ffmt->width ||
-				ffmt->height < req_ffmt->height) {
+		    ffmt->height < req_ffmt->height) {
 			req_ffmt->height -= dvs_env_h;
 			req_ffmt->width -= dvs_env_w;
 			ffmt = req_ffmt;
@@ -5990,7 +5991,7 @@ int atomisp_set_fmt(struct video_device *vdev, struct v4l2_format *f)
 	 */
 	if (!asd->continuous_mode->val ||
 	    isp_sink_fmt.width < (f->fmt.pix.width + padding_w + dvs_env_w) ||
-	     isp_sink_fmt.height < (f->fmt.pix.height + padding_h +
+	    isp_sink_fmt.height < (f->fmt.pix.height + padding_h +
 				    dvs_env_h)) {
 		/*
 		 * For jpeg or custom raw format the sensor will return constant
@@ -6030,7 +6031,7 @@ int atomisp_set_fmt(struct video_device *vdev, struct v4l2_format *f)
 	if (isp_sink_crop.width * 9 / 10 < f->fmt.pix.width ||
 	    isp_sink_crop.height * 9 / 10 < f->fmt.pix.height ||
 	    (atomisp_subdev_format_conversion(asd, source_pad) &&
-	     ((asd->run_mode->val == ATOMISP_RUN_MODE_VIDEO &&
+	    ((asd->run_mode->val == ATOMISP_RUN_MODE_VIDEO &&
 	       !asd->continuous_mode->val) ||
 	      asd->vfpp->val == ATOMISP_VFPP_DISABLE_SCALER))) {
 		/* for continuous mode, preview size might be smaller than
@@ -6435,7 +6436,7 @@ int atomisp_s_ae_window(struct atomisp_sub_device *asd,
 	sel.r.height = arg->y_bottom - arg->y_top + 1;
 
 	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-				 pad, set_selection, NULL, &sel)) {
+			     pad, set_selection, NULL, &sel)) {
 		dev_err(isp->dev, "failed to call sensor set_selection.\n");
 		return -EINVAL;
 	}
-- 
1.9.1
