Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55312 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1KPUGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:06:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/4] omap3isp: Fix crash caused by subdevs now having a pointer to devnodes
Date: Wed, 16 Nov 2011 21:06:45 +0100
Message-Id: <1321474006-24589-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 3e0ec41c5c5ee14e27f65e28d4a616de34f59a97 ("V4L: dynamically
allocate video_device nodes in subdevices") makes the
v4l2_subdev::devnode field a pointer to a struct video_device instead of
embedding video_device directly.

Fix accesses to the devnode accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c |    2 +-
 drivers/media/video/omap3isp/ispstat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9012b57..a319281 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1407,7 +1407,7 @@ static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
 static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
-	struct video_device *vdev = &ccdc->subdev.devnode;
+	struct video_device *vdev = ccdc->subdev.devnode;
 	struct v4l2_event event;
 
 	memset(&event, 0, sizeof(event));
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index 68d5394..bc0b2c7 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -496,7 +496,7 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 
 static void isp_stat_queue_event(struct ispstat *stat, int err)
 {
-	struct video_device *vdev = &stat->subdev.devnode;
+	struct video_device *vdev = stat->subdev.devnode;
 	struct v4l2_event event;
 	struct omap3isp_stat_event_status *status = (void *)event.u.data;
 
-- 
1.7.3.4

