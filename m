Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:47361 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbcDNQbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:31:24 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, nenggun.kim@samsung.com,
	akpm@linux-foundation.org, jh1009.sung@samsung.com,
	inki.dae@samsung.com, arnd@arndb.de
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: saa7134 fix media_dev alloc error path to not free when alloc fails
Date: Thu, 14 Apr 2016 10:31:20 -0600
Message-Id: <1460651480-6935-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_dev alloc error path does kfree when alloc fails. Fix it to not call
kfree when media_dev alloc fails.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c0e1780..eab2684 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1046,7 +1046,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	dev->media_dev = kzalloc(sizeof(*dev->media_dev), GFP_KERNEL);
 	if (!dev->media_dev) {
 		err = -ENOMEM;
-		goto fail0;
+		goto media_dev_alloc_fail;
 	}
 	media_device_pci_init(dev->media_dev, pci_dev, dev->name);
 	dev->v4l2_dev.mdev = dev->media_dev;
@@ -1309,6 +1309,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
  fail0:
 #ifdef CONFIG_MEDIA_CONTROLLER
 	kfree(dev->media_dev);
+ media_dev_alloc_fail:
 #endif
 	kfree(dev);
 	return err;
-- 
2.5.0

