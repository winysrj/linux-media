Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:40605 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab3G3XKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 19:10:05 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] ttusbir: wire up rc feedback led
Date: Wed, 31 Jul 2013 00:00:02 +0100
Message-Id: <1375225204-5082-3-git-send-email-sean@mess.org>
In-Reply-To: <1375225204-5082-1-git-send-email-sean@mess.org>
References: <1375225204-5082-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ttusbir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 891762d..d8de205 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -302,6 +302,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 						ttusbir_bulk_complete, tt);
 
 	tt->led.name = "ttusbir:green:power";
+	tt->led.default_trigger = "rc-feedback";
 	tt->led.brightness_set = ttusbir_brightness_set;
 	tt->led.brightness_get = ttusbir_brightness_get;
 	tt->is_led_on = tt->led_on = true;
-- 
1.8.3.1

