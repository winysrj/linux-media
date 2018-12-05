Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089ACC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C186520659
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C186520659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbeLEMJ6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:09:58 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42355 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727679AbeLEMJ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 07:09:57 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UVzygMfGDUylNUW02gwY1K; Wed, 05 Dec 2018 13:09:55 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 1/2] mpeg2-ctrls.h: move MPEG2 state controls to non-public header
Date:   Wed,  5 Dec 2018 13:09:49 +0100
Message-Id: <20181205120950.36986-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
References: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfItqBOBBncnip+nHfCTTeIsV3NOTxrO4LlQXKDbOOBcRkenmsevis6zr/zp/Q6U/e22Nzx7cQd3Q9uNGOQWnicOHMpQq0t2tLSzHmYtmLZ+iy3Qx+NuA
 8matAGU3XCdboU1maWujF8PShwTShFRk83Zn/YQqcdCoyGdmgHV1FchlBnDKlohQAxNWPRYEy3iEucBJp+vSH1ZOdg8g0+XpFquQID/CLCMd2WBkDT9hq3Vd
 t4TJFf+dw2ETYvOf+169sM2Vn4bnrhoHqjPnZfystpH2EqZRkuAqOboDztV/3qfwmAmRwTtfO3dBevUbv3qf2Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The MPEG2 state controls for the cedrus stateless MPEG2 driver are
not yet stable. Move them out of the public headers into media/mpeg2-ctrls.h.

Eventually, once this has stabilized, they will be moved back to the
public headers.

Unfortunately I had to cast the control type to a u32 in two switch
statements to prevent a compiler warning about a control type define
not being part of the enum.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |  4 +-
 include/media/mpeg2-ctrls.h          | 86 ++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  6 ++
 include/uapi/linux/v4l2-controls.h   | 68 ----------------------
 include/uapi/linux/videodev2.h       |  4 --
 5 files changed, 94 insertions(+), 74 deletions(-)
 create mode 100644 include/media/mpeg2-ctrls.h

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5f2b033a7a42..10b8d94edbef 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1563,7 +1563,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	u64 offset;
 	s64 val;
 
-	switch (ctrl->type) {
+	switch ((u32)ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
@@ -2232,7 +2232,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	is_array = nr_of_dims > 0;
 
 	/* Prefill elem_size for all types handled by std_type_ops */
-	switch (type) {
+	switch ((u32)type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
 		elem_size = sizeof(s64);
 		break;
diff --git a/include/media/mpeg2-ctrls.h b/include/media/mpeg2-ctrls.h
new file mode 100644
index 000000000000..d21f40edc09e
--- /dev/null
+++ b/include/media/mpeg2-ctrls.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * These are the MPEG2 state controls for use with stateless MPEG-2
+ * codec drivers.
+ *
+ * It turns out that these structs are not stable yet and will undergo
+ * more changes. So keep them private until they are stable and ready to
+ * become part of the official public API.
+ */
+
+#ifndef _MPEG2_CTRLS_H_
+#define _MPEG2_CTRLS_H_
+
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS		(V4L2_CID_MPEG_BASE+250)
+#define V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION		(V4L2_CID_MPEG_BASE+251)
+
+/* enum v4l2_ctrl_type type values */
+#define V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS 0x0103
+#define	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION 0x0104
+
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_I	1
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_P	2
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_B	3
+#define V4L2_MPEG2_PICTURE_CODING_TYPE_D	4
+
+struct v4l2_mpeg2_sequence {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence header */
+	__u16	horizontal_size;
+	__u16	vertical_size;
+	__u32	vbv_buffer_size;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
+	__u8	profile_and_level_indication;
+	__u8	progressive_sequence;
+	__u8	chroma_format;
+	__u8	pad;
+};
+
+struct v4l2_mpeg2_picture {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture header */
+	__u8	picture_coding_type;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture coding extension */
+	__u8	f_code[2][2];
+	__u8	intra_dc_precision;
+	__u8	picture_structure;
+	__u8	top_field_first;
+	__u8	frame_pred_frame_dct;
+	__u8	concealment_motion_vectors;
+	__u8	q_scale_type;
+	__u8	intra_vlc_format;
+	__u8	alternate_scan;
+	__u8	repeat_first_field;
+	__u8	progressive_frame;
+	__u8	pad;
+};
+
+struct v4l2_ctrl_mpeg2_slice_params {
+	__u32	bit_size;
+	__u32	data_bit_offset;
+
+	struct v4l2_mpeg2_sequence sequence;
+	struct v4l2_mpeg2_picture picture;
+
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
+	__u8	quantiser_scale_code;
+
+	__u8	backward_ref_index;
+	__u8	forward_ref_index;
+	__u8	pad;
+};
+
+struct v4l2_ctrl_mpeg2_quantization {
+	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Quant matrix extension */
+	__u8	load_intra_quantiser_matrix;
+	__u8	load_non_intra_quantiser_matrix;
+	__u8	load_chroma_intra_quantiser_matrix;
+	__u8	load_chroma_non_intra_quantiser_matrix;
+
+	__u8	intra_quantiser_matrix[64];
+	__u8	non_intra_quantiser_matrix[64];
+	__u8	chroma_intra_quantiser_matrix[64];
+	__u8	chroma_non_intra_quantiser_matrix[64];
+};
+
+#endif
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 83ce0593b275..d63cf227b0ab 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,12 @@
 #include <linux/videodev2.h>
 #include <media/media-request.h>
 
+/*
+ * Include the mpeg2 stateless codec compound control definitions.
+ * This will move to the public headers once this API is fully stable.
+ */
+#include <media/mpeg2-ctrls.h>
+
 /* forward references */
 struct file;
 struct v4l2_ctrl_handler;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..3dcfc6148f99 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -404,9 +404,6 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 #define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
-#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS		(V4L2_CID_MPEG_BASE+250)
-#define V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION		(V4L2_CID_MPEG_BASE+251)
-
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
 #define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+302)
@@ -1097,69 +1094,4 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
-#define V4L2_MPEG2_PICTURE_CODING_TYPE_I	1
-#define V4L2_MPEG2_PICTURE_CODING_TYPE_P	2
-#define V4L2_MPEG2_PICTURE_CODING_TYPE_B	3
-#define V4L2_MPEG2_PICTURE_CODING_TYPE_D	4
-
-struct v4l2_mpeg2_sequence {
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence header */
-	__u16	horizontal_size;
-	__u16	vertical_size;
-	__u32	vbv_buffer_size;
-
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
-	__u8	profile_and_level_indication;
-	__u8	progressive_sequence;
-	__u8	chroma_format;
-	__u8	pad;
-};
-
-struct v4l2_mpeg2_picture {
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture header */
-	__u8	picture_coding_type;
-
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Picture coding extension */
-	__u8	f_code[2][2];
-	__u8	intra_dc_precision;
-	__u8	picture_structure;
-	__u8	top_field_first;
-	__u8	frame_pred_frame_dct;
-	__u8	concealment_motion_vectors;
-	__u8	q_scale_type;
-	__u8	intra_vlc_format;
-	__u8	alternate_scan;
-	__u8	repeat_first_field;
-	__u8	progressive_frame;
-	__u8	pad;
-};
-
-struct v4l2_ctrl_mpeg2_slice_params {
-	__u32	bit_size;
-	__u32	data_bit_offset;
-
-	struct v4l2_mpeg2_sequence sequence;
-	struct v4l2_mpeg2_picture picture;
-
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
-	__u8	quantiser_scale_code;
-
-	__u8	backward_ref_index;
-	__u8	forward_ref_index;
-	__u8	pad;
-};
-
-struct v4l2_ctrl_mpeg2_quantization {
-	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Quant matrix extension */
-	__u8	load_intra_quantiser_matrix;
-	__u8	load_non_intra_quantiser_matrix;
-	__u8	load_chroma_intra_quantiser_matrix;
-	__u8	load_chroma_non_intra_quantiser_matrix;
-
-	__u8	intra_quantiser_matrix[64];
-	__u8	non_intra_quantiser_matrix[64];
-	__u8	chroma_intra_quantiser_matrix[64];
-	__u8	chroma_non_intra_quantiser_matrix[64];
-};
-
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2a223835214c..6d8ae5db5e6c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1623,8 +1623,6 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
-		struct v4l2_ctrl_mpeg2_slice_params __user *p_mpeg2_slice_params;
-		struct v4l2_ctrl_mpeg2_quantization __user *p_mpeg2_quantization;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1670,8 +1668,6 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
-	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
-	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.19.1

