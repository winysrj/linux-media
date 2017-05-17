Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754425AbdEQONz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 10:13:55 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 1/2] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
Date: Wed, 17 May 2017 15:13:17 +0100
Message-Id: <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Return NULL, if a null entity is parsed for it's v4l2_subdev

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5f1669c45642..d43fa7ca3a92 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -829,7 +829,7 @@ struct v4l2_subdev {
 };
 
 #define media_entity_to_v4l2_subdev(ent) \
-	container_of(ent, struct v4l2_subdev, entity)
+	ent ? container_of(ent, struct v4l2_subdev, entity) : NULL
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
-- 
git-series 0.9.1
