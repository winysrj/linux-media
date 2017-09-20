Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:52451 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdITQ6R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:58:17 -0400
Subject: [PATCH 1/5] [media] s2255drv: Delete three error messages for a
 failed memory allocation in s2255_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Message-ID: <40736ede-e614-e498-8768-b8e5a1553f34@users.sourceforge.net>
Date: Wed, 20 Sep 2017 18:57:52 +0200
MIME-Version: 1.0
In-Reply-To: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 16:30:13 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/s2255/s2255drv.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index b2f239c4ba42..29285e8cd742 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2242,13 +2242,9 @@ static int s2255_probe(struct usb_interface *interface,
-	if (dev == NULL) {
-		s2255_dev_err(&interface->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
-	if (dev->cmdbuf == NULL) {
-		s2255_dev_err(&interface->dev, "out of memory\n");
+	if (!dev->cmdbuf)
 		goto errorFWDATA1;
-	}
 
 	atomic_set(&dev->num_channels, 0);
 	dev->pid = id->idProduct;
@@ -2303,7 +2299,6 @@ static int s2255_probe(struct usb_interface *interface,
-	if (!dev->fw_data->pfw_data) {
-		dev_err(&interface->dev, "out of memory!\n");
+	if (!dev->fw_data->pfw_data)
 		goto errorFWDATA2;
-	}
+
 	/* load the first chunk */
 	if (request_firmware(&dev->fw_data->fw,
 			     FIRMWARE_FILE_NAME, &dev->udev->dev)) {
-- 
2.14.1
