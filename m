Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbdEQPiU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:38:20 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se, geert@glider.be
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3.1 1/2] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
Date: Wed, 17 May 2017 16:38:14 +0100
Message-Id: <38adea84b864609515b2db580a76954b1a114e3f.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Return NULL, if a null entity is parsed for it's v4l2_subdev

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5f1669c45642..72d7f28f38dc 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -829,7 +829,7 @@ struct v4l2_subdev {
 };
 
 #define media_entity_to_v4l2_subdev(ent) \
-	container_of(ent, struct v4l2_subdev, entity)
+	(ent ? container_of(ent, struct v4l2_subdev, entity) : NULL)
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
-- 
git-series 0.9.1
