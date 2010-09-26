Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35177 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab0IZO0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 10:26:11 -0400
Date: Sun, 26 Sep 2010 16:25:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] V4L/DVB: dib0700: Prevent NULL pointer dereference during
 probe
Message-ID: <20100926162553.660281c6@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Commit 8dc09004978538d211ccc36b5046919489e30a55 assumes that
dev->rc_input_dev is always set. It is, however, NULL if dvb-usb was
loaded with option disable_rc_polling=1.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.36-rc5.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2010-09-24 17:17:16.000000000 +0200
+++ linux-2.6.36-rc5/drivers/media/dvb/dvb-usb/dib0700_core.c	2010-09-26 15:04:59.000000000 +0200
@@ -674,7 +674,8 @@ static int dib0700_probe(struct usb_inte
 				dev->props.rc.core.bulk_mode = false;
 
 			/* Need a higher delay, to avoid wrong repeat */
-			dev->rc_input_dev->rep[REP_DELAY] = 500;
+			if (dev->rc_input_dev)
+				dev->rc_input_dev->rep[REP_DELAY] = 500;
 
 			dib0700_rc_setup(dev);
 


-- 
Jean Delvare
