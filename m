Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:53175 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab2JXBUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 21:20:40 -0400
Received: by mail-yh0-f46.google.com with SMTP id m54so875182yhm.19
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2012 18:20:39 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] stk1160: Try to continue with fewer transfer buffers
Date: Tue, 23 Oct 2012 22:20:30 -0300
Message-Id: <1351041630-5075-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many people are trying to use stk1160 on low memory devices.
Instead of failing if one allocation fails, we allow the driver
to continue working if fewer transfer buffers are available.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-video.c |   23 +++++++++++++++++++++--
 drivers/media/usb/stk1160/stk1160.h       |    5 +++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 8bdfb02..e620be0 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -475,7 +475,11 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
 			stk1160_err("cannot alloc %d bytes for tx[%d] buffer\n",
 				sb_size, i);
-			goto free_i_bufs;
+
+			/* Not enough transfer buffers, so just give up */
+			if (i < STK1160_MIN_BUFS)
+				goto free_i_bufs;
+			goto nomore_tx_bufs;
 		}
 		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
 
@@ -506,13 +510,28 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		}
 	}
 
-	stk1160_dbg("urbs allocated\n");
+	stk1160_dbg("%d urbs allocated\n", num_bufs);
 
 	/* At last we can say we have some buffers */
 	dev->isoc_ctl.num_bufs = num_bufs;
 
 	return 0;
 
+nomore_tx_bufs:
+	/*
+	 * Failed to allocate desired buffer count. However, we may have
+	 * enough to work fine, so we just free the extra urb,
+	 * store the allocated count and keep going, fingers crossed!
+	 */
+	usb_free_urb(dev->isoc_ctl.urb[i]);
+	dev->isoc_ctl.urb[i] = NULL;
+
+	stk1160_warn("%d urbs allocated. Trying to continue...\n", i-1);
+
+	dev->isoc_ctl.num_bufs = i-1;
+
+	return 0;
+
 free_i_bufs:
 	/* Save the allocated buffers so far, so we can properly free them */
 	dev->isoc_ctl.num_bufs = i+1;
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 68c8707..05b05b1 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -30,11 +30,12 @@
 #define STK1160_VERSION		"0.9.5"
 #define STK1160_VERSION_NUM	0x000905
 
-/* TODO: Decide on number of packets for each buffer */
+/* Decide on number of packets for each buffer */
 #define STK1160_NUM_PACKETS 64
 
 /* Number of buffers for isoc transfers */
-#define STK1160_NUM_BUFS 16 /* TODO */
+#define STK1160_NUM_BUFS 16
+#define STK1160_MIN_BUFS 1
 
 /* TODO: This endpoint address should be retrieved */
 #define STK1160_EP_VIDEO 0x82
-- 
1.7.8.6

