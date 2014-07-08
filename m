Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47677 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaGHOav (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 10:30:51 -0400
Received: by mail-lb0-f176.google.com with SMTP id w7so4036318lbi.35
        for <linux-media@vger.kernel.org>; Tue, 08 Jul 2014 07:30:50 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
	ismael.luceno@corp.bluecherry.net,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH 2/2] solo6x10: update GOP size, QP immediately
Date: Tue,  8 Jul 2014 17:30:34 +0300
Message-Id: <1404829834-8747-2-git-send-email-andrey.utkin@corp.bluecherry.net>
In-Reply-To: <1404829834-8747-1-git-send-email-andrey.utkin@corp.bluecherry.net>
References: <1404829834-8747-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, it was needed to reopen device to update GOP size and
quantization parameter. Now we update device registers with new values
immediately.
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index bf6eb06..14f933f 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1110,9 +1110,13 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 					 ctrl->val);
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
+		solo_reg_write(solo_dev, SOLO_VE_CH_GOP(solo_enc->ch), solo_enc->gop);
+		solo_reg_write(solo_dev, SOLO_VE_CH_GOP_E(solo_enc->ch), solo_enc->gop);
 		return 0;
 	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
 		solo_enc->qp = ctrl->val;
+		solo_reg_write(solo_dev, SOLO_VE_CH_QP(solo_enc->ch), solo_enc->qp);
+		solo_reg_write(solo_dev, SOLO_VE_CH_QP_E(solo_enc->ch), solo_enc->qp);
 		return 0;
 	case V4L2_CID_MOTION_THRESHOLD:
 		solo_enc->motion_thresh = ctrl->val;
-- 
1.8.3.2

