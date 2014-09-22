Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51581 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIVV2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 17:28:11 -0400
Received: from minime.bse ([24.134.147.13]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Lb90f-1XyxW436uP-00khzR for
 <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 23:28:09 +0200
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Thomas Voegtle <tv@lio96.de>, linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH] saa7146: generate device name early
Date: Mon, 22 Sep 2014 23:27:41 +0200
Message-Id: <1411421261-9076-1-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <alpine.LNX.2.00.1409222115570.2699@er-systems.de>
References: <alpine.LNX.2.00.1409222115570.2699@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is needed when requesting the irq.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/common/saa7146/saa7146_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index 97afee6..4418119 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -364,6 +364,9 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
+	/* create a nice device name */
+	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
+
 	DEB_EE("pci:%p\n", pci);
 
 	err = pci_enable_device(pci);
@@ -438,9 +441,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 
 	/* the rest + print status message */
 
-	/* create a nice device name */
-	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
-
 	pr_info("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x)\n",
 		dev->mem, dev->revision, pci->irq,
 		pci->subsystem_vendor, pci->subsystem_device);
-- 
1.8.3.4

