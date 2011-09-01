Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1IAG1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 02:27:22 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] tm6000: Add fast USB access quirk
Date: Thu,  1 Sep 2011 08:27:20 +0200
Message-Id: <1314858441-30813-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <4E5F1C87.9050207@redhat.com>
References: <4E5F1C87.9050207@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices support fast access to registers using the USB interface
while others require a certain delay after each operation. This commit
adds a quirk that can be enabled by devices that don't need the delay.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/staging/tm6000/tm6000-core.c |    3 ++-
 drivers/staging/tm6000/tm6000.h      |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 64fc1c6..93a0772 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -89,7 +89,8 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 
 	kfree(data);
 
-	msleep(5);
+	if ((dev->quirks & TM6000_QUIRK_NO_USB_DELAY) == 0)
+		msleep(5);
 
 	mutex_unlock(&dev->usb_lock);
 	return ret;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index dac2063..0e35812 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -169,6 +169,10 @@ struct tm6000_endpoint {
 	unsigned			maxsize;
 };
 
+enum {
+	TM6000_QUIRK_NO_USB_DELAY,
+};
+
 struct tm6000_core {
 	/* generic device properties */
 	char				name[30];	/* name (including minor) of the device */
@@ -260,6 +264,8 @@ struct tm6000_core {
 	struct usb_isoc_ctl          isoc_ctl;
 
 	spinlock_t                   slock;
+
+	unsigned long quirks;
 };
 
 enum tm6000_ops_type {
-- 
1.7.6.1

