Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42563 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1IVUPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 16:15:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, g.liakhovetski@gmx.de
Subject: [PATCH 3/4] omap3isp: Add missing mutex_destroy() calls
Date: Thu, 22 Sep 2011 22:15:38 +0200
Message-Id: <1316722539-7372-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1316722539-7372-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1316722539-7372-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mutexes must be destroyed with mutex_destroy(). Add missing calls in the
modules cleanup handlers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c      |    2 ++
 drivers/media/video/omap3isp/ispccdc.c  |    2 ++
 drivers/media/video/omap3isp/ispstat.c  |    1 +
 drivers/media/video/omap3isp/ispvideo.c |    2 ++
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index fda4be0..7b5ab42 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -2183,6 +2183,8 @@ error:
 	regulator_put(isp->isp_csiphy2.vdd);
 	regulator_put(isp->isp_csiphy1.vdd);
 	platform_set_drvdata(pdev, NULL);
+
+	mutex_destroy(&isp->isp_mutex);
 	kfree(isp);
 
 	return ret;
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9ed4d8a..0a68207 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -2295,4 +2295,6 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
 
 	if (ccdc->fpc.fpcaddr != 0)
 		iommu_vfree(isp->iommu, ccdc->fpc.fpcaddr);
+
+	mutex_destroy(&ccdc->ioctl_lock);
 }
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index 253b32f..786f9b0 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -1086,6 +1086,7 @@ int omap3isp_stat_init(struct ispstat *stat, const char *name,
 void omap3isp_stat_cleanup(struct ispstat *stat)
 {
 	media_entity_cleanup(&stat->subdev.entity);
+	mutex_destroy(&stat->ioctl_lock);
 	isp_stat_bufs_free(stat);
 	kfree(stat->buf);
 }
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 910c745..927d496 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -1328,6 +1328,8 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 void omap3isp_video_cleanup(struct isp_video *video)
 {
 	media_entity_cleanup(&video->video.entity);
+	mutex_destroy(&video->stream_lock);
+	mutex_destroy(&video->mutex);
 }
 
 int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
-- 
1.7.3.4

