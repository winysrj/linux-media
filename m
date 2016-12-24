Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34332 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcLXWcO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 17:32:14 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so15411830pfb.1
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2016 14:32:14 -0800 (PST)
From: Shyam Saini <mayhs11saini@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 2/4] media: pci: saa7164: Replace BUG() with BUG_ON()
Date: Sun, 25 Dec 2016 04:01:40 +0530
Message-Id: <1482618702-13755-2-git-send-email-mayhs11saini@gmail.com>
In-Reply-To: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
References: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 03a1511..4c32649 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -591,8 +591,7 @@ static irqreturn_t saa7164_irq_ts(struct saa7164_port *port)
 
 	/* Find the current write point from the hardware */
 	wp = saa7164_readl(port->bufcounter);
-	if (wp > (port->hwcfg.buffercount - 1))
-		BUG();
+	BUG_ON(wp > (port->hwcfg.buffercount - 1));
 
 	/* Find the previous buffer to the current write point */
 	if (wp == 0)
@@ -604,8 +603,7 @@ static irqreturn_t saa7164_irq_ts(struct saa7164_port *port)
 	/* TODO: turn this into a worker thread */
 	list_for_each_safe(c, n, &port->dmaqueue.list) {
 		buf = list_entry(c, struct saa7164_buffer, list);
-		if (i++ > port->hwcfg.buffercount)
-			BUG();
+		BUG_ON(i++ > port->hwcfg.buffercount);
 
 		if (buf->idx == rp) {
 			/* Found the buffer, deal with it */
@@ -910,8 +908,7 @@ static int saa7164_port_init(struct saa7164_dev *dev, int portnr)
 {
 	struct saa7164_port *port = NULL;
 
-	if ((portnr < 0) || (portnr >= SAA7164_MAX_PORTS))
-		BUG();
+	BUG_ON((portnr < 0) || (portnr >= SAA7164_MAX_PORTS));
 
 	port = &dev->ports[portnr];
 
-- 
2.7.4

