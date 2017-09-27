Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36360 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdI0Sc5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:32:57 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: andreyknvl@google.com, mchehab@kernel.org, kcc@google.com,
        dvyukov@google.com, mchehab@s-opensource.com,
        javier@osg.samsung.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: [RFT v2] [media] siano: FIX use-after-free in worker_thread
Date: Thu, 28 Sep 2017 00:02:42 +0530
Message-Id: <2b7b169ee0fb43b4447c8960cdfabcfe118d2a8b.1506536596.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call flush_work() on failure and disconnect. Work initialize and schedule
in smsusb_onresponse(). it should be freed in smsusb_stop_streaming().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
This bug report by Andrey Konovalov "usb/media/smsusb: use-after-free in
worker_thread".
changes in v2 : 
              call flush_work() in smsusb_stop_streaming().

 drivers/media/usb/siano/smsusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8c1f926..8142ba4 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -192,6 +192,8 @@ static void smsusb_stop_streaming(struct smsusb_device_t *dev)
 	for (i = 0; i < MAX_URBS; i++) {
 		usb_kill_urb(&dev->surbs[i].urb);
 
+		flush_work(&dev->surbs[i].wq);
+
 		if (dev->surbs[i].cb) {
 			smscore_putbuffer(dev->coredev, dev->surbs[i].cb);
 			dev->surbs[i].cb = NULL;
-- 
2.7.4
