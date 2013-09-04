Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:53233 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935037Ab3IDOmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Sep 2013 10:42:16 -0400
Received: by mail-qe0-f52.google.com with SMTP id i11so208747qej.39
        for <linux-media@vger.kernel.org>; Wed, 04 Sep 2013 07:42:15 -0700 (PDT)
From: Alexandru Juncu <alexj@rosedu.org>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] dm1105: remove unneeded not-null test
Date: Wed,  4 Sep 2013 17:41:34 +0300
Message-Id: <1378305694-28879-1-git-send-email-alexj@rosedu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_adap is a field of a struct and will always be allocated so
its address will never be null.

Suggested by coccinelle, manually verified.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/media/pci/dm1105/dm1105.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index ab797fe..110a009 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1202,8 +1202,7 @@ static void dm1105_remove(struct pci_dev *pdev)
 	dvb_dmxdev_release(&dev->dmxdev);
 	dvb_dmx_release(dvbdemux);
 	dvb_unregister_adapter(dvb_adapter);
-	if (&dev->i2c_adap)
-		i2c_del_adapter(&dev->i2c_adap);
+	i2c_del_adapter(&dev->i2c_adap);
 
 	dm1105_hw_exit(dev);
 	synchronize_irq(pdev->irq);
-- 
1.8.4.rc0.1.g8f6a3e5

