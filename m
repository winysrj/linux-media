Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2J0UmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:08 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg8mW020448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 50/68] [media] saa7134,saa7164: warning: comparison of unsigned fixes
Date: Sat, 27 Oct 2012 18:41:08 -0200
Message-Id: <1351370486-29040-51-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/saa7134/saa7134-core.c:947:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/saa7164/saa7164-core.c:413:3: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
drivers/media/pci/saa7164/saa7164-core.c:489:3: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
drivers/media/pci/saa7134/saa7134-video.c:2514:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/saa7134/saa7134-core.c  | 3 +--
 drivers/media/pci/saa7134/saa7134-video.c | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c  | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f2b37e0..8976d0e 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -944,8 +944,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 
 	/* board config */
 	dev->board = pci_id->driver_data;
-	if (card[dev->nr] >= 0 &&
-	    card[dev->nr] < saa7134_bcount)
+	if ((unsigned)card[dev->nr] < saa7134_bcount)
 		dev->board = card[dev->nr];
 	if (SAA7134_BOARD_UNKNOWN == dev->board)
 		must_configure_manually(0);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4a77124..3abf527 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2511,7 +2511,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	/* sanitycheck insmod options */
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
-	if (gbufsize < 0 || gbufsize > gbufsize_max)
+	if (gbufsize > gbufsize_max)
 		gbufsize = gbufsize_max;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 2c9ad87..063047f 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -410,7 +410,7 @@ static void saa7164_work_enchandler(struct work_struct *w)
 		} else
 			rp = (port->last_svc_rp + 1) % 8;
 
-		if ((rp < 0) || (rp > (port->hwcfg.buffercount - 1))) {
+		if (rp > (port->hwcfg.buffercount - 1)) {
 			printk(KERN_ERR "%s() illegal rp count %d\n", __func__, rp);
 			break;
 		}
@@ -486,7 +486,7 @@ static void saa7164_work_vbihandler(struct work_struct *w)
 		} else
 			rp = (port->last_svc_rp + 1) % 8;
 
-		if ((rp < 0) || (rp > (port->hwcfg.buffercount - 1))) {
+		if (rp > (port->hwcfg.buffercount - 1)) {
 			printk(KERN_ERR "%s() illegal rp count %d\n", __func__, rp);
 			break;
 		}
-- 
1.7.11.7

