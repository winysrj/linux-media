Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:54167 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3A2MTd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 07:19:33 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] ttusbir: do not set led twice on resume
Date: Tue, 29 Jan 2013 12:19:27 +0000
Message-Id: <1359461971-27492-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

led_classdev_resume already sets the led.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ttusbir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 78be8a9..f9226b8 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -408,9 +408,8 @@ static int ttusbir_resume(struct usb_interface *intf)
 	struct ttusbir *tt = usb_get_intfdata(intf);
 	int i, rc;
 
-	led_classdev_resume(&tt->led);
 	tt->is_led_on = true;
-	ttusbir_set_led(tt);
+	led_classdev_resume(&tt->led);
 
 	for (i = 0; i < NUM_URBS; i++) {
 		rc = usb_submit_urb(tt->urb[i], GFP_KERNEL);
-- 
1.8.1

