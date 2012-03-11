Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56668 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2CKLts (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 07:49:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: stable@kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH - stable v3.2] omap3isp: ccdc: Fix crash in HS/VS interrupt handler
Date: Sun, 11 Mar 2012 12:50:08 +0100
Message-Id: <1331466608-3277-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HS/VS interrupt handler needs to access the pipeline object. It
erronously tries to get it from the CCDC output video node, which isn't
necessarily included in the pipeline. This leads to a NULL pointer
dereference.

Fix the bug by getting the pipeline object from the CCDC subdev entity.

Reported-by: Gary Thomas <gary@mlbassoc.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/omap3isp/ispccdc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

The patch fixes a v3.2 bug and has been included in v3.3-rc1. Could you please
add it to the stable v3.2 series ?

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 54a4a3f..a319281 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1406,8 +1406,7 @@ static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
 
 static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
-	struct isp_pipeline *pipe =
-		to_isp_pipeline(&ccdc->video_out.video.entity);
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct video_device *vdev = ccdc->subdev.devnode;
 	struct v4l2_event event;
 
-- 
Regards,

Laurent Pinchart

