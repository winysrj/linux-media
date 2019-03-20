Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF41BC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 03:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7438A20857
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 03:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvwfvKFi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfCTDKb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 23:10:31 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:56687 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfCTDKb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 23:10:31 -0400
Received: by mail-pg1-f202.google.com with SMTP id d10so1207052pgv.23
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 20:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p42pV0SCrq58ooliIiJHPKGHiJvIyZQn0fiaDDXUeDE=;
        b=hvwfvKFiq7tn+8Ltbdy+fVGOHDYnnPfy7yNy0xgeotI2i1SLPTj+1dBLvbZ3ic/HfE
         mBcd4/7UeoP7r/TMGQjf35jLfP8054qA8IhG5dTR58ohXro2lhiS9/OJ0rRZGuW4YHsk
         1raqE9piWwsMJdnTBRNUGshgbWvmqvAYN7igu80kXRlAl8y6hTLxegsGq7sSjgA1vOPN
         dwpGXjG+e7vFhWPHH1x6KbGBsxZqT+dTzMmUQTvvi1cTT5hb2r4FaZy5LeNT83S1cP0+
         xufxkZ6/pJsTDFPxQ+UHzyK1YyPe/fEF0Bla+H6E2D8OYPqG6TtRzh59nlcaVPWfFg87
         SRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p42pV0SCrq58ooliIiJHPKGHiJvIyZQn0fiaDDXUeDE=;
        b=uTBrC5piUkD19tMxddtmNZMr4ORQ8Kvr1lI3u3iUQi9XZZbPuwlYN+wMJGa5sehDat
         ggi2TpSJ0wS6vf3NuSyrRy5W7oFVbqw3/UIvymbLp+Nn+3hR1DD74N2Z1x1mQgSK/GlI
         uXwtqs/Zww2LjqowgYh9ssm2RHXPSphKG/aIv2JMaK/NzvVvkh5lQSo9T9cIf2tq84x8
         w/HXcQg0REtAaYOCFMJjf8NNctvNhMIQICP0LOWTiMH60dl+d2OuruAdIOh8eibL6nul
         /NPn//m0qFQgX1GlzGEDEpNnM7IG5wk8X1EOJvMpotBRe2dAXPQHHAAyZ3PnIotRbHnb
         LPoA==
X-Gm-Message-State: APjAAAW8E9BETDmFpfXxYxynHMby8XcfvtSodlBYZUcNxY9zeMHfo4TS
        QnfhvAq21a0XaKEl7NsszQrLlLGZZNPM
X-Google-Smtp-Source: APXvYqzP9hlTwEAopdX8JP9UvODwCwuyPJeDSPx005WHLDV8mbMDPu/mCqDp8lSBihYtJNHP85VfMIJNk+Uo
X-Received: by 2002:a62:ee01:: with SMTP id e1mr8346820pfi.58.1553051430426;
 Tue, 19 Mar 2019 20:10:30 -0700 (PDT)
Date:   Wed, 20 Mar 2019 11:10:22 +0800
Message-Id: <20190320031022.174052-1-linfish@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH] media: v4l-ctrl: add control for variable frame rate
From:   Fish Lin <linfish@google.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Will Deacon <will.deacon@arm.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fish Lin <linfish@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

These flag are added
* V4L2_CID_MPEG_VIDEO_VFR_ENABLE
* V4L2_CID_MPEG_VIDEO_VFR_MIN_FRAMERATE
One is to set variable frame rate enable or not, another is to control
minimal frame rate that video encoder should keep per second.

Signed-off-by: Fish Lin <linfish@google.com>
---
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst | 9 +++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c             | 3 +++
 include/uapi/linux/v4l2-controls.h               | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index c97fb7923be5..4bc013d71b67 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -620,7 +620,16 @@ enum v4l2_mpeg_video_bitrate_mode -
     * - Bit 24:31
       - Must be zero.
 
+.. _v4l2-mpeg-video-variable-framerate:
 
+``V4L2_CID_MPEG_VIDEO_VFR_ENABLE (boolean)``
+    Set variable framerate enable or not. When enabled, video encoder is able
+    to drop frames based on some mechanism, like frame similarity or bitrate
+    control (default disable).
+
+``V4L2_CID_MPEG_VIDEO_VFR_MIN_FRAMERATE (integer)``
+    Minimal kept frame per second when variable framerate is enabled (default
+    is input framerate).
 
 .. _v4l2-mpeg-video-dec-pts:
 
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..566c6552c9a0 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -786,6 +786,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:			return "H264 MB Level Rate Control";
 	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:			return "Sequence Header Mode";
 	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "Max Number of Reference Pics";
+	case V4L2_CID_MPEG_VIDEO_VFR_ENABLE:			return "Variable Frame Rate Enable";
+	case V4L2_CID_MPEG_VIDEO_VFR_MIN_FRAMERATE:		return "VFR Minimal Frame Rate";
 	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:		return "H263 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:		return "H263 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:		return "H263 B-Frame QP Value";
@@ -1108,6 +1110,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
 	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+	case V4L2_CID_MPEG_VIDEO_VFR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 06479f2fb3ae..f1bf52eb0152 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -404,6 +404,9 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 #define V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME		(V4L2_CID_MPEG_BASE+229)
 
+#define V4L2_CID_MPEG_VIDEO_VFR_ENABLE (V4L2_CID_MPEG_BASE + 250)
+#define V4L2_CID_MPEG_VIDEO_VFR_MIN_FRAMERATE (V4L2_CID_MPEG_BASE + 251)
+
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
 #define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+302)
-- 
2.21.0.225.g810b269d1ac-goog

