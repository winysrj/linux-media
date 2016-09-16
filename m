Return-path: <linux-media-owner@vger.kernel.org>
Received: from atlantic540.startdedicated.de ([188.138.9.77]:55339 "EHLO
        atlantic540.startdedicated.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933625AbcIPL03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:26:29 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH 1/2] [media] imon: use complete() instead of complete_all()
Date: Fri, 16 Sep 2016 13:18:21 +0200
Message-Id: <1474024702-19436-2-git-send-email-wagi@monom.org>
In-Reply-To: <1474024702-19436-1-git-send-email-wagi@monom.org>
References: <1474024702-19436-1-git-send-email-wagi@monom.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

There is only one waiter for the completion, therefore there is no need
to use complete_all(). Let's make that clear by using complete() instead
of complete_all().

While we are at it, we do a small optimization with the reinitialization
of the completion before we use it.

The usage pattern of the completion is:

waiter context                          waker context

send_packet()
  init_completion()
  usb_submit_urb()
  wait_for_completion_interruptible()

                                        usb_tx_callback()
                                          complete()

                                        imon_disonnect()
                                          complete()

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/media/rc/imon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 65f80b8..38cdfd6 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -611,7 +611,7 @@ static int send_packet(struct imon_context *ictx)
 		ictx->tx_urb->actual_length = 0;
 	}
 
-	init_completion(&ictx->tx.finished);
+	reinit_completion(&ictx->tx.finished);
 	ictx->tx.busy = true;
 	smp_rmb(); /* ensure later readers know we're busy */
 
@@ -2233,6 +2233,8 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf,
 	ictx->tx_urb = tx_urb;
 	ictx->rf_device = false;
 
+	init_completion(&ictx->tx.finished);
+
 	ictx->vendor  = le16_to_cpu(ictx->usbdev_intf0->descriptor.idVendor);
 	ictx->product = le16_to_cpu(ictx->usbdev_intf0->descriptor.idProduct);
 
@@ -2511,7 +2513,7 @@ static void imon_disconnect(struct usb_interface *interface)
 	/* Abort ongoing write */
 	if (ictx->tx.busy) {
 		usb_kill_urb(ictx->tx_urb);
-		complete_all(&ictx->tx.finished);
+		complete(&ictx->tx.finished);
 	}
 
 	if (ifnum == 0) {
-- 
2.7.4
