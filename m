Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46279 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109Ab2CMRuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 13:50:44 -0400
Date: Tue, 13 Mar 2012 18:50:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 1/2] [media] dib0700: Drop useless check when remote key is
 pressed
Message-ID: <20120313185037.4059a869@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct dvb_usb_device *d can never be NULL so don't waste time
checking for this.

Rationale: the urb's context is set when usb_fill_bulk_urb() is called
in dib0700_rc_setup(), and never changes after that. d is dereferenced
unconditionally in dib0700_rc_setup() so it can't be NULL or the
driver would crash right away.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
---
Devin, am I missing something?

 drivers/media/dvb/dvb-usb/dib0700_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-3.3-rc7.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 11:09:13.000000000 +0100
+++ linux-3.3-rc7/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 18:37:05.785953845 +0100
@@ -677,9 +677,6 @@ static void dib0700_rc_urb_completion(st
 	u8 toggle;
 
 	deb_info("%s()\n", __func__);
-	if (d == NULL)
-		return;
-
 	if (d->rc_dev == NULL) {
 		/* This will occur if disable_rc_polling=1 */
 		usb_free_urb(purb);


-- 
Jean Delvare
