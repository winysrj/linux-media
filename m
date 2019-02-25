Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B3AC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1999C213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyuhJmQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfBYWWe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36609 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbfBYWWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id o17so11725598wrw.3
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u7nIK9RaLpZeWxvOqwfSMA/esHJD9AYSjfAlKlW+I88=;
        b=ZyuhJmQzcYXonaGS2uZu9Jhx567rxrlscLkrm5ihXTg8NOuu1AKR//ypX5X/a9iBTz
         2sYwfCXd3jHMFV3KngLyeUDfrOfI/RNWlQ3UdNnAhY24WZbXDAVptPZAxqe6+IIPLJBg
         O75SV1SuL66Vv4GTBS4AT1YWuPjvRSuKC63GSb0qv+TZR1q4GS3PsiXQ9RIPe8piHV+l
         NwyOZBbKzG4c9xBLwIX1Zcf9k4+RF8PDiJB9qt6b4mvtCCFPmTjaa3qkUnH4NdBFrlp7
         8f4j7LHxEkrYz0wNv8LoxVyVzAm3x4h8dGYupEv7KafE9WYCXn9RGC3qoInCzmHwoI9Z
         zouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u7nIK9RaLpZeWxvOqwfSMA/esHJD9AYSjfAlKlW+I88=;
        b=D5ULaxDhe4mni489CYqWtjXuRbtNHvnkaMarfs8vTppnEzpd3QBt+vFI0ArJV30OjJ
         wUGNOfOasaO2Y6bIAHmEoxcl7RD3GQhA3XvfS+rp6ZwE5oAqpAlrz03wL9F2IH0TgrzF
         G7rg7DSljzyrdcFxAtnGtC3KYcUHIWkrafokIOpLyxCrGszqxti6AaBWuTrQP9R8SqrN
         LziLWlavzhRwtcSojnEu4N4WGkm4X7b/Bujh72ShJX4D8jep1WgVpq0Y6J+9T4WThNl8
         IM2AVh0wH2nwjbwaArzqQLfP4LC3BoAVOPAmUwHmUs3R6iqq9Vwryl+ZsqbUtRBPHYxO
         Y2Fg==
X-Gm-Message-State: AHQUAuaW92Hd5T5MtNKDXusbs6QKsMdXcCpwq/UGb8Xat1n1tacgqgmP
        SZvFi0B5W7pP64gfvN9q+pMDuyqKGm0=
X-Google-Smtp-Source: AHgI3IZa1+kv26K+iuqF4zLl82CiuyVjZ59a70E9hrjbb/x+xdsUd78/v1/+Ukqqrnc9fgpIU+8+3g==
X-Received: by 2002:adf:b687:: with SMTP id j7mr14783972wre.81.1551133351833;
        Mon, 25 Feb 2019 14:22:31 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:31 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 19/21] media: vicodec: Introducing stateless fwht defs and structs
Date:   Mon, 25 Feb 2019 14:22:10 -0800
Message-Id: <20190225222210.121713-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add structs and definitions needed to implement stateless
decoder for fwht.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 23 ++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
 include/media/fwht-ctrls.h                    | 32 +++++++++++++++++++
 include/media/v4l2-ctrls.h                    |  4 ++-
 include/uapi/linux/v4l2-controls.h            |  3 ++
 include/uapi/linux/videodev2.h                |  1 +
 6 files changed, 64 insertions(+), 9 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 5998b9e86cda..5d6f0cdc2064 100644
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
@@ -1539,7 +1539,7 @@ static const struct v4l2_ctrl_ops vicodec_ctrl_ops = {
 
 static const struct v4l2_ctrl_config vicodec_ctrl_i_frame = {
 	.ops = &vicodec_ctrl_ops,
-	.id = VICODEC_CID_I_FRAME_QP,
+	.id = V4L2_CID_FWHT_I_FRAME_QP,
 	.name = "FWHT I-Frame QP Value",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 1,
@@ -1550,7 +1550,7 @@ static const struct v4l2_ctrl_config vicodec_ctrl_i_frame = {
 
 static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
 	.ops = &vicodec_ctrl_ops,
-	.id = VICODEC_CID_P_FRAME_QP,
+	.id = V4L2_CID_FWHT_I_FRAME_QP,
 	.name = "FWHT P-Frame QP Value",
 	.type = V4L2_CTRL_TYPE_INTEGER,
 	.min = 1,
@@ -1559,6 +1559,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
+	.id		= V4L2_CID_MPEG_VIDEO_FWHT_PARAMS,
+	.elem_size	= sizeof(struct v4l2_ctrl_fwht_params),
+	.name		= "FWHT-Stateless State Params",
+	.type		= V4L2_CTRL_TYPE_FWHT_PARAMS,
+};
+
 /*
  * File operations
  */
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 54d66dbc2a31..d5027775c24a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -849,6 +849,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG-2 Slice Parameters";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG-2 Quantization Matrices";
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:			return "FWHT stateless parameters";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1303,6 +1304,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:
+		*type = V4L2_CTRL_TYPE_FWHT_PARAMS;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1669,6 +1673,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		return 0;
 
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2249,6 +2256,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
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
index 000000000000..0aee2782f49c
--- /dev/null
+++ b/include/media/fwht-ctrls.h
@@ -0,0 +1,32 @@
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
+	__u32 comp_frame_size;
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
index 06479f2fb3ae..e6c16a79f718 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -404,6 +404,9 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 #define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
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

