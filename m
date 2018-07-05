Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36729 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbeGENFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:11 -0400
Received: by mail-wm0-f46.google.com with SMTP id s14-v6so10732405wmc.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:10 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 03/27] venus: hfi: update sequence event to handle more properties
Date: Thu,  5 Jul 2018 16:03:37 +0300
Message-Id: <20180705130401.24315-4-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HFI version 4xx can pass more properties in the sequence change
event, extend the event structure with them.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi.h        | 10 ++++++
 drivers/media/platform/qcom/venus/hfi_helper.h | 28 ++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c   | 44 ++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi.h b/drivers/media/platform/qcom/venus/hfi.h
index 5466b7d60dd0..6038d8e0ab22 100644
--- a/drivers/media/platform/qcom/venus/hfi.h
+++ b/drivers/media/platform/qcom/venus/hfi.h
@@ -74,6 +74,16 @@ struct hfi_event_data {
 	u32 tag;
 	u32 profile;
 	u32 level;
+	/* the following properties start appear from v4 onwards */
+	u32 bit_depth;
+	u32 pic_struct;
+	u32 colour_space;
+	u32 entropy_mode;
+	u32 buf_count;
+	struct {
+		u32 left, top;
+		u32 width, height;
+	} input_crop;
 };
 
 /* define core states */
diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
index f5f1557b1176..1bc5aab1ce6b 100644
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -801,6 +801,34 @@ struct hfi_h264_vui_timing_info {
 	u32 time_scale;
 };
 
+struct hfi_bit_depth {
+	u32 buffer_type;
+	u32 bit_depth;
+};
+
+struct hfi_picture_type {
+	u32 is_sync_frame;
+	u32 picture_type;
+};
+
+struct hfi_pic_struct {
+	u32 progressive_only;
+};
+
+struct hfi_colour_space {
+	u32 colour_space;
+};
+
+struct hfi_extradata_input_crop {
+	u32 size;
+	u32 version;
+	u32 port_index;
+	u32 left;
+	u32 top;
+	u32 width;
+	u32 height;
+};
+
 #define HFI_COLOR_FORMAT_MONOCHROME		0x01
 #define HFI_COLOR_FORMAT_NV12			0x02
 #define HFI_COLOR_FORMAT_NV21			0x03
diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index 589e1a6b36a9..54cd41e5837c 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -25,10 +25,16 @@
 static void event_seq_changed(struct venus_core *core, struct venus_inst *inst,
 			      struct hfi_msg_event_notify_pkt *pkt)
 {
+	enum hfi_version ver = core->res->hfi_version;
 	struct hfi_event_data event = {0};
 	int num_properties_changed;
 	struct hfi_framesize *frame_sz;
 	struct hfi_profile_level *profile_level;
+	struct hfi_bit_depth *pixel_depth;
+	struct hfi_pic_struct *pic_struct;
+	struct hfi_colour_space *colour_info;
+	struct hfi_buffer_requirements *bufreq;
+	struct hfi_extradata_input_crop *crop;
 	u8 *data_ptr;
 	u32 ptype;
 
@@ -69,6 +75,44 @@ static void event_seq_changed(struct venus_core *core, struct venus_inst *inst,
 			event.level = profile_level->level;
 			data_ptr += sizeof(*profile_level);
 			break;
+		case HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH:
+			data_ptr += sizeof(u32);
+			pixel_depth = (struct hfi_bit_depth *)data_ptr;
+			event.bit_depth = pixel_depth->bit_depth;
+			data_ptr += sizeof(*pixel_depth);
+			break;
+		case HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT:
+			data_ptr += sizeof(u32);
+			pic_struct = (struct hfi_pic_struct *)data_ptr;
+			event.pic_struct = pic_struct->progressive_only;
+			data_ptr += sizeof(*pic_struct);
+			break;
+		case HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE:
+			data_ptr += sizeof(u32);
+			colour_info = (struct hfi_colour_space *)data_ptr;
+			event.colour_space = colour_info->colour_space;
+			data_ptr += sizeof(*colour_info);
+			break;
+		case HFI_PROPERTY_CONFIG_VDEC_ENTROPY:
+			data_ptr += sizeof(u32);
+			event.entropy_mode = *(u32 *)data_ptr;
+			data_ptr += sizeof(u32);
+			break;
+		case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
+			data_ptr += sizeof(u32);
+			bufreq = (struct hfi_buffer_requirements *)data_ptr;
+			event.buf_count = HFI_BUFREQ_COUNT_MIN(bufreq, ver);
+			data_ptr += sizeof(*bufreq);
+			break;
+		case HFI_INDEX_EXTRADATA_INPUT_CROP:
+			data_ptr += sizeof(u32);
+			crop = (struct hfi_extradata_input_crop *)data_ptr;
+			event.input_crop.left = crop->left;
+			event.input_crop.top = crop->top;
+			event.input_crop.width = crop->width;
+			event.input_crop.height = crop->height;
+			data_ptr += sizeof(*crop);
+			break;
 		default:
 			break;
 		}
-- 
2.14.1
