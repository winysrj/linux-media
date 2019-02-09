Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCD2C282CC
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21CC1218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cu/NPjtA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfBINyt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51358 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfBINys (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so8527323wmj.1
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r+PkD5x0B5yn6BnuNzNf76A/xb2UQi58Lhz9X4qYgys=;
        b=Cu/NPjtAEjZDZO1NSM4bHQdSm8b25LYmwifFO4q/u+uMJIG4REP1H/t33eTsbAYcc9
         G8TONXN5MkjzZIFYdcpxuefPSofARZQCAYCYDg4CMutWpfTeYmllGtw5agSA78g258qt
         FSRI+7OkWs+gACJtMkYM5RCyeyneLwzkH2IUp50fj+upcDXiKNgmY+BHbUDk91MNzZv2
         8obvB0a2+qpvkFXIbF5XuVOZXRRaXDhOCEUXFRl/gY8n97rRXUiUY5mQSnRyeAN1VjDL
         E8lVfZYyOkiKCpU2Yvey6R5gxk5jr+6AuL7OrtjzTMVOc5WA9XM7QS8Bnt1C/DiEEjtr
         Kf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r+PkD5x0B5yn6BnuNzNf76A/xb2UQi58Lhz9X4qYgys=;
        b=uLcdeYyMxRR35JT1p7RiC2aozWkFEji7TrmuvRbOGN4P0/LeL6XxfPWZu1c3iyVZdA
         bVRvuUKBs7Dq9cEi79ZBQg+gC+vbyFyNjv5Trr4kjRjJDIJEaAD0OB+bAihRj5rIT1SH
         SSGcRsvQzwTn2OC8LAgNA+pSGUYxcOXXSmAkpfIPomiyqrgQX/EiKeYCVVv2rux4MVCx
         RV2dfGzrLU5orOE5Llupxzw4a2siP6+KbCV1xBwUhcPDle9dJrWWk6XXNZevU/CVp2aU
         Sgoqxxe5WE/umPEO692zaahIrgudwWSgAWCh5aVYG9Ul1AnXbdiRuwpk9D8HFnHwtiBT
         hFGw==
X-Gm-Message-State: AHQUAubfcydbA+lGQULcoPZyXMSLxV/+nAKpxMrVPToKEa3ZjEeIenL9
        iNWAAXD3xlfhEc+5MJlTaRUQu8f+lAg=
X-Google-Smtp-Source: AHgI3Ibz1pErOSlNX53hp/Zrny7sxCm89+kTLhYKVe9HtiaOvxQjnMIRSZimVPtNcKcci+DzQHmsLQ==
X-Received: by 2002:adf:e949:: with SMTP id m9mr5480749wrn.1.1549720484895;
        Sat, 09 Feb 2019 05:54:44 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:44 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 5/9] media: vicodec: Introducing stateless fwht defs and structs
Date:   Sat,  9 Feb 2019 05:54:23 -0800
Message-Id: <20190209135427.20630-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add structs and definitions needed to implement stateless
decoder for fwht.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  6 ++++++
 include/uapi/linux/v4l2-controls.h            | 12 ++++++++++++
 include/uapi/linux/videodev2.h                |  1 +
 4 files changed, 31 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index e5987229c5a3..95276c09cb9a 100644
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
@@ -1480,6 +1484,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 #define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
 #define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
 #define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
+#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)
 
 static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -1526,6 +1531,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
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
index 99308dac2daa..b05e51312430 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1669,6 +1669,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		return 0;
 
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2249,6 +2252,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
 		break;
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		elem_size = sizeof(struct v4l2_ctrl_fwht_params);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 06479f2fb3ae..aa2d48a2722f 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -52,6 +52,7 @@
 
 #include <linux/types.h>
 
+#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
@@ -1096,4 +1097,15 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+struct v4l2_ctrl_fwht_params {
+	__u64 backward_ref_ts;
+	__u32 width;
+	__u32 height;
+	__u32 flags;
+	__u32 colorspace;
+	__u32 xfer_func;
+	__u32 ycbcr_enc;
+	__u32 quantization;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9a920f071ff9..37ac240eba01 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -665,6 +665,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
 #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC aka H.265 */
 #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast Walsh Hadamard Transform (vicodec) */
+#define V4L2_PIX_FMT_FWHT_STATELESS     v4l2_fourcc('S', 'F', 'W', 'H') /* Stateless FWHT (vicodec) */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
2.17.1

