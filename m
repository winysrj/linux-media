Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab1LFNjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 08:39:39 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 1/2] [media] tm6000: Fix check for interrupt endpoint
Date: Tue,  6 Dec 2011 14:39:35 +0100
Message-Id: <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking for &dev->int_in is useless because it returns the address of
the embedded struct tm6000_endpoint, which will always be positive and
therefore true.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/media/video/tm6000/tm6000-input.c |    2 +-
 drivers/media/video/tm6000/tm6000-video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index af4bcf5..89e003c 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -426,7 +426,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc->scanmask = 0xffff;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
-	if (&dev->int_in) {
+	if (dev->int_in.endp) {
 		rc->open    = __tm6000_ir_int_start;
 		rc->close   = __tm6000_ir_int_stop;
 		INIT_DELAYED_WORK(&ir->work, tm6000_ir_int_work);
diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index e147d92..87eb909 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -1647,7 +1647,7 @@ static int tm6000_release(struct file *file)
 
 		usb_reset_configuration(dev->udev);
 
-		if (&dev->int_in)
+		if (dev->int_in.endp)
 			usb_set_interface(dev->udev,
 			dev->isoc_in.bInterfaceNumber,
 			2);
-- 
1.7.8

