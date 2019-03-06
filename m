Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD862C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A246B20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQWYQi2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfCFVOk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34000 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:39 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so15039266wrg.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8nuDe8Fhot6h19FZas3I6Uiz952bUlZxxthxj1tuL1M=;
        b=UQWYQi2r/kdpUBuIB7qQn3On4nVmSQSsY15sogU+kDHt5llhgPzotaRt82kgAUGOTA
         4tPLMdkQHBf8oKtE274kO2c5Qk1TmGM3vwm2mMKKJ146JWv4FRgkmvWl84RDRhxgKbCk
         lYvurCOeZY/YnILODlWjR7Xef4ioImHoiyNDAo0+zGYPV93ZdNasHjLRa6F0VQAHfQJe
         NuoW/Re2kCsKVcX79TILRmUjm6zjPfOTcleR1FJFkN/T3a/qnlcMlaa6YkZr52e8c3Sr
         sa8oByix9CLEZphrlAh6xLupl57ISA/OkxmnBxRMW+97SOs/008d4Sk8j7UtMCB2e9pp
         2ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8nuDe8Fhot6h19FZas3I6Uiz952bUlZxxthxj1tuL1M=;
        b=kcrhetMHwPLWgmsMTAtx/wX59s0J7ggWQrRSk/IxXGoSaV3RjoQ7A8405oZjkuzGyH
         cLlm1XcFaCIkJ16CIf46zE/mCyCVPG+fMzO7kUxAciwj9HUkzVlMlHD+EnnzY2v8LOTC
         SFLKTr+2OSs4l4UJvHKkX323DNhbNYXe4uHtFQFM9WePWVzFkaJyZgmxQhM2lEqLb2kF
         QPopiYJT+j5PjXPzDJm7edMDTGr91fWM0girVgzlF0z3r8A96N9o+DsSO4r8UAJSsV1m
         3oZeAkhP5gFPbJJwTSK/9b5FqJmX8MWWRWs8xuy5ytoZC1RkX3okoHIyZ2oAKgE9JISK
         o10Q==
X-Gm-Message-State: APjAAAXWTm2uCBzhDE5FErhVe+oQBtJOLlrAswGZtGWWqqWbONG4kbRz
        w7MQ387NDeHV0BBlzyp9wTWMHWaDC+A=
X-Google-Smtp-Source: APXvYqxMvp9cc3twzIZto6gwJJ1KtR2Etwmr+mIDjHlG1Url0INf3PrTflY4NlYmLcOqjidISH34Dw==
X-Received: by 2002:adf:ed0f:: with SMTP id a15mr4300032wro.249.1551906877245;
        Wed, 06 Mar 2019 13:14:37 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:36 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 20/23] media: vicodec: Introducing stateless fwht defs and structs
Date:   Wed,  6 Mar 2019 13:13:40 -0800
Message-Id: <20190306211343.15302-21-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add structs and definitions needed to implement stateless
decoder for fwht and add I/P-frames QP controls to the
public api.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 41 ++++++-------------
 drivers/media/v4l2-core/v4l2-ctrls.c          | 12 ++++++
 include/media/fwht-ctrls.h                    | 31 ++++++++++++++
 include/media/v4l2-ctrls.h                    |  5 ++-
 include/uapi/linux/v4l2-controls.h            |  4 ++
 include/uapi/linux/videodev2.h                |  1 +
 6 files changed, 65 insertions(+), 29 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 5998b9e86cda..6c9a41838d31 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -64,6 +64,10 @@ static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
 	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0, 1
 };
 
+static const struct v4l2_fwht_pixfmt_info pixfmt_stateless_fwht = {
+	V4L2_PIX_FMT_FWHT_STATELESS, 0, 3, 1, 1, 1, 1, 1, 0, 1
+};
+
 static void vicodec_dev_release(struct device *dev)
 {
 }
@@ -1510,10 +1514,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	return vb2_queue_init(dst_vq);
 }
 
-#define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
-#define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
-#define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
-
 static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vicodec_ctx *ctx = container_of(ctrl->handler,
@@ -1523,10 +1523,10 @@ static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		ctx->state.gop_size = ctrl->val;
 		return 0;
-	case VICODEC_CID_I_FRAME_QP:
+	case V4L2_CID_FWHT_I_FRAME_QP:
 		ctx->state.i_frame_qp = ctrl->val;
 		return 0;
-	case VICODEC_CID_P_FRAME_QP:
+	case V4L2_CID_FWHT_P_FRAME_QP:
 		ctx->state.p_frame_qp = ctrl->val;
 		return 0;
 	}
@@ -1537,26 +1537,9 @@ static const struct v4l2_ctrl_ops vicodec_ctrl_ops = {
 	.s_ctrl = vicodec_s_ctrl,
 };
 
-static const struct v4l2_ctrl_config vicodec_ctrl_i_frame = {
-	.ops = &vicodec_ctrl_ops,
-	.id = VICODEC_CID_I_FRAME_QP,
-	.name = "FWHT I-Frame QP Value",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 1,
-	.max = 31,
-	.def = 20,
-	.step = 1,
-};
-
-static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
-	.ops = &vicodec_ctrl_ops,
-	.id = VICODEC_CID_P_FRAME_QP,
-	.name = "FWHT P-Frame QP Value",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 1,
-	.max = 31,
-	.def = 20,
-	.step = 1,
+static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
+	.id		= V4L2_CID_MPEG_VIDEO_FWHT_PARAMS,
+	.elem_size      = sizeof(struct v4l2_ctrl_fwht_params),
 };
 
 /*
@@ -1589,8 +1572,10 @@ static int vicodec_open(struct file *file)
 	v4l2_ctrl_handler_init(hdl, 4);
 	v4l2_ctrl_new_std(hdl, &vicodec_ctrl_ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
 			  1, 16, 1, 10);
-	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame, NULL);
-	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame, NULL);
+	v4l2_ctrl_new_std(hdl, &vicodec_ctrl_ops, V4L2_CID_FWHT_I_FRAME_QP,
+			  1, 31, 1, 20);
+	v4l2_ctrl_new_std(hdl, &vicodec_ctrl_ops, V4L2_CID_FWHT_P_FRAME_QP,
+			  1, 31, 1, 20);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 54d66dbc2a31..aed1c3a06500 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -849,6 +849,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG-2 Slice Parameters";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG-2 Quantization Matrices";
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:			return "FWHT Stateless Parameters";
+	case V4L2_CID_FWHT_I_FRAME_QP:				return "FWHT I-Frame QP Value";
+	case V4L2_CID_FWHT_P_FRAME_QP:				return "FWHT P-Frame QP Value";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1303,6 +1306,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:
+		*type = V4L2_CTRL_TYPE_FWHT_PARAMS;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1669,6 +1675,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		return 0;
 
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2249,6 +2258,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
 		break;
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_fwht_params);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/include/media/fwht-ctrls.h b/include/media/fwht-ctrls.h
new file mode 100644
index 000000000000..615027410e47
--- /dev/null
+++ b/include/media/fwht-ctrls.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * These are the FWHT state controls for use with stateless FWHT
+ * codec drivers.
+ *
+ * It turns out that these structs are not stable yet and will undergo
+ * more changes. So keep them private until they are stable and ready to
+ * become part of the official public API.
+ */
+
+#ifndef _FWHT_CTRLS_H_
+#define _FWHT_CTRLS_H_
+
+#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
+
+#define V4L2_CID_MPEG_VIDEO_FWHT_PARAMS	(V4L2_CID_MPEG_BASE + 292)
+
+struct v4l2_ctrl_fwht_params {
+	__u64 backward_ref_ts;
+	__u32 version;
+	__u32 width;
+	__u32 height;
+	__u32 flags;
+	__u32 colorspace;
+	__u32 xfer_func;
+	__u32 ycbcr_enc;
+	__u32 quantization;
+};
+
+
+#endif
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 200f8a66ecaa..bd621cec65a5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -23,10 +23,11 @@
 #include <media/media-request.h>
 
 /*
- * Include the mpeg2 stateless codec compound control definitions.
+ * Include the mpeg2 and fwht stateless codec compound control definitions.
  * This will move to the public headers once this API is fully stable.
  */
 #include <media/mpeg2-ctrls.h>
+#include <media/fwht-ctrls.h>
 
 /* forward references */
 struct file;
@@ -49,6 +50,7 @@ struct poll_table_struct;
  * @p_char:			Pointer to a string.
  * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
  * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
+ * @p_fwht_params:		Pointer to a FWHT stateless parameters structure.
  * @p:				Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -60,6 +62,7 @@ union v4l2_ctrl_ptr {
 	char *p_char;
 	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
 	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
+	struct v4l2_ctrl_fwht_params *p_fwht_params;
 	void *p;
 };
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 06479f2fb3ae..78816ec88751 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -404,6 +404,10 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 #define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
+/* CIDs for the FWHT codec as used by the vicodec driver. */
+#define V4L2_CID_FWHT_I_FRAME_QP             (V4L2_CID_MPEG_BASE + 290)
+#define V4L2_CID_FWHT_P_FRAME_QP             (V4L2_CID_MPEG_BASE + 291)
+
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
 #define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+302)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 97e6a6a968ba..1ac3c22d883a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -669,6 +669,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
 #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC aka H.265 */
 #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast Walsh Hadamard Transform (vicodec) */
+#define V4L2_PIX_FMT_FWHT_STATELESS     v4l2_fourcc('S', 'F', 'W', 'H') /* Stateless FWHT (vicodec) */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
2.17.1

