Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:46995 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2FUTxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:50 -0400
Received: by mail-yw0-f51.google.com with SMTP id n12so1035632yhn.10
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:49 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 06/10] staging: solo6x10: Replace printk(KERN_WARNING with dev_warn
Date: Thu, 21 Jun 2012 16:52:08 -0300
Message-Id: <1340308332-1118-6-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/p2m.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 56210f0..1eb9fb3 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -231,15 +231,15 @@ static void run_p2m_test(struct solo_dev *solo_dev)
 	u32 size = SOLO_JPEG_EXT_ADDR(solo_dev) + SOLO_JPEG_EXT_SIZE(solo_dev);
 	int i, d;
 
-	printk(KERN_WARNING "%s: Testing %u bytes of external ram\n",
-	       SOLO6X10_NAME, size);
+	dev_warn(&solo_dev->pdev->dev, "Testing %u bytes of external ram\n",
+		 size);
 
 	for (i = 0; i < size; i += TEST_CHUNK_SIZE)
 		for (d = 0; d < 4; d++)
 			errs += p2m_test(solo_dev, d, i, TEST_CHUNK_SIZE);
 
-	printk(KERN_WARNING "%s: Found %llu errors during p2m test\n",
-	       SOLO6X10_NAME, errs);
+	dev_warn(&solo_dev->pdev->dev, "Found %llu errors during p2m test\n",
+	       errs);
 
 	return;
 }
-- 
1.7.4.4

