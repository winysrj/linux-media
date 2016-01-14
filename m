Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34448 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbcANIhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 03:37:08 -0500
Received: by mail-pf0-f180.google.com with SMTP id q63so99105886pfb.1
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2016 00:37:07 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com,
	wuchengli@chromium.org, nicolas.dufresne@collabora.com,
	ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	tiffany.lin@mediatek.com, djkurtz@chromium.org
Subject: [PATCH v2 2/2] s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
Date: Thu, 14 Jan 2016 16:33:59 +0800
Message-Id: <1452760439-35564-3-git-send-email-wuchengli@chromium.org>
In-Reply-To: <1452760439-35564-1-git-send-email-wuchengli@chromium.org>
References: <1452760439-35564-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 0434f02..de1d68d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -212,6 +212,15 @@ static struct mfc_control controls[] = {
 		.menu_skip_mask = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME,
+		.type = V4L2_CTRL_TYPE_BUTTON,
+		.name = "Force an I frame",
+		.minimum = 0,
+		.maximum = 0,
+		.step = 0,
+		.default_value = 0,
+	},
+	{
 		.id = V4L2_CID_MPEG_VIDEO_VBV_SIZE,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 0,
@@ -1423,6 +1432,10 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
 		ctx->force_frame_type = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME:
+		ctx->force_frame_type
+			= V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME;
+		break;
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
 		p->vbv_size = ctrl->val;
 		break;
-- 
2.6.0.rc2.230.g3dd15c0

