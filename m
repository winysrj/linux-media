Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61295 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751823AbbHTVDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 17:03:54 -0400
Date: Thu, 20 Aug 2015 17:03:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Clark Williams <williams@redhat.com>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Subject: [PATCH] cx231xx: Use wake_up_interruptible() instead of
 wake_up_interruptible_nr()
Message-ID: <20150820170343.5938cc15@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While looking at use cases of the wake queues in order to add support
for simple wait queues, I noticed that there was only a single user of
wake_up_interruptible_nr(), and that use was doing a single task wake
up. Have that user use the proper wake_up_interruptible() instead, and
perhaps we can even remove the function wake_up_interruptible_nr().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index c6ff896..9798160 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1875,7 +1875,7 @@ static int cx231xx_close(struct file *filp)
 			v4l2_fh_exit(&fh->fh);
 			kfree(fh);
 			dev->users--;
-			wake_up_interruptible_nr(&dev->open, 1);
+			wake_up_interruptible(&dev->open);
 			return 0;
 		}
 
@@ -1908,7 +1908,7 @@ static int cx231xx_close(struct file *filp)
 	}
 	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
-	wake_up_interruptible_nr(&dev->open, 1);
+	wake_up_interruptible(&dev->open);
 	return 0;
 }
 
