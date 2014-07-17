Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39326 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbaGQQFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:42 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 02/11] [media] coda: initialize hardware on pm runtime resume only if firmware available
Date: Thu, 17 Jul 2014 18:05:03 +0200
Message-Id: <1405613112-22442-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If no firmware was found and the coda module is unloaded, coda_runtime_resume
will be called without an allocated code buffer. Do not call coda_hw_init in
this case.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index d5abb7c..10f9278 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3904,7 +3904,7 @@ static int coda_runtime_resume(struct device *dev)
 	struct coda_dev *cdev = dev_get_drvdata(dev);
 	int ret = 0;
 
-	if (dev->pm_domain) {
+	if (dev->pm_domain && cdev->codebuf.vaddr) {
 		ret = coda_hw_init(cdev);
 		if (ret)
 			v4l2_err(&cdev->v4l2_dev, "HW initialization failed\n");
-- 
2.0.1

