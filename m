Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34520 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbeCTPnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 11:43:14 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] media: uvcvideo: Fix minor spelling
Date: Tue, 20 Mar 2018 15:43:08 +0000
Message-Id: <1521560588-21845-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

Provide the missing 't' from straightforward.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 102594ec3e97..1daf444371be 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1125,7 +1125,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 }
 
 /*
- * Mapping V4L2 controls to UVC controls can be straighforward if done well.
+ * Mapping V4L2 controls to UVC controls can be straightforward if done well.
  * Most of the UVC controls exist in V4L2, and can be mapped directly. Some
  * must be grouped (for instance the Red Balance, Blue Balance and Do White
  * Balance V4L2 controls use the White Balance Component UVC control) or
-- 
2.7.4
