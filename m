Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33701 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0GFKaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jul 2010 06:30:35 -0400
From: Renzo Dani <arons7@gmail.com>
To: mchehab@infradead.org
Cc: arons7@gmail.com, rdunlap@xenotime.net, o.endriss@gmx.de,
	awalls@radix.net, crope@iki.fi, manu@linuxtv.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/2] Added Technisat Skystar USB HD CI
Date: Tue,  6 Jul 2010 12:23:18 +0200
Message-Id: <1278411798-6437-1-git-send-email-arons7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 drivers/media/dvb/dvb-usb/az6027.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index d7290b2..445851a 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -1103,13 +1103,23 @@ static struct dvb_usb_device_properties az6027_properties = {
 	.rc_query         = az6027_rc_query,
 	.i2c_algo         = &az6027_i2c_algo,
 
-	.num_device_descs = 1,
+	.num_device_descs = 3,
 	.devices = {
 		{
 			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
 			.cold_ids = { &az6027_usb_table[0], NULL },
 			.warm_ids = { NULL },
 		},
+		{
+		    .name = " Terratec DVB 2 CI",
+			.cold_ids = { &az6027_usb_table[1], NULL },
+			.warm_ids = { NULL },
+		},
+		{
+		    .name = "TechniSat SkyStar USB 2 HD CI (AZ6027)",
+			.cold_ids = { &az6027_usb_table[2], NULL },
+			.warm_ids = { NULL },
+		},
 		{ NULL },
 	}
 };
@@ -1118,7 +1128,7 @@ static struct dvb_usb_device_properties az6027_properties = {
 static struct usb_driver az6027_usb_driver = {
 	.name		= "dvb_usb_az6027",
 	.probe 		= az6027_usb_probe,
-	.disconnect 	= az6027_usb_disconnect,
+	.disconnect	= az6027_usb_disconnect,
 	.id_table 	= az6027_usb_table,
 };
 
-- 
1.7.1

