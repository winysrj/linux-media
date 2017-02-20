Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60918 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753764AbdBTPWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 10:22:30 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 52961600A3
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 17:22:26 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] omap3isp: Call video_unregister_device() unconditionally
Date: Mon, 20 Feb 2017 17:22:18 +0200
Message-Id: <1487604142-27610-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_unregister_device() can be called on a never or an already
unregistered device. Drop the redundant check.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 218e6d7..9e9b18c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1495,6 +1495,5 @@ int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
 
 void omap3isp_video_unregister(struct isp_video *video)
 {
-	if (video_is_registered(&video->video))
-		video_unregister_device(&video->video);
+	video_unregister_device(&video->video);
 }
-- 
2.1.4
