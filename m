Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbcCXX16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:27:58 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 08/51] v4l: vsp1: VSPD instances have no LUT on Gen3
Date: Fri, 25 Mar 2016 01:27:04 +0200
Message-Id: <1458862067-19525-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the HAS_LUT flag in the corresponding device information entry.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 25750a0e4631..da43e3f35610 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -623,7 +623,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LIF,
 		.rpf_count = 5,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
-- 
2.7.3

