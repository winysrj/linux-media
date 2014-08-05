Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52213 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaHERAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 10/15] [media] coda: add an intermediate debug level
Date: Tue,  5 Aug 2014 19:00:15 +0200
Message-Id: <1407258020-12078-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dumping all register accesses drowns other debugging messages
in the log. Add a less verbose debug level.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6020e33..7311452 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -58,7 +58,7 @@
 
 int coda_debug;
 module_param(coda_debug, int, 0644);
-MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
+MODULE_PARM_DESC(coda_debug, "Debug level (0-2)");
 
 struct coda_fmt {
 	char *name;
@@ -67,7 +67,7 @@ struct coda_fmt {
 
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
 		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
 	writel(data, dev->regs_base + reg);
 }
@@ -76,7 +76,7 @@ unsigned int coda_read(struct coda_dev *dev, u32 reg)
 {
 	u32 data;
 	data = readl(dev->regs_base + reg);
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
 		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
 	return data;
 }
-- 
2.0.1

