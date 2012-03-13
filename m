Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18378 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab2CMRw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 13:52:57 -0400
Date: Tue, 13 Mar 2012 18:52:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 2/2 v2] [media] dib0700: Fix memory leak during
 initialization
Message-ID: <20120313185250.2c8a0d78@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported by kmemleak.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
---
Changes since v1:
* Don't free the URB when it is still in use.
* Fix a second leak (transfer_buffer).

 drivers/media/dvb/dvb-usb/dib0700_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-3.3-rc7.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 11:20:33.748864483 +0100
+++ linux-3.3-rc7/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 17:42:20.316570058 +0100
@@ -679,6 +679,7 @@ static void dib0700_rc_urb_completion(st
 	deb_info("%s()\n", __func__);
 	if (d->rc_dev == NULL) {
 		/* This will occur if disable_rc_polling=1 */
+		kfree(purb->transfer_buffer);
 		usb_free_urb(purb);
 		return;
 	}
@@ -687,6 +688,7 @@ static void dib0700_rc_urb_completion(st
 
 	if (purb->status < 0) {
 		deb_info("discontinuing polling\n");
+		kfree(purb->transfer_buffer);
 		usb_free_urb(purb);
 		return;
 	}
@@ -781,8 +783,11 @@ int dib0700_rc_setup(struct dvb_usb_devi
 			  dib0700_rc_urb_completion, d);
 
 	ret = usb_submit_urb(purb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		err("rc submit urb failed\n");
+		kfree(purb->transfer_buffer);
+		usb_free_urb(purb);
+	}
 
 	return ret;
 }


-- 
Jean Delvare
