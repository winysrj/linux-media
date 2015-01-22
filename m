Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60062 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbbAVOsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:48:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH 6/7] staging: media: omap4iss: Cleanup media entities after unregistration
Date: Thu, 22 Jan 2015 16:48:45 +0200
Message-Id: <1421938126-17747-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ipipeif, ipipe and resizer media entities are cleaned up before
unregistering the media device, creating a race condition. Fix it by
cleaning them up at cleanup time.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipe.c   | 6 +++---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 6 +++---
 drivers/staging/media/omap4iss/iss_resizer.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index a1a46ef..73b165e 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -516,8 +516,6 @@ static int ipipe_init_entities(struct iss_ipipe_device *ipipe)
 
 void omap4iss_ipipe_unregister_entities(struct iss_ipipe_device *ipipe)
 {
-	media_entity_cleanup(&ipipe->subdev.entity);
-
 	v4l2_device_unregister_subdev(&ipipe->subdev);
 }
 
@@ -566,5 +564,7 @@ int omap4iss_ipipe_init(struct iss_device *iss)
  */
 void omap4iss_ipipe_cleanup(struct iss_device *iss)
 {
-	/* FIXME: are you sure there's nothing to do? */
+	struct iss_ipipe_device *ipipe = &iss->ipipe;
+
+	media_entity_cleanup(&ipipe->subdev.entity);
 }
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 3943fae..1a905e1 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -773,8 +773,6 @@ static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
 
 void omap4iss_ipipeif_unregister_entities(struct iss_ipipeif_device *ipipeif)
 {
-	media_entity_cleanup(&ipipeif->subdev.entity);
-
 	v4l2_device_unregister_subdev(&ipipeif->subdev);
 	omap4iss_video_unregister(&ipipeif->video_out);
 }
@@ -828,5 +826,7 @@ int omap4iss_ipipeif_init(struct iss_device *iss)
  */
 void omap4iss_ipipeif_cleanup(struct iss_device *iss)
 {
-	/* FIXME: are you sure there's nothing to do? */
+	struct iss_ipipeif_device *ipipeif = &iss->ipipeif;
+
+	media_entity_cleanup(&ipipeif->subdev.entity);
 }
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 3ab9728..d4834b6 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -817,8 +817,6 @@ static int resizer_init_entities(struct iss_resizer_device *resizer)
 
 void omap4iss_resizer_unregister_entities(struct iss_resizer_device *resizer)
 {
-	media_entity_cleanup(&resizer->subdev.entity);
-
 	v4l2_device_unregister_subdev(&resizer->subdev);
 	omap4iss_video_unregister(&resizer->video_out);
 }
@@ -872,5 +870,7 @@ int omap4iss_resizer_init(struct iss_device *iss)
  */
 void omap4iss_resizer_cleanup(struct iss_device *iss)
 {
-	/* FIXME: are you sure there's nothing to do? */
+	struct iss_resizer_device *resizer = &iss->resizer;
+
+	media_entity_cleanup(&resizer->subdev.entity);
 }
-- 
2.0.5

