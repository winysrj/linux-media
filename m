Return-path: <linux-media-owner@vger.kernel.org>
Received: from r012.red.fastwebserver.de ([217.79.190.12]:33944 "EHLO
	links-clan.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaADWv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jan 2014 17:51:59 -0500
From: "Links (Markus)" <help.markus+git@gmail.com>
Cc: "Links (Markus)" <help.markus+git@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] support for CX23103 Video Grabber USB
Date: Sat,  4 Jan 2014 23:44:34 +0100
Message-Id: <1388875474-24364-1-git-send-email-help.markus+git@gmail.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Links (Markus)" <help.markus+git@gmail.com>

	modified:   drivers/media/usb/cx231xx/cx231xx-cards.c

Signed-off-by: Links (Markus) <help.markus+git@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 528cce9..2ee03e4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -709,6 +709,8 @@ const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
 /* table of devices that work with this driver */
 struct usb_device_id cx231xx_id_table[] = {
+	{USB_DEVICE(0x1D19, 0x6109),
+	.driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
 	{USB_DEVICE(0x0572, 0x5A3C),
 	 .driver_info = CX231XX_BOARD_UNKNOWN},
 	{USB_DEVICE(0x0572, 0x58A2),
-- 
1.7.10.4

