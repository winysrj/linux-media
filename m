Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33914 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753637AbcLXWev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 17:34:51 -0500
Received: by mail-pg0-f66.google.com with SMTP id b1so4792316pgc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2016 14:34:26 -0800 (PST)
From: Shyam Saini <mayhs11saini@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 3/4] media: pci: saa7164: Replace BUG() with BUG_ON()
Date: Sun, 25 Dec 2016 04:04:02 +0530
Message-Id: <1482618843-13877-2-git-send-email-mayhs11saini@gmail.com>
In-Reply-To: <1482618843-13877-1-git-send-email-mayhs11saini@gmail.com>
References: <1482618843-13877-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-dvb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index cd3eeda..cf0e10a 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -351,8 +351,7 @@ static int dvb_register(struct saa7164_port *port)
 
 	dprintk(DBGLVL_DVB, "%s(port=%d)\n", __func__, port->nr);
 
-	if (port->type != SAA7164_MPEG_DVB)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_DVB);
 
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
@@ -493,8 +492,7 @@ int saa7164_dvb_unregister(struct saa7164_port *port)
 
 	dprintk(DBGLVL_DVB, "%s()\n", __func__);
 
-	if (port->type != SAA7164_MPEG_DVB)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_DVB);
 
 	/* Remove any allocated buffers */
 	mutex_lock(&port->dmaqueue_lock);
-- 
2.7.4

