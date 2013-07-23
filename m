Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway13.websitewelcome.com ([69.56.160.10]:47354 "EHLO
	gateway13.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934384Ab3GWWcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 18:32:25 -0400
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway13.websitewelcome.com (Postfix) with ESMTP id 3CAE5C9622593
	for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 17:07:04 -0500 (CDT)
From: Dean Anderson <linux-dev@sensoray.com>
To: linux-dev@sensoray.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Subject: [PATCH] S2255: Removal of unnecessary videobuf_queue_is_busy
Date: Tue, 23 Jul 2013 15:06:41 -0700
Message-Id: <1374617201-18033-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removes unnecessary query of buffer state.  The code already checks if stream is active or not.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index ab97e7d..6bc9b8e 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1,7 +1,7 @@
 /*
  *  s2255drv.c - a driver for the Sensoray 2255 USB video capture device
  *
- *   Copyright (C) 2007-2010 by Sensoray Company Inc.
+ *   Copyright (C) 2007-2013 by Sensoray Company Inc.
  *                              Dean Anderson
  *
  * Some video buffer code based on vivi driver:
@@ -52,7 +52,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 
-#define S2255_VERSION		"1.22.1"
+#define S2255_VERSION		"1.23.1"
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
 /* default JPEG quality */
@@ -1303,11 +1303,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 	int ret = 0;
 
 	mutex_lock(&q->vb_lock);
-	if (videobuf_queue_is_busy(q)) {
-		dprintk(1, "queue busy\n");
-		ret = -EBUSY;
-		goto out_s_std;
-	}
 	if (res_locked(fh)) {
 		dprintk(1, "can't change standard after started\n");
 		ret = -EBUSY;
-- 
1.7.9.5

