Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57236 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab1D3N1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:27:41 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9765635995
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:27:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] uvcvideo: Don't report unsupported menu entries
Date: Sat, 30 Apr 2011 15:28:03 +0200
Message-Id: <1304170084-11733-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Supported menu entries are reported by the device in response to the
GET_RES query. Use the information to return -EINVAL to userspace for
unsupported values when enumerating menu entries.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index d6fe13d..0dc2a9f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1015,6 +1015,24 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 	}
 
 	menu_info = &mapping->menu_info[query_menu->index];
+
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES) {
+		s32 bitmap;
+
+		if (!ctrl->cached) {
+			ret = uvc_ctrl_populate_cache(chain, ctrl);
+			if (ret < 0)
+				goto done;
+		}
+
+		bitmap = mapping->get(mapping, UVC_GET_RES,
+				      uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+		if (!(bitmap & menu_info->value)) {
+			ret = -EINVAL;
+			goto done;
+		}
+	}
+
 	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
 
 done:
-- 
1.7.3.4

