Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF85DC282D5
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956D62087F
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9Yr9B+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfA3JLZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:11:25 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:47957 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfA3JLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 04:11:24 -0500
Received: by mail-qk1-f202.google.com with SMTP id z68so24896293qkb.14
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 01:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zy9e2OcfeDBWVqsvNM95yzGG2K2LaNzQTlHttzXdMkg=;
        b=i9Yr9B+DNw8il9rBbwxCxknVWUG5dcl+LQL4AQrAIh/GJqrUNxA4RWziRuTpoc85Ju
         FZedk3cZ1QEsC40Tzb6d5N2TbRALr1BlpZpLrWlm5JWre5LYF1laXUS/33q+CndxsMgo
         m2EHfU802K3sApIAG5YYlPXbOfB6utbtK0b60Dh0YsHRpFureHYYFnDu+SyWil4IR+X9
         halWkYRvbpolC8cWdGm8e/JuN9dhMZkHUpshN+6ORSzvat8v+nc74vs6w42/ZlfSr0l5
         MfaizNF6onP9e6Dy9Uu4GZ4eNAqvzMtk3g5OFDv6/JyVCsY39jN2nWkRljzgptBuitwo
         c39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zy9e2OcfeDBWVqsvNM95yzGG2K2LaNzQTlHttzXdMkg=;
        b=uT5uD1lEuR1mA7dBBP2r1i7yKnQvPfBNLYLK+D32E35wxqE1u90YwDUWVg091m1wrJ
         n0VRxnA9NsAHWP6sXh8MTcpnMMIrgWrY8p/rGbNwDUhDXSy1p/4/a5YDKKUOkm8jB9qt
         L1skP1z8lns/sv0uOF1SSUgw/B1A9s2VvN8+5wJBCq3+03qbIphrvOtbETDcfbE6Wsxj
         4cRzOj3A9C+yLZjPtcF6XKcWtyiVkeOWsa7tSbh/lOcOfZRRMQAzoBDhttEicrc1C4SA
         KFXPTR0dkyZnd0U3QiaR3CVKMwUqW34IEYpYgwWElWWOdAVmA3G9wJYzD+JJV3Uj+K0b
         Om4g==
X-Gm-Message-State: AHQUAuZDU2qn45e4h0PcBnZ8l3T4Yk7BspYHlpR0xi101wwMkHF2Kxn1
        oCapd2En6Rz0c1zFaPTXO8RT5uBdHLn0
X-Google-Smtp-Source: AHgI3IY6WMovQ38JgsKP4PimdCYg6tFW4HI8dp7oobN477xbSnhzKYFt6+IWm3prs/W2Lshh9UFv3I3EfmTX
X-Received: by 2002:a37:4d55:: with SMTP id a82mr5257217qkb.41.1548839483302;
 Wed, 30 Jan 2019 01:11:23 -0800 (PST)
Date:   Wed, 30 Jan 2019 17:11:16 +0800
In-Reply-To: <20190128072948.45788-1-linfish@google.com>
Message-Id: <20190130091116.256989-1-linfish@google.com>
Mime-Version: 1.0
References: <20190128072948.45788-1-linfish@google.com>
X-Mailer: git-send-email 2.20.1.495.gaa96b0ce6b-goog
Subject: [PATCH v3] [media] v4l: add I / P frame min max QP definitions
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
Changelog since v2:
- Add interaction with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
  description in the document.

Changelog since v1:
- Add description in document.

 .../media/uapi/v4l/extended-controls.rst      | 24 +++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  4 ++++
 include/uapi/linux/v4l2-controls.h            |  6 +++++
 3 files changed, 34 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 286a2dd7ec36..402e41eb24ee 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1214,6 +1214,30 @@ enum v4l2_mpeg_video_h264_entropy_mode -
     Quantization parameter for an B frame for H264. Valid range: from 0
     to 51.
 
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is set, the quantization parameter
+    should be chosen to meet both of the requirement.
+
+``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 I frame, to limit I frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is set, the quantization parameter
+    should be chosen to meet both of the requirement.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
+    Minimum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is set, the quantization parameter
+    should be chosen to meet both of the requirement.
+
+``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
+    Maximum quantization parameter for H264 P frame, to limit P frame
+    quality in a range. Valid range: from 0 to 51. If
+    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is set, the quantization parameter
+    should be chosen to meet both of the requirement.
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

