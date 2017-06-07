Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbdFGJwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 05:52:12 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: sakari.ailus@iki.fi, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
Date: Wed,  7 Jun 2017 10:52:07 +0100
Message-Id: <1496829127-28375-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Return NULL, if a null entity is parsed for it's v4l2_subdev

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
Not sure if this patch ever made it out of my mailbox:

Here's the respin with the parameter evaluated only once.

v4:
 - Improve macro usage to evaluate ent only once

 include/media/v4l2-subdev.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index a40760174797..0f92ebd2d710 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -826,8 +826,15 @@ struct v4l2_subdev {
 	struct v4l2_subdev_platform_data *pdata;
 };
 
-#define media_entity_to_v4l2_subdev(ent) \
-	container_of(ent, struct v4l2_subdev, entity)
+#define media_entity_to_v4l2_subdev(ent)				\
+({									\
+	typeof(ent) __me_sd_ent = (ent);				\
+									\
+	__me_sd_ent ?							\
+		container_of(__me_sd_ent, struct v4l2_subdev, entity) :	\
+		NULL;							\
+})
+
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
-- 
2.7.4
