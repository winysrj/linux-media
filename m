Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46364 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3Ne6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:34:58 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 01/10] [media] coda: allow more than four instances on CODA7541
Date: Mon, 30 Sep 2013 15:34:44 +0200
Message-Id: <1380548093-22313-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new firmware, there are not anymore four register sets,
but a single register set, which the driver has to conserve across
context switches. This allows to handle more than four instances
at the same time.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 449d2fe..2805538 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -39,7 +39,7 @@
 
 #define CODA_NAME		"coda"
 
-#define CODA_MAX_INSTANCES	4
+#define CODADX6_MAX_INSTANCES	4
 
 #define CODA_FMO_BUF_SIZE	32
 #define CODADX6_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
@@ -2371,7 +2371,13 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 
 static int coda_next_free_instance(struct coda_dev *dev)
 {
-	return ffz(dev->instance_mask);
+	int idx = ffz(dev->instance_mask);
+
+	if ((idx < 0) ||
+	    (dev->devtype->product == CODA_DX6 && idx > CODADX6_MAX_INSTANCES))
+		return -EBUSY;
+
+	return idx;
 }
 
 static int coda_open(struct file *file)
@@ -2386,8 +2392,8 @@ static int coda_open(struct file *file)
 		return -ENOMEM;
 
 	idx = coda_next_free_instance(dev);
-	if (idx >= CODA_MAX_INSTANCES) {
-		ret = -EBUSY;
+	if (idx < 0) {
+		ret = idx;
 		goto err_coda_max;
 	}
 	set_bit(idx, &dev->instance_mask);
-- 
1.8.4.rc3

