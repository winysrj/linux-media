Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734E1C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27DE720855
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lisden-com.20150623.gappssmtp.com header.i=@lisden-com.20150623.gappssmtp.com header.b="1Hl1grnS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27DE720855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lisden.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbeLJOMa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 09:12:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56056 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbeLJOMa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 09:12:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id y139so11017426wmc.5
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 06:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lisden-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ytZ1LB2XZxTRoqDIRdYnOQDgUbRzCeab3R21bnli5UE=;
        b=1Hl1grnSx/p2d9HxiPBQSRbzbbTIWmJlMyCV6ettG0HDyPZ3vSoyhDeHqQSP+vYiiX
         6EmnBRupf7TYRE2h1njU/LSj3z0/Pih7UlpeIAMgpkvUfxqDJgCBYakz6iRgG3BVL4OK
         IkDLv4ZiSMgBXWq06f51fHKh+rNo1G1Wz77gsT/46MJGVyuNrgIPT6L8Xu+SLZWAkxgo
         NOAhBT7k6g93Mm1oerslPwvLX/P/L6ac5b5fqi/AhW9DJL0DQfrecrHOsFaxuNmQhGTk
         hiCDl0Mj4eDJsJzAEdupTfcBlmJ79HyR+QbvDloQbMvgWCPH3npSvs4uOV1esetXltiB
         d5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ytZ1LB2XZxTRoqDIRdYnOQDgUbRzCeab3R21bnli5UE=;
        b=Qudxw9W8zJmHW4SX722HhkP89UZ8/srRgip5dJG1koHg5yX4gL3JqoXPXRbdZM22my
         oD1501j1NVzUk8aSrbPhofkc8I8PzjlsUpmX7SshdRdx5PbFDKUq3YjjsPfh5KTaQVO/
         nu6i2AAJaBPoigWlNDSJjUavjohh0ok1PCEEoDOU4KomVDshbiWXex7W7h02lpT1KwxB
         KnUl1sVvXx0VK6L1UnNXo3Lz8+ZcRsOReCsmV9v4x5BIqu7bhhJOH+glZUFmmpVBENEe
         rMF5Y27zU30tzaTvj1bCousKcNjKX8ly/gDu19yoAhMAFvimCkiIwofnff6WOpdy0WrZ
         TnfA==
X-Gm-Message-State: AA+aEWYTHc8AlMqpLmpDRezB981JYRAIgL2KjqNQyWDM+K+oaSkqku4i
        jid6HCbKjFlPmoy1UxscHuz5eQo/YCKkmw==
X-Google-Smtp-Source: AFSGD/U0tvFEuA2tcn6TOiYxwtWt47g19NskSWFY9mbYDONqz/ykVeKp7NjiFiMy5HfkWI9YLw4HEQ==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr11271659wmj.90.1544451148461;
        Mon, 10 Dec 2018 06:12:28 -0800 (PST)
Received: from precision5510.lan (dsl-217-155-248-78.zen.co.uk. [217.155.248.78])
        by smtp.gmail.com with ESMTPSA id o64sm21056402wmo.47.2018.12.10.06.12.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 10 Dec 2018 06:12:27 -0800 (PST)
From:   Kelvin Lawson <klawson@lisden.com>
To:     linux-media@vger.kernel.org, stanimir.varbanov@linaro.org
Cc:     Kelvin Lawson <klawson@lisden.com>
Subject: [PATCH v2] media: venus: Add support for H265 controls required by gstreamer V4L2 H265 module.
Date:   Mon, 10 Dec 2018 14:11:45 +0000
Message-Id: <1544451105-17406-1-git-send-email-klawson@lisden.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <19f7304f-4a88-339f-faa2-2fac5a3b6b76@linaro.org>
References: <19f7304f-4a88-339f-faa2-2fac5a3b6b76@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for controls required by gstreamer V4L2 H265 encoder module:
 * V4L2_CID_MPEG_VIDEO_HEVC_PROFILE
 * V4L2_CID_MPEG_VIDEO_HEVC_LEVEL

Signed-off-by: Kelvin Lawson <klawson@lisden.com>
---
 drivers/media/platform/qcom/venus/venc_ctrls.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index 45910172..0b845d5 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -101,6 +101,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		ctr->profile.h264 = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+		ctr->profile.hevc = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
 		ctr->profile.vpx = ctrl->val;
 		break;
@@ -110,6 +113,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
 		ctr->level.h264 = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+		ctr->level.hevc = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
 		ctr->h264_i_qp = ctrl->val;
 		break;
@@ -188,7 +194,7 @@ int venc_ctrl_init(struct venus_inst *inst)
 {
 	int ret;
 
-	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 27);
+	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 29);
 	if (ret)
 		return ret;
 
@@ -217,6 +223,19 @@ int venc_ctrl_init(struct venus_inst *inst)
 		0, V4L2_MPEG_VIDEO_MPEG4_LEVEL_0);
 
 	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
+		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10,
+		~((1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN) |
+		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE) |
+		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10)),
+		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
+		V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2,
+		0, V4L2_MPEG_VIDEO_HEVC_LEVEL_1);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH,
 		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
-- 
2.7.4

