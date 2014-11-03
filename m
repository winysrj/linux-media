Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34145 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753402AbaKCU4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 15:56:01 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH 1/1] media: Fix a compiler warning in media_entity_pipeline_start()
Date: Mon,  3 Nov 2014 22:55:51 +0200
Message-Id: <1415048151-16909-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <201411032323.hb5neZww%fengguang.wu@intel.com>
References: <201411032323.hb5neZww%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch "[media] media: Print information on failed link validation" cause a
harmless compiler warning in printing a debug message. Fix this.

The type casting is done do ensure the type really is suitable for printing
as %u, as find_first_zero_bit() does return int on some architectures and
unsigned long on others.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/media-entity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4122d7f..4d8e01c 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -297,7 +297,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			dev_dbg(entity->parent->dev,
 				"\"%s\":%u must be connected by an enabled link\n",
 				entity->name,
-				find_first_zero_bit(active, entity->num_pads));
+				(unsigned)find_first_zero_bit(
+					active, entity->num_pads));
 			goto error;
 		}
 	}
-- 
1.7.10.4

