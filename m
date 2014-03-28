Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaC1OgB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 10:36:01 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id D78ED20994
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 16:35:43 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] smiapp: Set sub-device owner
Date: Fri, 28 Mar 2014 16:35:12 +0200
Message-Id: <1396017313-3990-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1396017313-3990-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1396017313-3990-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp driver is the owner of the sub-devices exposed by the smiapp
driver. This prevents unloading the module whilst it's in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 69c11ec..5179cf4 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2569,7 +2569,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 
 		this->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 		this->sd.internal_ops = &smiapp_internal_ops;
-		this->sd.owner = NULL;
+		this->sd.owner = THIS_MODULE;
 		v4l2_set_subdevdata(&this->sd, client);
 
 		rval = media_entity_init(&this->sd.entity,
-- 
1.8.3.2

