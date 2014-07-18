Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35233 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409AbaGRKXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:23:32 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 01/11] [media] coda: fix CODA7541 hardware reset
Date: Fri, 18 Jul 2014 12:22:35 +0200
Message-Id: <1405678965-10473-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not try to read the CODA960 GDI status register on CODA7541.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 7e69eda..d5abb7c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -350,19 +350,22 @@ static int coda_hw_reset(struct coda_ctx *ctx)
 
 	idx = coda_read(dev, CODA_REG_BIT_RUN_INDEX);
 
-	timeout = jiffies + msecs_to_jiffies(100);
-	coda_write(dev, 0x11, CODA9_GDI_BUS_CTRL);
-	while (coda_read(dev, CODA9_GDI_BUS_STATUS) != 0x77) {
-		if (time_after(jiffies, timeout))
-			return -ETIME;
-		cpu_relax();
+	if (dev->devtype->product == CODA_960) {
+		timeout = jiffies + msecs_to_jiffies(100);
+		coda_write(dev, 0x11, CODA9_GDI_BUS_CTRL);
+		while (coda_read(dev, CODA9_GDI_BUS_STATUS) != 0x77) {
+			if (time_after(jiffies, timeout))
+				return -ETIME;
+			cpu_relax();
+		}
 	}
 
 	ret = reset_control_reset(dev->rstc);
 	if (ret < 0)
 		return ret;
 
-	coda_write(dev, 0x00, CODA9_GDI_BUS_CTRL);
+	if (dev->devtype->product == CODA_960)
+		coda_write(dev, 0x00, CODA9_GDI_BUS_CTRL);
 	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
 	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
 	ret = coda_wait_timeout(dev);
-- 
2.0.1

