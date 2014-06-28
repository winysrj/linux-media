Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46188 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaF1SOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jun 2014 14:14:04 -0400
Received: by mail-lb0-f177.google.com with SMTP id u10so4876809lbd.36
        for <linux-media@vger.kernel.org>; Sat, 28 Jun 2014 11:14:02 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] solo6x10: expose qp setting
Date: Sat, 28 Jun 2014 21:13:37 +0300
Message-Id: <1403979218-4928-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello to all. In my opinion solo6x10 driver in upstream kernel gets less love than it deserves from us, and i hope to change that. I am a new employee developer in Bluecherry, unfortunately inexperienced in kernel field. I would be thankful a lot if I get some advices or even guidance to maintain this driver in a good way.
With sending these trivial patches I hope to start a long-lasting cooperation to end up with nicely working driver having good reputation in mainline kernel.

Also you can contact me for any issues related to solo6x10 cards.
---8<---

---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index b8ff113..bf6eb06 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1111,6 +1111,9 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		solo_enc->qp = ctrl->val;
+		return 0;
 	case V4L2_CID_MOTION_THRESHOLD:
 		solo_enc->motion_thresh = ctrl->val;
 		if (!solo_enc->motion_global || !solo_enc->motion_enabled)
@@ -1260,6 +1263,8 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 31, 1, SOLO_DEFAULT_QP);
 	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
 	v4l2_ctrl_new_custom(hdl, &solo_motion_enable_ctrl, NULL);
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
-- 
1.8.3.2

