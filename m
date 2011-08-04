Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1HDHO1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:27 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/21] [staging] tm6000: Add locking for USB transfers.
Date: Thu,  4 Aug 2011 09:14:10 +0200
Message-Id: <1312442059-23935-13-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit introduces the usb_lock mutex to ensure that a USB request
always gets the proper response. While this is currently not really
necessary it will become important as there are more users.
---
 drivers/staging/tm6000/tm6000-cards.c |    1 +
 drivers/staging/tm6000/tm6000-core.c  |    3 +++
 drivers/staging/tm6000/tm6000.h       |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a5d2a71..68f7c7a 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -1174,6 +1174,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 	spin_lock_init(&dev->slock);
+	mutex_init(&dev->usb_lock);
 
 	/* Increment usage count */
 	tm6000_devused |= 1<<nr;
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 1f8abe3..317ab7e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -39,6 +39,8 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	unsigned int pipe;
 	u8	     *data = NULL;
 
+	mutex_lock(&dev->usb_lock);
+
 	if (len)
 		data = kzalloc(len, GFP_KERNEL);
 
@@ -86,6 +88,7 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	}
 
 	kfree(data);
+	mutex_unlock(&dev->usb_lock);
 	return ret;
 }
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 4323fc2..cf57e1e 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -245,6 +245,7 @@ struct tm6000_core {
 
 	/* locks */
 	struct mutex			lock;
+	struct mutex			usb_lock;
 
 	/* usb transfer */
 	struct usb_device		*udev;		/* the usb device */
-- 
1.7.6

