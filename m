Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C01CC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB2C2148E
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b+KbZXHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfA1HaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 02:30:10 -0500
Received: from mail-qk1-f201.google.com ([209.85.222.201]:37087 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfA1HaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 02:30:09 -0500
Received: by mail-qk1-f201.google.com with SMTP id s70so17454757qks.4
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 23:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=joWT7WTukyZiygiD/CgHZpp0VYKv4t6Bn/aofo7/Geo=;
        b=b+KbZXHyP4Td62tZjTdCyINC8LQugQGhANLirMGXiJFh5oxNbsm7+FfGy6Xo6XRLYM
         FV3KaIR+ai7IqUI/coYjISxjeZbQnfHyQdFvEFfIweUOZ5tUCMAgqqe30u4hTU6fPAvE
         0ekI1WBlm4oA+5c8wdX5scG/dy9EHrhMC4k1MRvFIDBZBPT2uF3fDgiSzBw68loez1Wb
         X0powYJSa/fzwOcTHECLxqpbeWsaOyhL2dp2VkoBnNVILorTzgyIInczc/KQLJZMdFP/
         rV+q5oOvosVIckJe6xgjScQqvW8ioSIxjXB5rQ9RPaPHy9NpMF8tC8AuW6MwLlN+jP3I
         G9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=joWT7WTukyZiygiD/CgHZpp0VYKv4t6Bn/aofo7/Geo=;
        b=gauTG74UK9u9GZdwN4iyBOYI+9c4H8t+BiKaF7MXJbARlfkUagzgzaABp2VgXqulte
         clhAWpnqb3J9S96IHJWUQ8iqgkeLhONJrf1DF+Wg02mVF1Gi34dMyy2oGwo0kTK+2oMn
         idsep7GbAAp1DuHsC+d6ETORGYxpYcntiahR5ZhFr1rwpMEqGVeiuR808DNp9Ejl70UP
         VO61pGqSqgkSp+SolcnNMNC+mwosLCx4RfvKCazlAdLb334QihViRtllsL5selZjVN3j
         RpzPV5Gd+596Yx6ouN45+udOzQagDTCKOro6Xk3shJdDh83lPPnoYSIdLrMfClD2rstN
         950w==
X-Gm-Message-State: AJcUukfyfoWRRzJN+XuhsiDi9LIhtfMHtTcm/I2yzBO1nFgUTXY4nn/Y
        2Ns454RvJjDKj7pa9dRRFe/UVr8XVOn2
X-Google-Smtp-Source: ALg8bN4yDyL4tGxyZhJQlbBML70hQLYBk1jqnJFV9/oSgs8tKKFqrdsiDs2C/c2snVM4Civ7HAnOD1FHDKg1
X-Received: by 2002:ac8:4307:: with SMTP id z7mr15789512qtm.7.1548660608605;
 Sun, 27 Jan 2019 23:30:08 -0800 (PST)
Date:   Mon, 28 Jan 2019 15:29:48 +0800
Message-Id: <20190128072948.45788-1-linfish@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.495.gaa96b0ce6b-goog
Subject: [PATCH] [media] v4l: add I / P frame min max QP definitions
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
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 include/uapi/linux/v4l2-controls.h   | 6 ++++++
 2 files changed, 10 insertions(+)

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

