Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42606C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E63921A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyRink0r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfBONGa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:30 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34909 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfBONGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:30 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so9578231wmt.0
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KeknfBqFeBZyNAP9gPLysjYNHEjiYF8WepJ/U7CN7mU=;
        b=OyRink0rrrU+101Tq1oc5QMuoEL4M/zN2mjqfK/RwGuTQuz97nL1JbVSnBT+NbEXkC
         Bqn3qwscE8x+wrYWsWNppGHRReefWSpYCECVE20a4wMmi6l3nig3HlcjLPrtvPcpyaac
         QNJg4LqV/j4wYEeO7LD0ouyChe9F0JfmEAqIVMQLdv09K0xvKEOn+z9BwLXs8tFY8XAw
         G5w3a8Ho0yA4trUx5vzoW585/9von3tNP+ObVPnAnE3KJH+VJc0lhLWo5+jrMSjlp3Mv
         JlfMyo4J9CiRM4FPcTjQc1Og/Wri/GS/QONDUgWAQtvEqnqZckTEBRGAgZYTkllefGah
         easg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KeknfBqFeBZyNAP9gPLysjYNHEjiYF8WepJ/U7CN7mU=;
        b=Kzku1Is4+5vuLHbVF8XY+V/Jri9rtp3AnaiPitzlh/AQQMzJ0hY0Lq3PV+E98m4n/K
         Z5gUwx+ITth5Xp24NsAqjd/3wWOvNS/c5Uv2yeCg86YQTBA5Y/TKu+gT5js0ZpyspI43
         dMcceCTarCWIRB97Cz5qascefPsM6N0FoQeEQeY9zVOIQD/URJvDxt/lCUcLDiIm6Xms
         9EtNQCmskXtHAth6GfnDuyDM1BMDv/wGwxCiKnYnvhl+9SZAeffXSHJNQVSZtUZimE/y
         5R38SC/FgVMiTAzXC/DSRVAH+D/9PnyWodLRyzGq8+8vV2EW3iOLfXO8SPMSQ7OcIVpT
         9Upg==
X-Gm-Message-State: AHQUAuZoZbziiYTtc0Moro2kkjFlbkhHMsmseCGMIxtBm5Yi4t8/yxc6
        5lSdlWs9ZdbKnTQLfvyutgnBtmP1sxQ=
X-Google-Smtp-Source: AHgI3Ibx4Vy3IrvnvxOnSHisqebOv5GjtLlS4LSiYyz04GhtpJA8OV8AEnDHyXaJi6Bs3BP0G20drA==
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr4513919wmg.144.1550235986995;
        Fri, 15 Feb 2019 05:06:26 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:26 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 06/10] media: vicodec: Introducing stateless fwht defs and structs
Date:   Fri, 15 Feb 2019 05:05:06 -0800
Message-Id: <20190215130509.86290-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
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
 include/uapi/linux/v4l2-controls.h            | 13 +++++++++++++
 include/uapi/linux/videodev2.h                |  1 +
 4 files changed, 32 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 5e5bbc99a8bb..79b69faf3983 100644
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
index ff75f84011f8..5f2382f3a1a2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1671,6 +1671,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
 		return 0;
 
+	case V4L2_CTRL_TYPE_FWHT_PARAMS:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2251,6 +2254,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
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
index 06479f2fb3ae..0358a3b22391 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -52,6 +52,7 @@
 
 #include <linux/types.h>
 
+#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
@@ -1096,4 +1097,16 @@ enum v4l2_detect_md_mode {
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
+	__u32 comp_frame_size;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index a78bfdc1df97..6a692114e989 100644
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

