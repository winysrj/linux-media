Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46464 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752129AbdGMPXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:52 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CB647600C8
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:48 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 2/6] omap3isp: Call video_unregister_device() unconditionally
Date: Thu, 13 Jul 2017 18:23:45 +0300
Message-Id: <20170713152349.14480-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
References: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_unregister_device() can be called on a never or an already
unregistered device. Drop the redundant check.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 218e6d7ae93a..9e9b18c217bd 100644
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
2.11.0
