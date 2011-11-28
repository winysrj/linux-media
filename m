Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:62631 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1K1Tqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:46:36 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 4/5] tm6000: bugfix bulk transfer
Date: Mon, 28 Nov 2011 20:46:19 +0100
Message-Id: <1322509580-14460-4-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/tm6000/tm6000-dvb.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-dvb.c b/drivers/media/video/tm6000/tm6000-dvb.c
index 5e6c129..db6a561 100644
--- a/drivers/media/video/tm6000/tm6000-dvb.c
+++ b/drivers/media/video/tm6000/tm6000-dvb.c
@@ -89,9 +89,19 @@ static void tm6000_urb_received(struct urb *urb)
 	int ret;
 	struct tm6000_core *dev = urb->context;
 
-	if (urb->status != 0)
+	switch (urb->status) {
+	case 0:
+	case -ETIMEDOUT:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	default:
 		print_err_status(dev, 0, urb->status);
-	else if (urb->actual_length > 0)
+	}
+
+	if (urb->actual_length > 0)
 		dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
 						   urb->actual_length);
 
@@ -151,7 +161,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 		printk(KERN_ERR "tm6000: pipe resetted\n");
 
 /*	mutex_lock(&tm6000_driver.open_close_mutex); */
-	ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
+	ret = usb_submit_urb(dvb->bulk_urb, GFP_ATOMIC);
 
 /*	mutex_unlock(&tm6000_driver.open_close_mutex); */
 	if (ret) {
-- 
1.7.7

