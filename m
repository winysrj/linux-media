Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab2HGQm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:59 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 11/11] au0828: use %*ph to dump small buffers
Date: Tue,  7 Aug 2012 19:43:11 +0300
Message-Id: <1344357792-18202-11-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/au0828/au0828-core.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index 1e4ce50..49e0e92 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -73,17 +73,7 @@ static void cmd_msg_dump(struct au0828_dev *dev)
 	int i;
 
 	for (i = 0; i < sizeof(dev->ctrlmsg); i += 16)
-		dprintk(2, "%s() %02x %02x %02x %02x %02x %02x %02x %02x "
-				"%02x %02x %02x %02x %02x %02x %02x %02x\n",
-			__func__,
-			dev->ctrlmsg[i+0], dev->ctrlmsg[i+1],
-			dev->ctrlmsg[i+2], dev->ctrlmsg[i+3],
-			dev->ctrlmsg[i+4], dev->ctrlmsg[i+5],
-			dev->ctrlmsg[i+6], dev->ctrlmsg[i+7],
-			dev->ctrlmsg[i+8], dev->ctrlmsg[i+9],
-			dev->ctrlmsg[i+10], dev->ctrlmsg[i+11],
-			dev->ctrlmsg[i+12], dev->ctrlmsg[i+13],
-			dev->ctrlmsg[i+14], dev->ctrlmsg[i+15]);
+		dprintk(2, "%s() %*ph\n", __func__, 16, dev->ctrlmsg + i);
 }
 
 static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
-- 
1.7.10.4

