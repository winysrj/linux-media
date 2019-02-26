Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85192C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D51B20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ap6pk77+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfBZRGB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:06:01 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34551 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfBZRGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:06:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so14813989wrg.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LAvNC+ZQpwr0Stoh15jHJj5NHHqq7bRoyK98A6lS0fw=;
        b=ap6pk77+9PgrAQPBx849it1ReUCu+rZS+oVcIxQtWbu4XagY8CDxrszw1yJbMEEF3C
         XQeHneY6HJ6UsewGqPdz60nC8dayJ4UyV6DX1/DwpnG8cPHsgQzHzmtMuQUwdTTekBoX
         Gxh6ef/5gVWIS2VrUj/dCNXo0rjZG4nQu5h+rwuKXF4iqtNZBxtG1E6RoHfQl1DDXv2B
         9tGz0wpxI2BE+GHKg4VhKYoFCgrLKBAjvAENg0xubzQgIa63EiVO3xWkEmQvhjl+Q69W
         QSVZLo9DKWtgWi1X5eSe8YDQxx4QS4UZPjqUi4nteFv2sq8OIB9VpWAI7BLvC0Yjp75B
         DWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LAvNC+ZQpwr0Stoh15jHJj5NHHqq7bRoyK98A6lS0fw=;
        b=EIE045cqOAz/VmATJKdeeqpdtawadUFIVViY3XBwQUCAw97OmBcAE1vJ5i4XyQwlon
         fsnwKIkM8tv81y1u0hn9PQ8tqYaLo5nMN+22MBdcG+2/3LFuDPt8Z2/CQAh8jk0c1J/R
         AqD/TeDpQvznYVeujqXYIeiHqTyAgo3kHxinEMf7w0L5i8GH025G22o12RudvOB21zMs
         hkV40rTd3otpqoDGfTln/PMvQR05CRo9FC3b7LkdxQcl8EVUQvZSmYtWI0E/38Ai5/L0
         lrV/u76aP4vpOBdstHeYeckhcVDSErYCQdAmpHYR4eHM5f63uFKV6CSDmBWF4sD2jfqb
         RlVQ==
X-Gm-Message-State: AHQUAubSymMkbQXp0nF7JuGvsQoiyeV+bOIt9Hs+5RYOfQrv/VzkcAi2
        KBVghp69baC9c4hdG7JeqL1EW5rML5c=
X-Google-Smtp-Source: AHgI3Ia6Y04QO7waFvTN8a8xKR4H1lV3jUjXBBEWscuaiefWT9doy3acP3c6QxzUnv0QW21wSRigew==
X-Received: by 2002:a5d:5681:: with SMTP id f1mr17456826wrv.95.1551200757973;
        Tue, 26 Feb 2019 09:05:57 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:57 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 19/21] media: vicodec: Introducing stateless fwht defs and structs
Date:   Tue, 26 Feb 2019 09:05:12 -0800
Message-Id: <20190226170514.86127-20-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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
 include/media/v4l2-ctrls.h                    |  4 +-
 include/uapi/linux/v4l2-controls.h            |  4 ++
 include/uapi/linux/videodev2.h                |  1 +
 6 files changed, 64 insertions(+), 29 deletions(-)
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
index c40dcf79b5b9..4dad20658feb 100644
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
@@ -60,6 +61,7 @@ union v4l2_ctrl_ptr {
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

