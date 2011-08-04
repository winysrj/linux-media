Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1HDHO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:29 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/21] [staging] tm6000: Select interface on first open.
Date: Thu,  4 Aug 2011 09:14:14 +0200
Message-Id: <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of selecting the default interface setting when preparing
isochronous transfers, select it on the first call to open() to make
sure it is available earlier.
---
 drivers/staging/tm6000/tm6000-video.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 70fc19e..b59a0da 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -595,11 +595,6 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 	tm6000_uninit_isoc(dev);
 	/* Stop interrupt USB pipe */
 	tm6000_ir_int_stop(dev);
-
-	usb_set_interface(dev->udev,
-			  dev->isoc_in.bInterfaceNumber,
-			  dev->isoc_in.bAlternateSetting);
-
 	/* Start interrupt USB pipe */
 	tm6000_ir_int_start(dev);
 
@@ -1484,6 +1479,18 @@ static int tm6000_open(struct file *file)
 		break;
 	}
 
+	if (dev->users == 0) {
+		int err = usb_set_interface(dev->udev,
+				dev->isoc_in.bInterfaceNumber,
+				dev->isoc_in.bAlternateSetting);
+		if (err < 0) {
+			dev_err(&vdev->dev, "failed to select interface %d, "
+					"alt. setting %d\n",
+					dev->isoc_in.bInterfaceNumber,
+					dev->isoc_in.bAlternateSetting);
+		}
+	}
+
 	/* If more than one user, mutex should be added */
 	dev->users++;
 
-- 
1.7.6

