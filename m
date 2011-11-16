Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1KPUGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:06:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/4] omap3isp: ccdc: Fix crash in HS/VS interrupt handler
Date: Wed, 16 Nov 2011 21:06:44 +0100
Message-Id: <1321474006-24589-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HS/VS interrupt handler needs to access the pipeline object. It
erronously tries to get it from the CCDC output video node, which isn't
necessarily included in the pipeline. This leads to a NULL pointer
dereference.

Fix the bug by getting the pipeline object from the CCDC subdev entity.

Reported-by: Gary Thomas <gary@mlbassoc.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index b0b0fa5..9012b57 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1406,8 +1406,7 @@ static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
 
 static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
-	struct isp_pipeline *pipe =
-		to_isp_pipeline(&ccdc->video_out.video.entity);
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct video_device *vdev = &ccdc->subdev.devnode;
 	struct v4l2_event event;
 
-- 
1.7.3.4

