Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36255 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3GKJHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:07:31 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 07/50] USB: ldusb: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:30 +0800
Message-Id: <1373533573-12272-8-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/misc/ldusb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index ac76229..8bae18e 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -249,6 +249,7 @@ static void ld_usb_interrupt_in_callback(struct urb *urb)
 	unsigned int next_ring_head;
 	int status = urb->status;
 	int retval;
+	unsigned long flags;
 
 	if (status) {
 		if (status == -ENOENT ||
@@ -258,12 +259,12 @@ static void ld_usb_interrupt_in_callback(struct urb *urb)
 		} else {
 			dbg_info(&dev->intf->dev, "%s: nonzero status received: %d\n",
 				 __func__, status);
-			spin_lock(&dev->rbsl);
+			spin_lock_irqsave(&dev->rbsl, flags);
 			goto resubmit; /* maybe we can recover */
 		}
 	}
 
-	spin_lock(&dev->rbsl);
+	spin_lock_irqsave(&dev->rbsl, flags);
 	if (urb->actual_length > 0) {
 		next_ring_head = (dev->ring_head+1) % ring_buffer_size;
 		if (next_ring_head != dev->ring_tail) {
@@ -292,7 +293,7 @@ resubmit:
 			dev->buffer_overflow = 1;
 		}
 	}
-	spin_unlock(&dev->rbsl);
+	spin_unlock_irqrestore(&dev->rbsl, flags);
 exit:
 	dev->interrupt_in_done = 1;
 	wake_up_interruptible(&dev->read_wait);
-- 
1.7.9.5

