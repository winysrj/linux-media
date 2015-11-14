Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:40981 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbbKNSS5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2015 13:18:57 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] lirc_imon: do not leave imon_probe() with mutex held
Date: Sat, 14 Nov 2015 21:17:56 +0300
Message-Id: <1447525076-12068-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit af8a819a2513 ("[media] lirc_imon: simplify error handling code")
lost mutex_unlock(&context->ctx_lock), so imon_probe() exits with
the context->ctx_lock mutex acquired.

The patch adds mutex_unlock(&context->ctx_lock) back.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: af8a819a2513 ("[media] lirc_imon: simplify error handling code")
---
 drivers/staging/media/lirc/lirc_imon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 534b8103ae80..ff1926ca1f96 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -885,12 +885,14 @@ static int imon_probe(struct usb_interface *interface,
 		vendor, product, ifnum, usbdev->bus->busnum, usbdev->devnum);
 
 	/* Everything went fine. Just unlock and return retval (with is 0) */
+	mutex_unlock(&context->ctx_lock);
 	goto driver_unlock;
 
 unregister_lirc:
 	lirc_unregister_driver(driver->minor);
 
 free_tx_urb:
+	mutex_unlock(&context->ctx_lock);
 	usb_free_urb(tx_urb);
 
 free_rx_urb:
-- 
1.9.1

