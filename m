Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56666 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab2JTVsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 17:48:21 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/2] omap3isp: Find source pad from external entity
Date: Sun, 21 Oct 2012 00:48:18 +0300
Message-Id: <1350769698-24752-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121020214803.GR21261@valkosipuli.retiisi.org.uk>
References: <20121020214803.GR21261@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No longer assume pad number 0 is the source pad of the external entity. Find
the source pad from the external entity and use it instead.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5ea5520..5f75798 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1767,6 +1767,7 @@ static int isp_register_entities(struct isp_device *isp)
 		struct media_entity *input;
 		unsigned int flags;
 		unsigned int pad;
+		unsigned int i;
 
 		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
 		if (sensor == NULL)
@@ -1814,7 +1815,18 @@ static int isp_register_entities(struct isp_device *isp)
 			goto done;
 		}
 
-		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
+		for (i = 0; i < sensor->entity.num_pads; i++) {
+			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
+				break;
+		}
+		if (i == sensor->entity.num_pads) {
+			dev_err(isp->dev,
+				"no source pads in external entities\n");
+			ret = -EINVAL;
+			goto done;
+		}
+
+		ret = media_entity_create_link(&sensor->entity, i, input, pad,
 					       flags);
 		if (ret < 0)
 			goto done;
-- 
1.7.2.5

