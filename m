Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([69.93.164.18]:34754 "EHLO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaBESy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 13:54:56 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway14.websitewelcome.com (Postfix) with ESMTP id 9C0FC53264EA0
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 12:54:55 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: fix for return code not checked
Date: Wed,  5 Feb 2014 10:54:49 -0800
Message-Id: <1391626489-4441-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Start acquisition return code was not being checked.  Return error
if start acquisition fails.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 4c483ad..556e5e5 100644
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
 
-- 
1.7.9.5

