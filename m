Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6F5C282C8
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0952121872
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKDpdLLD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfAZNsb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 26 Jan 2019 08:48:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34283 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfAZNsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Jan 2019 08:48:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id f7so13131053wrp.1
        for <linux-media@vger.kernel.org>; Sat, 26 Jan 2019 05:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i47IMir6jaSLQY+1ia8DgoDnuwHx6DHK/RUnEHvoh9Q=;
        b=UKDpdLLDahhG+5D7rYyxVjTwxJhfhwqwDD4yTmVXaldpDDN1fXpy81rnQ+/MeK3y2A
         HiuSq3S0TEiKV2E0FQM3Hl/m34tiktuKm7EK9JiifaDr+rbbAWsp+fjs9cgaAjyGhnOV
         iSxUzbYRhKSLDP64vKHBSmiGu5Yzc6SGtiHH52FIBRjkynP06VldD8eJ53yktj3i6+p0
         eHIT4OC6+4Dt8zuCYbV13tOqvtVKaxssxnsmWXH2lxQAffvurJHlB7GfXtYPBLOFfUaM
         iPO55fHzRbyu/f6g4LV2fubCVsTNXot8/KnSkywQL/Mb4MYAZg7Go0zDwBbFi4YrDfUg
         ww2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i47IMir6jaSLQY+1ia8DgoDnuwHx6DHK/RUnEHvoh9Q=;
        b=Gc4eemhb4fmqbTSGzgBqIBsCLJISGsszZprGXDTGxeFpGuxEHZO7g2Uy6puZfO7Mh7
         7G0HPrHtJcfDVxukknGDxkNaS5yfFoCxr5FJRUV6EUqW8VL4PsS7nSUSBxh3KHso6lRI
         fzKBt7WW/ko68F9i5esRarGBoS4sHko7NqRsD558HdE0kUlzhe/lqifue4AIBvB3sD97
         QJjWk87ky4UpuSQAllz2w4eOkCBg9ZjhQ0vB6VYCTWieqUEhD4pFh7cmcPX2lQe2JVxD
         +5P6TkaD/Qayz6h2gSU5ulrjiatUJi+CsuqfphomL4wzcT7Wa0d+eoBmPScOpLoKodFD
         NTHg==
X-Gm-Message-State: AHQUAuZEfkHKkkYTW5rHoFxB8DxUWhBMpzTsvhX72BkxqPJQmQnOVLaG
        n6xbP4oRQpX6QtD7PtkJY14gLFTz204=
X-Google-Smtp-Source: AHgI3IYuQo1agyo3Cg9SAhiOoM2JA1L3z8wHqN89bmLL+7Hu3e4oNzc63K91Se7feOs6nD9srek3iA==
X-Received: by 2002:a05:6000:11c3:: with SMTP id i3mr10571910wrx.221.1548510507941;
        Sat, 26 Jan 2019 05:48:27 -0800 (PST)
Received: from ubuntu.home ([77.124.106.231])
        by smtp.gmail.com with ESMTPSA id v6sm101552298wrd.88.2019.01.26.05.48.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jan 2019 05:48:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 2/3] media: vicodec: Introducing stateless fwht defs and structs
Date:   Sat, 26 Jan 2019 05:47:58 -0800
Message-Id: <20190126134759.97680-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190126134759.97680-1-dafna3@gmail.com>
References: <20190126134759.97680-1-dafna3@gmail.com>
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
 include/uapi/linux/v4l2-controls.h            | 10 ++++++++++
 include/uapi/linux/videodev2.h                |  1 +
 4 files changed, 29 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 370517707324..25831d992681 100644
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
@@ -1463,6 +1467,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 #define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
 #define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
 #define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
+#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)
 
 static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -1509,6 +1514,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
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
index 06479f2fb3ae..2d6e91cb615a 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -52,6 +52,7 @@
 
 #include <linux/types.h>
 
+#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
@@ -1096,4 +1097,13 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+struct v4l2_ctrl_fwht_params {
+	__u32 flags;
+	__u32 colorspace;
+	__u32 xfer_func;
+	__u32 ycbcr_enc;
+	__u32 quantization;
+	__u64 backward_ref_ts;
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

