Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47236 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1FOMQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 08:16:59 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] gspca/zc3xx: add usb_id for HP Premium Starter Cam
Date: Wed, 15 Jun 2011 14:16:42 +0200
Message-Id: <1308140202-14854-1-git-send-email-w.sang@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=13479

 drivers/media/video/gspca/zc3xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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

