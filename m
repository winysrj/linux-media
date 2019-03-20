Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CE9C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 06:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926BA2186A
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 06:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RrE+7YIs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfCTGSx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:18:53 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:33796 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfCTGSx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 02:18:53 -0400
Received: by mail-vs1-f74.google.com with SMTP id c20so458914vse.1
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 23:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cdHDTGNlfyWsemnZDCljVKfP3XmosF6LBAGlpRrli7k=;
        b=RrE+7YIsIFohjx7mAxG71h/TSy+5fywtsAi2WAU24gGvM/BEg8kGBtfBV2ZKx19vJQ
         kLRAvYUaKJB6NM3jL5i5Cx5Kg+NXmUaGaiM8Br12cVsLsjDhl4VZtC5BZGZOpslPd7fP
         IIRpOZWjgo+CV7NHtTHvuCKQ1bnZUiRGMqnKqNgIbUkJDoOyfuJ0+HFxWThfUb2JORtd
         tZ+wFGtFndWjL4ubWpqZeEu4I4ezeuwgQubxqDWJ5hC7diIxGunnbASDqEK58PkuGnLb
         1df3Q3PJQzJ6ev8JaKoir2NAHBcPVG2+60mQeTES9nOZHHreWfw5eVG1ibQafyjvAmTq
         9DgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cdHDTGNlfyWsemnZDCljVKfP3XmosF6LBAGlpRrli7k=;
        b=BJeewxE3UsKVi0JjBhfEtthShieYQipbCCeg5VkYEePfs+jkXzUEGXTpD8CJQJsLQF
         aynS99srP9R4aegucIq5L0j2UqYWYkuwWp0KNmWXr5TRtIY141FnB7Us5WelvzfQsNeA
         YbbJah+XZBrMXJ0Bpqau36mDQIe4ppFTz5paHrWJ0MaPN7VVqA7c7zko161BqqpvCoDh
         dYqhiDzRLfHAjqIKM0FX949MrC5eB+H2k7vh6nL4uFekkeOwSHlvs/RuOTd/UnmOgLcm
         /bYfDBx3b1SNHrUk1WPvB+6wil8cy8zMQ3m2UK9Hmosh/6O/cBk2KZB1kxd6pNFPJKqK
         xtZA==
X-Gm-Message-State: APjAAAVanfl96xVlvQUNJ9Gi9AeQWclmRP/bn/yoSgwhyH+dvqYdQUvf
        f6jINGpaLNqd/sbgvkpKd813D8/tiTOR
X-Google-Smtp-Source: APXvYqxP/8hsSnosRMfpwPA4Fw5aWC6E2rOcpSLTWkGQQYuG2OUu2QK5/ZagmaUygFjDcmoleAvcYRCz1+D3
X-Received: by 2002:a1f:a70a:: with SMTP id q10mr15514992vke.17.1553062731815;
 Tue, 19 Mar 2019 23:18:51 -0700 (PDT)
Date:   Wed, 20 Mar 2019 14:18:45 +0800
In-Reply-To: <20190128072948.45788-1-linfish@google.com>
Message-Id: <20190320061845.144689-1-linfish@google.com>
Mime-Version: 1.0
References: <20190128072948.45788-1-linfish@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v5][media] v4l: add I / P frame min max QP definitions
From:   Fish Lin <linfish@google.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Changelog since v4:
- Fix patch subject and send again.

Changelog since v3:
- Put document in ext-ctrls-codec.rst instead of extended-controls.rst
  (which was previous version).

Changelog since v2:
- Add interaction with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
  description in the document.

Changelog since v1:
- Add description in document.

 .../media/uapi/v4l/ext-ctrls-codec.rst        | 24 +++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  4 ++++
 include/uapi/linux/v4l2-controls.h            |  6 +++++
 3 files changed, 34 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index c97fb7923be5..de60b2e788eb 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1048,6 +1048,30 @@ enum v4l2_mpeg_video_h264_entropy_mode -
     Quantization parameter for an B frame for H264. Valid range: from 0
     to 51.
 
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization parameter
+    should be chosen to meet both requirements.
+
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization parameter
+    should be chosen to meet both requirements.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization parameter
+    should be chosen to meet both requirements.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization parameter
+    should be chosen to meet both requirements.
+
 ``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
     Quantization parameter for an I frame for MPEG4. Valid range: from 1
     to 31.
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..115fb8debe23 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -828,6 +828,10 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
 								return "H264 Constrained Intra Pred";
 	case V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET:	return "H264 Chroma QP Index Offset";
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP:		return "H264 I-Frame Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP:		return "H264 I-Frame Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP:		return "H264 P-Frame Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP:		return "H264 P-Frame Maximum QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 06479f2fb3ae..4421baa84177 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -535,6 +535,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
 #define V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION	(V4L2_CID_MPEG_BASE+383)
 #define V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET		(V4L2_CID_MPEG_BASE+384)
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
2.21.0.360.g471c308f928-goog

