Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: fix error path in case of missing pdata on non-DT platform
Date: Fri, 26 Feb 2016 12:21:35 +0100
Message-Id: <1456485695-15412-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we bail out this early, v4l2_device_register() has not been called
yet, so no need to call v4l2_device_unregister().

Fixes: b7bd660a51f0 ("[media] coda: Call v4l2_device_unregister() from a single location")
Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2d782ce..7ae89c6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2118,14 +2118,12 @@ static int coda_probe(struct platform_device *pdev)
 
 	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
 
-	if (of_id) {
+	if (of_id)
 		dev->devtype = of_id->data;
-	} else if (pdev_id) {
+	else if (pdev_id)
 		dev->devtype = &coda_devdata[pdev_id->driver_data];
-	} else {
-		ret = -EINVAL;
-		goto err_v4l2_register;
-	}
+	else
+		return -EINVAL;
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
-- 
2.7.0

