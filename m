Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32826 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380Ab3FKKuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 06:50:55 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: s.nawrocki@samsung.com
Cc: prabhakar.csengg@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Subject: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after unregistering subdev
Date: Tue, 11 Jun 2013 13:50:49 +0300
Message-Id: <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_entity_cleanup() frees the links array which will be accessed by
media_entity_remove_links() called by v4l2_device_unregister_subdev().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    4 ++--
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    4 ++--
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   14 +++++++-------
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 05673ed..766a071 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1751,10 +1751,10 @@ static const struct media_entity_operations ipipe_media_ops = {
  */
 void vpfe_ipipe_unregister_entities(struct vpfe_ipipe_device *vpfe_ipipe)
 {
-	/* cleanup entity */
-	media_entity_cleanup(&vpfe_ipipe->subdev.entity);
 	/* unregister subdev */
 	v4l2_device_unregister_subdev(&vpfe_ipipe->subdev);
+	/* cleanup entity */
+	media_entity_cleanup(&vpfe_ipipe->subdev.entity);
 }
 
 /*
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index b2f4ef8..59540cd 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -947,10 +947,10 @@ void vpfe_ipipeif_unregister_entities(struct vpfe_ipipeif_device *ipipeif)
 	/* unregister video device */
 	vpfe_video_unregister(&ipipeif->video_in);
 
-	/* cleanup entity */
-	media_entity_cleanup(&ipipeif->subdev.entity);
 	/* unregister subdev */
 	v4l2_device_unregister_subdev(&ipipeif->subdev);
+	/* cleanup entity */
+	media_entity_cleanup(&ipipeif->subdev.entity);
 }
 
 int
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 5829360..ff48fce 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1750,10 +1750,10 @@ static const struct media_entity_operations isif_media_ops = {
 void vpfe_isif_unregister_entities(struct vpfe_isif_device *isif)
 {
 	vpfe_video_unregister(&isif->video_out);
-	/* cleanup entity */
-	media_entity_cleanup(&isif->subdev.entity);
 	/* unregister subdev */
 	v4l2_device_unregister_subdev(&isif->subdev);
+	/* cleanup entity */
+	media_entity_cleanup(&isif->subdev.entity);
 }
 
 static void isif_restore_defaults(struct vpfe_isif_device *isif)
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 126f84c..8e13bd4 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1777,14 +1777,14 @@ void vpfe_resizer_unregister_entities(struct vpfe_resizer_device *vpfe_rsz)
 	vpfe_video_unregister(&vpfe_rsz->resizer_a.video_out);
 	vpfe_video_unregister(&vpfe_rsz->resizer_b.video_out);
 
-	/* cleanup entity */
-	media_entity_cleanup(&vpfe_rsz->crop_resizer.subdev.entity);
-	media_entity_cleanup(&vpfe_rsz->resizer_a.subdev.entity);
-	media_entity_cleanup(&vpfe_rsz->resizer_b.subdev.entity);
 	/* unregister subdev */
 	v4l2_device_unregister_subdev(&vpfe_rsz->crop_resizer.subdev);
 	v4l2_device_unregister_subdev(&vpfe_rsz->resizer_a.subdev);
 	v4l2_device_unregister_subdev(&vpfe_rsz->resizer_b.subdev);
+	/* cleanup entity */
+	media_entity_cleanup(&vpfe_rsz->crop_resizer.subdev.entity);
+	media_entity_cleanup(&vpfe_rsz->resizer_a.subdev.entity);
+	media_entity_cleanup(&vpfe_rsz->resizer_b.subdev.entity);
 }
 
 /*
@@ -1865,12 +1865,12 @@ out_create_link:
 	vpfe_video_unregister(&resizer->resizer_b.video_out);
 out_video_out2_register:
 	vpfe_video_unregister(&resizer->resizer_a.video_out);
-	media_entity_cleanup(&resizer->crop_resizer.subdev.entity);
-	media_entity_cleanup(&resizer->resizer_a.subdev.entity);
-	media_entity_cleanup(&resizer->resizer_b.subdev.entity);
 	v4l2_device_unregister_subdev(&resizer->crop_resizer.subdev);
 	v4l2_device_unregister_subdev(&resizer->resizer_a.subdev);
 	v4l2_device_unregister_subdev(&resizer->resizer_b.subdev);
+	media_entity_cleanup(&resizer->crop_resizer.subdev.entity);
+	media_entity_cleanup(&resizer->resizer_a.subdev.entity);
+	media_entity_cleanup(&resizer->resizer_b.subdev.entity);
 	return ret;
 }
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index cb5410b..24d98a6 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1614,7 +1614,7 @@ int vpfe_video_register(struct vpfe_video_device *video,
 void vpfe_video_unregister(struct vpfe_video_device *video)
 {
 	if (video_is_registered(&video->video_dev)) {
-		media_entity_cleanup(&video->video_dev.entity);
 		video_unregister_device(&video->video_dev);
+		media_entity_cleanup(&video->video_dev.entity);
 	}
 }
-- 
1.7.10.4

