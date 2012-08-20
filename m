Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34049 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2HTBYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 21:24:22 -0400
Received: by yhmm54 with SMTP id m54so4796712yhm.19
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 18:24:21 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/4] stk1160: Handle urb allocation failure condition properly
Date: Sun, 19 Aug 2012 22:23:44 -0300
Message-Id: <1345425826-13429-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
References: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When an urb buffer can't be allocated, the currently allocated
buffer count must be saved so they can properly released.
Moreover, it's sufficient to call stk1160_free_isoc to have
all urb buffers released.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-video.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 022092a..8bdfb02 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -462,8 +462,7 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
 			stk1160_err("cannot alloc urb[%d]\n", i);
-			stk1160_uninit_isoc(dev);
-			return -ENOMEM;
+			goto free_i_bufs;
 		}
 		dev->isoc_ctl.urb[i] = urb;
 
@@ -474,10 +473,9 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		dev->isoc_ctl.transfer_buffer[i] = kmalloc(sb_size, GFP_KERNEL);
 #endif
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
-			stk1160_err("cannot alloc %d bytes for tx buffer\n",
-				sb_size);
-			stk1160_uninit_isoc(dev);
-			return -ENOMEM;
+			stk1160_err("cannot alloc %d bytes for tx[%d] buffer\n",
+				sb_size, i);
+			goto free_i_bufs;
 		}
 		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
 
@@ -514,5 +512,11 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 	dev->isoc_ctl.num_bufs = num_bufs;
 
 	return 0;
+
+free_i_bufs:
+	/* Save the allocated buffers so far, so we can properly free them */
+	dev->isoc_ctl.num_bufs = i+1;
+	stk1160_free_isoc(dev);
+	return -ENOMEM;
 }
 
-- 
1.7.8.6

