Return-path: <linux-media-owner@vger.kernel.org>
Received: from atlantic540.startdedicated.de ([188.138.9.77]:55338 "EHLO
        atlantic540.startdedicated.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933190AbcIPL03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:26:29 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH 2/2] [media] lirc_imon: use complete() instead complete_all()
Date: Fri, 16 Sep 2016 13:18:22 +0200
Message-Id: <1474024702-19436-3-git-send-email-wagi@monom.org>
In-Reply-To: <1474024702-19436-1-git-send-email-wagi@monom.org>
References: <1474024702-19436-1-git-send-email-wagi@monom.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

There is only one waiter for the completion, therefore there
is no need to use complete_all(). Let's make that clear by
using complete() instead of complete_all().

While we are at it, we do a small optimization with the
reinitialization of the completion before we use it.

The usage pattern of the completion is:

waiter context                          waker context

send_packet()
  reinit_completion()
  usb_sumbit_urb()
  wait_for_completion_interruptible()

                                        usb_tx_callback()
                                          complete()

                                        imon_disconnect()
                                          complete()

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/staging/media/lirc/lirc_imon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index ff1926c..c449434 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -336,7 +336,7 @@ static int send_packet(struct imon_context *context)
 
 	context->tx_urb->actual_length = 0;
 
-	init_completion(&context->tx.finished);
+	reinit_completion(&context->tx.finished);
 	atomic_set(&context->tx.busy, 1);
 
 	retval = usb_submit_urb(context->tx_urb, GFP_KERNEL);
@@ -499,6 +499,8 @@ static int ir_open(void *data)
 	context->rx.initial_space = 1;
 	context->rx.prev_bit = 0;
 
+	init_completion(&context->tx.finished);
+
 	context->ir_isopen = 1;
 	dev_info(context->driver->dev, "IR port opened\n");
 
@@ -937,7 +939,7 @@ static void imon_disconnect(struct usb_interface *interface)
 	/* Abort ongoing write */
 	if (atomic_read(&context->tx.busy)) {
 		usb_kill_urb(context->tx_urb);
-		complete_all(&context->tx.finished);
+		complete(&context->tx.finished);
 	}
 
 	context->dev_present = 0;
-- 
2.7.4
