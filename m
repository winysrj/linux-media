Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40835 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab0CHUcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 15:32:14 -0500
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org,
	=?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 1/1] gspca-stv06xx: Remove the 046d:08da usb id from linking to the stv06xx driver
Date: Mon,  8 Mar 2010 21:16:00 +0100
Message-Id: <1268079360-29200-1-git-send-email-erik.andren@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 046d:08da usb id shouldn't be associated with the stv06xx driver as they're not compatible with each other.
This fixes a bug where Quickcam Messenger cams fail to use its proper driver (gspca-zc3xx), rendering the camera inoperable.

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
Tested-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
---
 drivers/media/video/gspca/stv06xx/stv06xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/video/gspca/stv06xx/stv06xx.c
index de823ed..b1f7e28 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -497,8 +497,6 @@ static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },
 	/* QuickCam Messenger (new) */
 	{USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },
-	/* QuickCam Messenger (new) */
-	{USB_DEVICE(0x046D, 0x08DA), .driver_info = BRIDGE_ST6422 },
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
-- 
1.6.3.3

