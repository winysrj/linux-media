Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1GSQM5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 12:12:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Chris W <lkml@psychogeeks.com>
Subject: [PATCH] [media] imon: don't parse scancodes until intf configured
Date: Tue, 19 Jul 2011 12:12:47 -0400
Message-Id: <1311091967-2791-1-git-send-email-jarod@redhat.com>
In-Reply-To: <D7E52A85-331A-4650-94F0-C1477F457457@redhat.com>
References: <D7E52A85-331A-4650-94F0-C1477F457457@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imon devices have either 1 or 2 usb interfaces on them, each wired
up to its own urb callback. The interface 0 urb callback is wired up
before the imon context's rc_dev pointer is filled in, which is
necessary for imon 0xffdc device auto-detection to work properly, but we
need to make sure we don't actually run the callback routines until
we've entirely filled in the necessary bits for each given interface,
lest we wind up oopsing. Technically, any imon device could have hit
this, but the issue is exacerbated on the 0xffdc devices, which send a
constant stream of interrupts, even when they have no valid key data.

CC: Andy Walls <awalls@md.metrocast.net>
CC: Chris W <lkml@psychogeeks.com>
Reported-by: Chris W <lkml@psychogeeks.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index caa3e3a..6ed9646 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1658,7 +1658,7 @@ static void usb_rx_callback_intf0(struct urb *urb)
 		return;
 
 	ictx = (struct imon_context *)urb->context;
-	if (!ictx)
+	if (!ictx || !ictx->dev_present_intf0)
 		return;
 
 	switch (urb->status) {
@@ -1690,7 +1690,7 @@ static void usb_rx_callback_intf1(struct urb *urb)
 		return;
 
 	ictx = (struct imon_context *)urb->context;
-	if (!ictx)
+	if (!ictx || !ictx->dev_present_intf1)
 		return;
 
 	switch (urb->status) {
@@ -2118,7 +2118,6 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 
 	ictx->dev = dev;
 	ictx->usbdev_intf0 = usb_get_dev(interface_to_usbdev(intf));
-	ictx->dev_present_intf0 = true;
 	ictx->rx_urb_intf0 = rx_urb;
 	ictx->tx_urb = tx_urb;
 	ictx->rf_device = false;
@@ -2157,6 +2156,8 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto rdev_setup_failed;
 	}
 
+	ictx->dev_present_intf0 = true;
+
 	mutex_unlock(&ictx->lock);
 	return ictx;
 
@@ -2200,7 +2201,6 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	}
 
 	ictx->usbdev_intf1 = usb_get_dev(interface_to_usbdev(intf));
-	ictx->dev_present_intf1 = true;
 	ictx->rx_urb_intf1 = rx_urb;
 
 	ret = -ENODEV;
@@ -2229,6 +2229,8 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 		goto urb_submit_failed;
 	}
 
+	ictx->dev_present_intf1 = true;
+
 	mutex_unlock(&ictx->lock);
 	return ictx;
 
-- 
1.7.1

