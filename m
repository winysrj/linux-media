Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3EUOcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 10:32:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: do not use v4l2_dev in coda_timeout
Date: Tue, 21 May 2013 16:32:42 +0200
Message-Id: <1369146762-26297-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The timeout delayed work might be scheduled even after the v4l2 device is
released.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 037e2bc..22d1b1b 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1685,7 +1685,7 @@ static void coda_timeout(struct work_struct *work)
 
 	complete(&dev->done);
 
-	v4l2_err(&dev->v4l2_dev, "CODA PIC_RUN timeout, stopping all streams\n");
+	dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout, stopping all streams\n");
 
 	mutex_lock(&dev->dev_mutex);
 	list_for_each_entry(ctx, &dev->instances, list) {
-- 
1.8.2.rc2

