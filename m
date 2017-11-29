Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43446 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752715AbdK2NZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 08:25:50 -0500
Received: by mail-wm0-f68.google.com with SMTP id i71so6246111wmf.2
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 05:25:49 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 1/2] venus: cleanup set_property controls
Date: Wed, 29 Nov 2017 15:25:21 +0200
Message-Id: <20171129132522.9140-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move ptype (property type) initialization out of switch case
and save few lines of code.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 73 +---------------------------
 1 file changed, 2 insertions(+), 71 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index b83c5b8ddccb..1cfeb7743041 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -421,12 +421,12 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
 	pkt->shdr.session_id = hash32_ptr(cookie);
 	pkt->num_properties = 1;
+	pkt->data[0] = ptype;
 
 	switch (ptype) {
 	case HFI_PROPERTY_CONFIG_FRAME_RATE: {
 		struct hfi_framerate *in = pdata, *frate = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_FRAME_RATE;
 		frate->buffer_type = in->buffer_type;
 		frate->framerate = in->framerate;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*frate);
@@ -436,7 +436,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_uncompressed_format_select *in = pdata;
 		struct hfi_uncompressed_format_select *hfi = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
 		hfi->buffer_type = in->buffer_type;
 		hfi->format = in->format;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hfi);
@@ -445,7 +444,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_FRAME_SIZE: {
 		struct hfi_framesize *in = pdata, *fsize = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_FRAME_SIZE;
 		fsize->buffer_type = in->buffer_type;
 		fsize->height = in->height;
 		fsize->width = in->width;
@@ -455,7 +453,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_REALTIME: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_REALTIME;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -463,7 +460,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL: {
 		struct hfi_buffer_count_actual *in = pdata, *count = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
 		count->count_actual = in->count_actual;
 		count->type = in->type;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
@@ -472,7 +468,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL: {
 		struct hfi_buffer_size_actual *in = pdata, *sz = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;
 		sz->size = in->size;
 		sz->type = in->type;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*sz);
@@ -482,8 +477,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_buffer_display_hold_count_actual *in = pdata;
 		struct hfi_buffer_display_hold_count_actual *count = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL;
 		count->hold_count = in->hold_count;
 		count->type = in->type;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
@@ -493,7 +486,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_nal_stream_format_select *in = pdata;
 		struct hfi_nal_stream_format_select *fmt = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT;
 		fmt->format = in->format;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*fmt);
 		break;
@@ -510,7 +502,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_OUTPUT_ORDER;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -518,7 +509,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE: {
 		struct hfi_enable_picture *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE;
 		en->picture_type = in->picture_type;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -526,8 +516,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -536,7 +524,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_enable *in = pdata;
 		struct hfi_enable *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -544,7 +531,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM: {
 		struct hfi_multi_stream *in = pdata, *multi = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM;
 		multi->buffer_type = in->buffer_type;
 		multi->enable = in->enable;
 		multi->width = in->width;
@@ -556,8 +542,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_display_picture_buffer_count *in = pdata;
 		struct hfi_display_picture_buffer_count *count = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT;
 		count->count = in->count;
 		count->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
@@ -576,7 +560,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_DIVX_FORMAT;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -584,7 +567,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -592,7 +574,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -600,7 +581,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -608,14 +588,11 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
 	}
 	case HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME:
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
 		pkt->shdr.hdr.size += sizeof(u32);
 		break;
 	case HFI_PROPERTY_PARAM_VENC_MPEG4_SHORT_HEADER:
@@ -625,7 +602,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE: {
 		struct hfi_bitrate *in = pdata, *brate = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
 		brate->bitrate = in->bitrate;
 		brate->layer_id = in->layer_id;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*brate);
@@ -634,7 +610,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE: {
 		struct hfi_bitrate *in = pdata, *hfi = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
 		hfi->bitrate = in->bitrate;
 		hfi->layer_id = in->layer_id;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hfi);
@@ -643,7 +618,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT: {
 		struct hfi_profile_level *in = pdata, *pl = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
 		pl->level = in->level;
 		pl->profile = in->profile;
 		if (pl->profile <= 0)
@@ -660,7 +634,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL: {
 		struct hfi_h264_entropy_control *in = pdata, *hfi = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL;
 		hfi->entropy_mode = in->entropy_mode;
 		if (hfi->entropy_mode == HFI_H264_ENTROPY_CABAC)
 			hfi->cabac_model = in->cabac_model;
@@ -682,7 +655,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_RATE_CONTROL;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -690,7 +662,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION: {
 		struct hfi_mpeg4_time_resolution *in = pdata, *res = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION;
 		res->time_increment_resolution = in->time_increment_resolution;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*res);
 		break;
@@ -698,7 +669,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION: {
 		struct hfi_mpeg4_header_extension *in = pdata, *ext = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION;
 		ext->header_extension = in->header_extension;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ext);
 		break;
@@ -716,7 +686,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL;
 		db->mode = in->mode;
 		db->slice_alpha_offset = in->slice_alpha_offset;
 		db->slice_beta_offset = in->slice_beta_offset;
@@ -726,7 +695,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_SESSION_QP: {
 		struct hfi_quantization *in = pdata, *quant = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SESSION_QP;
 		quant->qp_i = in->qp_i;
 		quant->qp_p = in->qp_p;
 		quant->qp_b = in->qp_b;
@@ -738,7 +706,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_quantization_range *in = pdata, *range = prop_data;
 		u32 min_qp, max_qp;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE;
 		min_qp = in->min_qp;
 		max_qp = in->max_qp;
 
@@ -764,8 +731,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG: {
 		struct hfi_vc1e_perf_cfg_type *in = pdata, *perf = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG;
-
 		memcpy(perf->search_range_x_subsampled,
 		       in->search_range_x_subsampled,
 		       sizeof(perf->search_range_x_subsampled));
@@ -780,7 +745,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_max_num_b_frames *bframes = prop_data;
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES;
 		bframes->max_num_b_frames = *in;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*bframes);
 		break;
@@ -788,7 +752,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD: {
 		struct hfi_intra_period *in = pdata, *intra = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD;
 		intra->pframes = in->pframes;
 		intra->bframes = in->bframes;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*intra);
@@ -797,7 +760,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD: {
 		struct hfi_idr_period *in = pdata, *idr = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
 		idr->idr_period = in->idr_period;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*idr);
 		break;
@@ -806,7 +768,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_conceal_color *color = prop_data;
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR;
 		color->conceal_color = *in;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*color);
 		break;
@@ -835,7 +796,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VPE_OPERATIONS;
 		ops->rotation = in->rotation;
 		ops->flip = in->flip;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ops);
@@ -856,7 +816,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH;
 		intra->mode = in->mode;
 		intra->air_mbs = in->air_mbs;
 		intra->air_ref = in->air_ref;
@@ -878,7 +837,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL;
 		multi->multi_slice = in->multi_slice;
 		multi->slice_size = in->slice_size;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*multi);
@@ -887,7 +845,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -895,7 +852,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO: {
 		struct hfi_h264_vui_timing_info *in = pdata, *vui = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;
 		vui->enable = in->enable;
 		vui->fixed_framerate = in->fixed_framerate;
 		vui->time_scale = in->time_scale;
@@ -905,7 +861,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VPE_DEINTERLACE: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VPE_DEINTERLACE;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -913,7 +868,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -921,7 +875,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE: {
 		struct hfi_buffer_alloc_mode *in = pdata, *mode = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
 		mode->type = in->type;
 		mode->mode = in->mode;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*mode);
@@ -930,7 +883,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -938,8 +890,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -947,7 +897,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -956,7 +905,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_scs_threshold *thres = prop_data;
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD;
 		thres->threshold_value = *in;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*thres);
 		break;
@@ -974,7 +922,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT;
 		mvc->layout_type = in->layout_type;
 		mvc->bright_view_first = in->bright_view_first;
 		mvc->ngap = in->ngap;
@@ -994,7 +941,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_LTRMODE;
 		ltr->ltr_mode = in->ltr_mode;
 		ltr->ltr_count = in->ltr_count;
 		ltr->trust_mode = in->trust_mode;
@@ -1004,7 +950,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_USELTRFRAME: {
 		struct hfi_ltr_use *in = pdata, *ltr_use = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_USELTRFRAME;
 		ltr_use->frames = in->frames;
 		ltr_use->ref_ltr = in->ref_ltr;
 		ltr_use->use_constrnt = in->use_constrnt;
@@ -1014,7 +959,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME: {
 		struct hfi_ltr_mark *in = pdata, *ltr_mark = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME;
 		ltr_mark->mark_frame = in->mark_frame;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ltr_mark);
 		break;
@@ -1022,7 +966,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER: {
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -1030,7 +973,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER: {
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -1038,7 +980,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -1046,7 +987,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_INITIAL_QP: {
 		struct hfi_initial_quantization *in = pdata, *quant = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INITIAL_QP;
 		quant->init_qp_enable = in->init_qp_enable;
 		quant->qp_i = in->qp_i;
 		quant->qp_p = in->qp_p;
@@ -1058,7 +998,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_vpe_color_space_conversion *in = pdata;
 		struct hfi_vpe_color_space_conversion *csc = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VPE_COLOR_SPACE_CONVERSION;
 		memcpy(csc->csc_matrix, in->csc_matrix,
 		       sizeof(csc->csc_matrix));
 		memcpy(csc->csc_bias, in->csc_bias, sizeof(csc->csc_bias));
@@ -1069,8 +1008,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] =
-			HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -1078,7 +1015,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -1086,7 +1022,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_CONFIG_VENC_PERF_MODE: {
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_PERF_MODE;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -1094,7 +1029,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER: {
 		u32 *in = pdata;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER;
 		pkt->data[1] = *in;
 		pkt->shdr.hdr.size += sizeof(u32) * 2;
 		break;
@@ -1102,7 +1036,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2: {
 		struct hfi_enable *in = pdata, *en = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2;
 		en->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
 		break;
@@ -1110,7 +1043,6 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
 	case HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE: {
 		struct hfi_hybrid_hierp *in = pdata, *hierp = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE;
 		hierp->layers = in->layers;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hierp);
 		break;
@@ -1185,6 +1117,7 @@ pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
 	pkt->shdr.session_id = hash32_ptr(cookie);
 	pkt->num_properties = 1;
+	pkt->data[0] = ptype;
 
 	/*
 	 * Any session set property which is different in 3XX packetization
@@ -1196,7 +1129,6 @@ pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
 		struct hfi_multi_stream *in = pdata;
 		struct hfi_multi_stream_3x *multi = prop_data;
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM;
 		multi->buffer_type = in->buffer_type;
 		multi->enable = in->enable;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*multi);
@@ -1218,7 +1150,6 @@ pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
 			break;
 		}
 
-		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH;
 		intra->mode = in->mode;
 		intra->mbs = in->cir_mbs;
 		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*intra);
-- 
2.11.0
