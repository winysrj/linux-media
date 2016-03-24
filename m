Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcCXX2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:01 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 10/51] v4l: vsp1: Always setup the display list
Date: Fri, 25 Mar 2016 01:27:06 +0200
Message-Id: <1458862067-19525-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure display list usage is correctly disabled by always setting up
the corresponding registers, including when the display list feature
isn't used.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c  | 7 +++----
 drivers/media/platform/vsp1/vsp1_drv.c | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 3bdd002a9c80..7f9fe09af92d 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -243,15 +243,14 @@ done:
 
 void vsp1_dl_setup(struct vsp1_device *vsp1)
 {
-	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
-		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
-		 | VI6_DL_CTRL_DLE;
+	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT);
 
 	/* The DRM pipeline operates with header-less display lists in
 	 * Continuous Frame Mode.
 	 */
 	if (vsp1->drm)
-		ctrl |= VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
+		ctrl |= VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
+		     |  VI6_DL_CTRL_DLE | VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
 
 	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
 	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 58632d766a2a..d657949bac3b 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -462,8 +462,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
-	if (!vsp1->info->uapi)
-		vsp1_dl_setup(vsp1);
+	vsp1_dl_setup(vsp1);
 
 	return 0;
 }
-- 
2.7.3

