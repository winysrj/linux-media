Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52134 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbeAaRdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 12:33:10 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: cx25821: prevent out-of-bounds read on array card
Date: Wed, 31 Jan 2018 17:33:09 +0000
Message-Id: <20180131173309.16377-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Currently an out of range dev->nr is detected by just reporting the
issue and later on an out-of-bounds read on array card occurs because
of this. Fix this by checking the upper range of dev->nr with the size
of array card (removes the hard coded size), move this check earlier
and also exit with the error -ENOSYS to avoid the later out-of-bounds
array read.

Detected by CoverityScan, CID#711191 ("Out-of-bounds-read")

Fixes: commit 02b20b0b4cde ("V4L/DVB (12730): Add conexant cx25821 driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cx25821/cx25821-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 04aa4a68a0ae..c1184e73cb2d 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -867,6 +867,10 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->nr = ++cx25821_devcount;
 	sprintf(dev->name, "cx25821[%d]", dev->nr);
 
+	if (dev->nr >= ARRAY_SIZE(card)) {
+		CX25821_INFO("dev->nr >= %ld", ARRAY_SIZE(card));
+		return -ENODEV;
+	}
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
@@ -882,9 +886,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
 	}
 
-	if (dev->nr > 1)
-		CX25821_INFO("dev->nr > 1!");
-
 	/* board config */
 	dev->board = 1;		/* card[dev->nr]; */
 	dev->_max_num_decoders = MAX_DECODERS;
-- 
2.15.1
