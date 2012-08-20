Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43592 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2HTBYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 21:24:40 -0400
Received: by yenl14 with SMTP id l14so4806062yen.19
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 18:24:40 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 4/4] stk1160: Stop device and unqueue buffers when start_streaming() fails
Date: Sun, 19 Aug 2012 22:23:46 -0300
Message-Id: <1345425826-13429-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
References: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If start_streaming() fails (e.g. out of memory) the driver needs to
rewind the start procedure. This implies possibly stopping the device
and clearing the buffer queue.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 63c5832..cc5a95f 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -184,7 +184,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 	if (!dev->isoc_ctl.num_bufs || new_pkt_size) {
 		rc = stk1160_alloc_isoc(dev);
 		if (rc < 0)
-			goto out_unlock;
+			goto out_stop_hw;
 	}
 
 	/* submit urbs and enables IRQ */
@@ -192,8 +192,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 		rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_KERNEL);
 		if (rc) {
 			stk1160_err("cannot submit urb[%d] (%d)\n", i, rc);
-			stk1160_uninit_isoc(dev);
-			goto out_unlock;
+			goto out_uninit;
 		}
 	}
 
@@ -206,7 +205,16 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 
 	stk1160_dbg("streaming started\n");
 
-out_unlock:
+	mutex_unlock(&dev->v4l_lock);
+
+	return 0;
+
+out_uninit:
+	stk1160_uninit_isoc(dev);
+out_stop_hw:
+	usb_set_interface(dev->udev, 0, 0);
+	stk1160_clear_queue(dev);
+
 	mutex_unlock(&dev->v4l_lock);
 
 	return rc;
-- 
1.7.8.6

