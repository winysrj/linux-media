Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59588 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1GBMBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 08:01:14 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH V2] gspca/zc3xx: add usb_id for HP Premium Starter Cam
Date: Sat,  2 Jul 2011 14:02:00 +0200
Message-Id: <1309608120-7314-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <20110702105537.50d0e1df@tele>
References: <20110702105537.50d0e1df@tele>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean-Francois Moine <moinejf@free.fr>
---

V2: added entry in documentation

 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/zc3xx.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 5bfa9a7..b3d5f75 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -8,6 +8,7 @@ xxxx		vend:prod
 ----
 spca501		0000:0000	MystFromOri Unknown Camera
 spca508		0130:0130	Clone Digital Webcam 11043
+zc3xx		03f0:1b07	HP Premium Starter Cam
 m5602		0402:5602	ALi Video Camera Controller
 spca501		040a:0002	Kodak DVC-325
 spca500		040a:0300	Kodak EZ200
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 61cdd56..dbbab48 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -6970,6 +6970,7 @@ static const struct sd_desc sd_desc = {
 };
 
 static const struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x03f0, 0x1b07)},
 	{USB_DEVICE(0x041e, 0x041e)},
 	{USB_DEVICE(0x041e, 0x4017)},
 	{USB_DEVICE(0x041e, 0x401c), .driver_info = SENSOR_PAS106},
-- 
1.7.2.5

