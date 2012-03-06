Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22320 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2CFQda (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:30 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 33/35] omap3isp: Find source pad from external entity
Date: Tue,  6 Mar 2012 18:33:14 +0200
Message-Id: <1331051596-8261-33-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No longer assume pad number 0 is the source pad of the external entity. Find
the source pad from the external entity and use it instead.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index f54953d..0718b0a 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1744,6 +1744,7 @@ static int isp_register_entities(struct isp_device *isp)
 		struct media_entity *input;
 		unsigned int flags;
 		unsigned int pad;
+		unsigned int i;
 
 		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
 		if (sensor == NULL)
@@ -1791,7 +1792,17 @@ static int isp_register_entities(struct isp_device *isp)
 			goto done;
 		}
 
-		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
+		for (i = 0; i < sensor->entity.num_pads; i++)
+			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
+				break;
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

