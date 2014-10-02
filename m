Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34121 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaJBRJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:09:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 02/10] [media] coda: identify platform device earlier
Date: Thu,  2 Oct 2014 19:08:27 +0200
Message-Id: <1412269715-28388-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
References: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We'll use this information to decide whether to request the JPEG IRQ later.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 48be973..fb83c56 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1896,6 +1896,15 @@ static int coda_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
+
+	if (of_id)
+		dev->devtype = of_id->data;
+	else if (pdev_id)
+		dev->devtype = &coda_devdata[pdev_id->driver_data];
+	else
+		return -EINVAL;
+
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
 
@@ -1963,17 +1972,6 @@ static int coda_probe(struct platform_device *pdev)
 	mutex_init(&dev->dev_mutex);
 	mutex_init(&dev->coda_mutex);
 
-	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
-
-	if (of_id) {
-		dev->devtype = of_id->data;
-	} else if (pdev_id) {
-		dev->devtype = &coda_devdata[pdev_id->driver_data];
-	} else {
-		v4l2_device_unregister(&dev->v4l2_dev);
-		return -EINVAL;
-	}
-
 	dev->debugfs_root = debugfs_create_dir("coda", NULL);
 	if (!dev->debugfs_root)
 		dev_warn(&pdev->dev, "failed to create debugfs root\n");
-- 
2.1.0

