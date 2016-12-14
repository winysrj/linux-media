Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34878 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756053AbcLNPOT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 10:14:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Wed, 14 Dec 2016 13:14:06 -0200
Message-Id: <20161214151406.20380-1-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid calling streamoff without having the media structs allocated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Javier,

Could you please test this patch?

Thanks!
Mauro

 drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 7354469670b7..f60995ed0a1f 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
 			"%s: could not register video device (%d)\n",
 			__func__, ret);
 
+	/* Prevent destroying MC before unregistering */
+	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);
+
 	return ret;
 }
 
 void omap3isp_video_unregister(struct isp_video *video)
 {
-	if (video_is_registered(&video->video))
-		video_unregister_device(&video->video);
+	if (!video_is_registered(&video->video))
+		return;
+
+	video_unregister_device(&video->video);
+	kobject_put(vdev->v4l2_dev->mdev->devnode->dev.parent);
 }
-- 
2.9.3

