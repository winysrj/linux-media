Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33017 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [RFC PATCH 12/26] [media] v4l2: Fix V4L2_CID_PIXEL_RATE
Date: Thu, 12 Jun 2014 19:06:26 +0200
Message-Id: <1402592800-2925-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 55c6832..6a6ccc5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1048,7 +1048,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PIXEL_RATE:
 		*type = V4L2_CTRL_TYPE_INTEGER64;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
-		*min = *max = *step = *def = 0;
+		*min = *max = *step = 0;
 		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
@@ -1710,7 +1710,11 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		ctrl->qmenu_int = qmenu_int;
 	ctrl->priv = priv;
-	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
+
+	if (type == V4L2_CTRL_TYPE_INTEGER64)
+		ctrl->val64 = ctrl->cur.val64 = def;
+	else
+		ctrl->cur.val = ctrl->val = ctrl->default_value = def;
 
 	if (ctrl->type == V4L2_CTRL_TYPE_STRING) {
 		ctrl->cur.string = (char *)&ctrl[1] + sz_extra - (max + 1);
-- 
2.0.0.rc2

