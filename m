Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0GZOYB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 10:24:01 -0400
Date: Mon, 26 Jul 2010 10:13:52 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] IR/imon: remove incorrect calls to input_free_device
Message-ID: <20100726141352.GA28182@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Per Dmitry Torokhov (in a completely unrelated thread on linux-input),
following input_unregister_device with an input_free_device is
forbidden, the former is sufficient alone.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 0195dd5..08dff8c 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1944,7 +1944,6 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 
 urb_submit_failed:
 	ir_input_unregister(ictx->idev);
-	input_free_device(ictx->idev);
 idev_setup_failed:
 find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
@@ -2014,10 +2013,8 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	return ictx;
 
 urb_submit_failed:
-	if (ictx->touch) {
+	if (ictx->touch)
 		input_unregister_device(ictx->touch);
-		input_free_device(ictx->touch);
-	}
 touch_setup_failed:
 find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
-- 
1.7.1.1


-- 
Jarod Wilson
jarod@redhat.com

