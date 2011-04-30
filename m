Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57237 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1D3N1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:27:41 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CF8953599C
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:27:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Return -ERANGE when userspace sets an unsupported menu entry
Date: Sat, 30 Apr 2011 15:28:04 +0200
Message-Id: <1304170084-11733-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170084-11733-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1304170084-11733-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of passing the value down to the device and getting an error
back (or worse, crashing the firmware), return -ERANGE when the
requested menu entry is not supported.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 0dc2a9f..a4db26f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1221,6 +1221,23 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 		if (xctrl->value < 0 || xctrl->value >= mapping->menu_count)
 			return -ERANGE;
 		value = mapping->menu_info[xctrl->value].value;
+
+		/* Valid menu indices are reported by the GET_RES request for
+		 * UVC controls that support it.
+		 */
+		if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES) {
+			if (!ctrl->cached) {
+				ret = uvc_ctrl_populate_cache(chain, ctrl);
+				if (ret < 0)
+					return ret;
+			}
+
+			step = mapping->get(mapping, UVC_GET_RES,
+					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+			if (!(step & value))
+				return -ERANGE;
+		}
+
 		break;
 
 	default:
-- 
1.7.3.4

