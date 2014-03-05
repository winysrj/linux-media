Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40009 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaCETWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:22:42 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/6] v4l: vsp1: uds: Enable scaling of alpha layer
Date: Wed,  5 Mar 2014 20:24:01 +0100
Message-Id: <1394047444-30077-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Scaling of the alpha layer is disabled as both the RPF and WPF are
configured to hardcode the alpha value to 255. This results in a 0 alpha
value at the UDS output, making the image invisible when alpha blended
in the BRU. Fix it by enabling scaling of the alpha layer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_uds.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 509c9fe..137299c 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -131,7 +131,7 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
 		return 0;
 
 	/* Enable multi-tap scaling. */
-	vsp1_uds_write(uds, VI6_UDS_CTRL, VI6_UDS_CTRL_BC);
+	vsp1_uds_write(uds, VI6_UDS_CTRL, VI6_UDS_CTRL_AON | VI6_UDS_CTRL_BC);
 
 	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(uds->hscale)
@@ -139,7 +139,6 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (uds_passband_width(uds->vscale)
 				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
 
-
 	/* Set the scaling ratios and the output size. */
 	format = &uds->entity.formats[UDS_PAD_SOURCE];
 
-- 
1.8.3.2

