Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34253 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcLXWcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 17:32:48 -0500
Received: by mail-pg0-f66.google.com with SMTP id b1so4789410pgc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2016 14:32:48 -0800 (PST)
From: Shyam Saini <mayhs11saini@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 4/4] media: pci: saa7164: Replace BUG() with BUG_ON()
Date: Sun, 25 Dec 2016 04:01:42 +0530
Message-Id: <1482618702-13755-4-git-send-email-mayhs11saini@gmail.com>
In-Reply-To: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
References: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-vbi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index e5dcb81..73e42c9 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -722,8 +722,7 @@ int saa7164_vbi_register(struct saa7164_port *port)
 
 	dprintk(DBGLVL_VBI, "%s()\n", __func__);
 
-	if (port->type != SAA7164_MPEG_VBI)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_VBI);
 
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
@@ -775,8 +774,7 @@ void saa7164_vbi_unregister(struct saa7164_port *port)
 
 	dprintk(DBGLVL_VBI, "%s(port=%d)\n", __func__, port->nr);
 
-	if (port->type != SAA7164_MPEG_VBI)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_VBI);
 
 	if (port->v4l_device) {
 		if (port->v4l_device->minor != -1)
-- 
2.7.4

