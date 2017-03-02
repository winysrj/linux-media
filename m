Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdCBLGO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 06:06:14 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] v4l: vsp1: Fix struct vsp1_drm documentation
Date: Thu,  2 Mar 2017 10:12:22 +0000
Message-Id: <1488449542-28990-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct vsp1_drm references a member 'planes' which doesn't exist.
Correctly identify this documentation against the 'inputs'

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 9e28ab9254ba..c8d2f88fc483 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -21,7 +21,7 @@
  * vsp1_drm - State for the API exposed to the DRM driver
  * @pipe: the VSP1 pipeline used for display
  * @num_inputs: number of active pipeline inputs at the beginning of an update
- * @planes: source crop rectangle, destination compose rectangle and z-order
+ * @inputs: source crop rectangle, destination compose rectangle and z-order
  *	position for every input
  */
 struct vsp1_drm {
-- 
2.7.4
