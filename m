Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59092 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756646AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 44/57] [media] stkwebcam: don't break long lines
Date: Fri, 14 Oct 2016 17:20:32 -0300
Message-Id: <1e3fde872244db085494880cae4c95128217b7de.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/stkwebcam/stk-sensor.c | 3 +--
 drivers/media/usb/stkwebcam/stk-webcam.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-sensor.c b/drivers/media/usb/stkwebcam/stk-sensor.c
index e546b014d7ad..65334a00e3b3 100644
--- a/drivers/media/usb/stkwebcam/stk-sensor.c
+++ b/drivers/media/usb/stkwebcam/stk-sensor.c
@@ -391,8 +391,7 @@ int stk_sensor_init(struct stk_camera *dev)
 	}
 	stk_sensor_write_regvals(dev, ov_initvals);
 	msleep(10);
-	STK_INFO("OmniVision sensor detected, id %02X%02X"
-		" at address %x\n", idh, idl, SENSOR_ADDRESS);
+	STK_INFO("OmniVision sensor detected, id %02X%02X at address %x\n", idh, idl, SENSOR_ADDRESS);
 	return 0;
 }
 
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index db200c9d796d..267a22f24f82 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -366,8 +366,7 @@ static void stk_isoc_handler(struct urb *urb)
 			if (fb->v4lbuf.bytesused != 0
 				&& fb->v4lbuf.bytesused != dev->frame_size) {
 				(void) (printk_ratelimit() &&
-				STK_ERROR("frame %d, "
-					"bytesused=%d, skipping\n",
+				STK_ERROR("frame %d, bytesused=%d, skipping\n",
 					i, fb->v4lbuf.bytesused));
 				fb->v4lbuf.bytesused = 0;
 				fill = fb->buffer;
-- 
2.7.4


