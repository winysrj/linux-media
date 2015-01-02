Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64899 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbABN4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 08:56:54 -0500
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/5] lmedm04: Increase Interupt due time to 200 msec.
Date: Fri,  2 Jan 2015 13:56:27 +0000
Message-Id: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ocassionally the device fails to report back an interrupt urb status which
results in false no lock trigger on the RS2000 demodulator.

Increase time from 60 msecs to 200 msecs.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 994de53..f1edb29 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -344,9 +344,10 @@ static void lme2510_int_response(struct urb *lme_urb)
 
 	usb_submit_urb(lme_urb, GFP_ATOMIC);
 
-	/* interrupt urb is due every 48 msecs while streaming
-	 *	add 12msecs for system lag */
-	st->int_urb_due = jiffies + msecs_to_jiffies(60);
+	/* Interrupt urb is due every 48 msecs while streaming the buffer
+	 * stores up to 4 periods if missed. Allow 200 msec for next interrupt.
+	 */
+	st->int_urb_due = jiffies + msecs_to_jiffies(200);
 }
 
 static int lme2510_int_read(struct dvb_usb_adapter *adap)
-- 
2.1.0

