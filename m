Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.62.18]:45074 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaBETqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 14:46:50 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id 35CF295341868
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 12:58:25 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH v2] s2255drv: fix for return code not checked
Date: Wed,  5 Feb 2014 10:58:20 -0800
Message-Id: <1391626700-4729-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Start acquisition return code was not being checked.  Return error
if start acquisition fails.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 4c483ad..787b591 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1230,12 +1230,16 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 		vc->buffer.frame[j].cur_size = 0;
 	}
 	res = videobuf_streamon(&fh->vb_vidq);
-	if (res == 0) {
-		s2255_start_acquire(vc);
-		vc->b_acquire = 1;
-	} else
+	if (res != 0) {
 		res_free(fh);
-
+		return res;
+	}
+	res = s2255_start_acquire(vc);
+	if (res != 0) {
+		res_free(fh);
+		return res;
+	}
+	vc->b_acquire = 1;
 	return res;
 }
 
@@ -2373,7 +2377,7 @@ static int s2255_start_acquire(struct s2255_vc *vc)
 
 	dprintk(dev, 2, "start acquire exit[%d] %d\n", vc->idx, res);
 	mutex_unlock(&dev->cmdlock);
-	return 0;
+	return res;
 }
 
 static int s2255_stop_acquire(struct s2255_vc *vc)
-- 
1.7.9.5

