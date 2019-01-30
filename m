Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFAFC282D6
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCF220869
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SvEqdk7X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfA3Hpa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:45:30 -0500
Received: from mail-oi1-f202.google.com ([209.85.167.202]:57170 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfA3Hpa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:45:30 -0500
Received: by mail-oi1-f202.google.com with SMTP id a62so11864304oii.23
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 23:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gSk9CBvTiJCDvm7KwhFiEgBIDJYi51//IAq1RM0Z+/I=;
        b=SvEqdk7XVMB9mctvFfoAGuL8yIvx9W4j1UwdPDxj63bt4FbxKMuvLEhIDQODmezuXx
         n6cCRyKpa7WebqlduPfrKnxuGdDJEgywXP2eK/Z34SoV7hEsrsUNX2nIJLdEHlko8nqA
         9maSMlhJo1ESwXD+4WGW25P8M/lOsGZvX6QVoqnPYau4wGJZvPHY1gifWkMyU/q9eMw7
         TFzxMuwzX657CnCiajrbEeRWVB1iQeznjCrQPt4vg/u4V1La4vb0uPW32zLCLG1I5Wnc
         CfOdsj0wfe731ayVbNJbKBxp4kmx5jiwuyT2HYS3gwfJq65S2gHLKw9gnJuVzCmiWVkx
         hgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gSk9CBvTiJCDvm7KwhFiEgBIDJYi51//IAq1RM0Z+/I=;
        b=LSCs+ibWM6L8amx8/tDeB2inH/hPXLxjKsZWzVVcr2tqSfquEwWVLW6IDmfaxmHF1y
         TN+RWs7vb/SyCq3QlA4VFWcGi2cyrjbT0d5THvamE9y9h432DhQc2M+ch8a+ZwQMP8dG
         TdObIKAFAbIyQY0Bhr9ig5DGtaRPLJ11Kdbe1iatCRjD1pHKut+6JjcKX9eEVveuC0Zf
         WYhFXRbk1P715sKbF+xZuXq1VAViyxGOiqfknLcZ566juhCwfAJZbtsvDy9mIkjKPjPT
         nwxNep5U9RDyNzl64RAtvpmazUVUxRO2kVWJYAu8AR88O46RVKpTw91pDh19P9u4DKYC
         7dyw==
X-Gm-Message-State: AHQUAuYFdWsYzS36KZi/hUmNGVq9l7OTtmy6QvutrN1MZAjREtydcmQt
        1LvDirqbAtH20uopSiR8rtyZDgksDbUU
X-Google-Smtp-Source: AHgI3IYxXVB5aOhw/o/8DIzsXhm3/mmemjygkPJzarc3V7Eza3T5RI9nl625KSowfcf163fcluKPE/QeIE4f
X-Received: by 2002:a05:6808:654:: with SMTP id z20mr5652506oih.46.1548834328956;
 Tue, 29 Jan 2019 23:45:28 -0800 (PST)
Date:   Wed, 30 Jan 2019 15:45:22 +0800
In-Reply-To: <20190128072948.45788-1-linfish@google.com>
Message-Id: <20190130074522.155770-1-linfish@google.com>
Mime-Version: 1.0
References: <20190128072948.45788-1-linfish@google.com>
X-Mailer: git-send-email 2.20.1.495.gaa96b0ce6b-goog
Subject: [PATCH v2] [media] v4l: add I / P frame min max QP definitions
From:   Fish Lin <linfish@google.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Will Deacon <will.deacon@arm.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Fish Lin <linfish@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add following V4L2 QP parameters for H.264:
 * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP
 * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP
 * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP
 * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP

These controls will limit QP range for intra and inter frame,
provide more manual control to improve video encode quality.

Signed-off-by: Fish Lin <linfish@google.com>
---
Changelog since v1:
- Add description in document.

 .../media/uapi/v4l/extended-controls.rst         | 16 ++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c             |  4 ++++
 include/uapi/linux/v4l2-controls.h               |  6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 286a2dd7ec36..f5989fad34f9 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1214,6 +1214,22 @@ enum v4l2_mpeg_video_h264_entropy_mode -
     Quantization parameter for an B frame for H264. Valid range: from 0
     to 51.
 
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51.
+
 ``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
     Quantization parameter for an I frame for MPEG4. Valid range: from 1
     to 31.
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5e3806feb5d7..e2b0af0d2283 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -825,6 +825,10 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
 								return "H264 Set QP Value for HC Layers";
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP:		return "H264 I-Frame Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP:		return "H264 I-Frame Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP:		return "H264 P-Frame Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP:		return "H264 P-Frame Maximum QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 3dcfc6148f99..9519673e6437 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -533,6 +533,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
 };
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
+
+#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP	(V4L2_CID_MPEG_BASE+390)
+#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP	(V4L2_CID_MPEG_BASE+391)
+#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP	(V4L2_CID_MPEG_BASE+392)
+#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP	(V4L2_CID_MPEG_BASE+393)
+
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
-- 
2.20.1.495.gaa96b0ce6b-goog

