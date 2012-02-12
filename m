Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:48448 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2BLKTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 05:19:35 -0500
Date: Sun, 12 Feb 2012 11:19:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] [media] dib0700: Fix memory leak during initialization
Message-ID: <20120212111911.32f4c390@endymion.delvare>
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
I am not familiar with the usb API, are we also supposed to call
usb_kill_urb() in the error case maybe?

 drivers/media/dvb/dvb-usb/dib0700_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-3.3-rc3.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-01-20 14:06:38.000000000 +0100
+++ linux-3.3-rc3/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-02-12 00:32:19.005334036 +0100
@@ -787,6 +787,8 @@ int dib0700_rc_setup(struct dvb_usb_devi
 	if (ret)
 		err("rc submit urb failed\n");
 
+	usb_free_urb(purb);
+
 	return ret;
 }
 

-- 
Jean Delvare
