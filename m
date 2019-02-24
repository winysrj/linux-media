Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B9C4360F
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E927D206B6
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vSjEUp6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfBXJDO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:14 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38608 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfBXJDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id v26so5412065wmh.3
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/fkPTNrZGjDikjanKkS+XW/+7SrrLNtHm994ch5vwqY=;
        b=vSjEUp6uZQATLvWjgFyDIAijsghNig9nkZlPYyTzcJx9pp4WfzMl4wBbFRqqoWeBJh
         J20vA8nT7qeit2x8yMqM1A28iWuaQ5jLqitlqABIUs1pALni/hgMdRIhsgck9Dc0KDD5
         lqot9MdJ3sEFKGOEcVEZ1+jThtNvmLEKqWuCjEZI3xJ29MXgaucy9dXT+htkvXO2Oz0R
         ukU2/2itEB14439GsJrG6vqOI6sWIev7HT7LKyMLu3YQLSTA1BV9901wRe+daT72ovSo
         PjlwiSHf0BsQJ8pecHmuXgVWRF1WNu00fbMZq9FW+QPR3rdNdNjm+OMglzVx8i0XnK2F
         g1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/fkPTNrZGjDikjanKkS+XW/+7SrrLNtHm994ch5vwqY=;
        b=eUB4bTgnibx8FuRUSbojfJRLvYYitAhjFkjGmb2wBOV0MYs/x15DEFYCGP4qFp7hlA
         JjbdmDL5RtUa/UYW2gkKMvm39WV3MCtjnK5S+0jLBp67Hz+n6uFLPaHPwkIo9eW/0YBK
         9GTXdQy/knQqMZsefSi/EJbmmXMFcccipQ7X63a+Q8vMq06/4WpjjJZWw8uEzJUZJKxW
         PZ6i71EZ6/+Usr9knmVrXSKm/nyC0zECCoXVnKiuBjsPEMk2+rx6AA6pkjVkEFvp0FGa
         i8f7ElpgB9VUnqYtp+pOm1Pqy5UX6BCTlA/viFQKusF0HdCWMJzcym+s2ChZNp7xIxon
         yp+w==
X-Gm-Message-State: AHQUAubudhPZm4LG/9lkk/pQgCRk+Dvfgala8bkWofPu/QTAnMlasBbD
        YyQDJRUoVMmaLXztoCm2qtoje30HDAs=
X-Google-Smtp-Source: AHgI3Ibo/B1u2mI3YyKoqRSnUPbKMS4FmZ8fTBRcefSUuxS1s8u4LXIukJfs68LXX/H+Y+qpbgbYdQ==
X-Received: by 2002:a1c:b783:: with SMTP id h125mr813998wmf.119.1550998990880;
        Sun, 24 Feb 2019 01:03:10 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:10 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 15/18] media: vicodec: Introducing stateless fwht defs and structs
Date:   Sun, 24 Feb 2019 01:02:32 -0800
Message-Id: <20190224090234.19723-16-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add structs and definitions needed to implement stateless
decoder for fwht.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 15 +++++---
 drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
 include/media/fwht-ctrls.h                    | 35 +++++++++++++++++++
 include/media/v4l2-ctrls.h                    |  4 ++-
 include/uapi/linux/videodev2.h                |  1 +
 5 files changed, 60 insertions(+), 5 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 2b71b723862a..869fe33f6f26 100644
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
@@ -1559,6 +1559,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
+	.id		= VICODEC_CID_STATELESS_FWHT,
+	.elem_size	= sizeof(struct v4l2_ctrl_fwht_params),
+	.name		= "FWHT-Stateless State Params",
+	.type		= V4L2_CTRL_TYPE_FWHT_PARAMS,
+};
+
 /*
  * File operations
  */
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 54d66dbc2a31..bfd51c2c1368 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -849,6 +849,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG-2 Slice Parameters";
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG-2 Quantization Matrices";
+	case VICODEC_CID_STATELESS_FWHT:			return "FWHT stateless parameters";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1303,6 +1304,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
 		break;
+	case VICODEC_CID_STATELESS_FWHT:
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
index 000000000000..3e7f411f5f94
--- /dev/null
+++ b/include/media/fwht-ctrls.h
@@ -0,0 +1,35 @@
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
+#define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
+#define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
+#define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
+#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)
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

