Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53547 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbbJWV0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 17:26:39 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] as102: fix potential double free in as102_fw_upload()
Date: Fri, 23 Oct 2015 23:26:18 +0200
Message-Id: <1445635578-12595-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case the request to locate the firmware file part 2 fails, the error
path releases the already freed firmware memory location again. Thus
reset the firmware pointer to NULL after releasing firmware file part 1.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/media/usb/as102/as102_fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/as102/as102_fw.c b/drivers/media/usb/as102/as102_fw.c
index 07d08c49f4d4..5a28ce3a1d49 100644
--- a/drivers/media/usb/as102/as102_fw.c
+++ b/drivers/media/usb/as102/as102_fw.c
@@ -198,6 +198,7 @@ int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 	pr_info("%s: firmware: %s loaded with success\n",
 		DRIVER_NAME, fw1);
 	release_firmware(firmware);
+	firmware = NULL;
 
 	/* wait for boot to complete */
 	mdelay(100);
-- 
1.9.1

