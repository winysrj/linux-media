Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbcCWT1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 15:27:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] [media] media-device: get rid of a leftover comment
Date: Wed, 23 Mar 2016 16:27:45 -0300
Message-Id: <90a95b96574f87c87a7a101926aa8c4cd5f74139.1458760750.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment there is not pertinent.

Fixes: 44ff16d0b7cc ("media-device: use kref for media_device instance")
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4b5a2ab17b7e..10cc4766de10 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -720,7 +720,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
-	/* Check if mdev was ever registered at all */
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Register the device node. */
-- 
2.5.5


