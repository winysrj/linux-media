Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3KXNMe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 08:12:34 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Geert Stappers <stappers@stappers.nl>, stable@vger.kernel.org
Subject: [PATCH] gspca_sunplus: Add new usb-id for 06d6:0041
Date: Sun, 24 Nov 2013 14:12:30 +0100
Message-Id: <1385298750-5649-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: mjs <mjstork@gmail.com>
Tested-by: mjs <mjstork@gmail.com>
Cc: Geert Stappers <stappers@stappers.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/sunplus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index a517d18..46c9f22 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -1027,6 +1027,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x055f, 0xc650), BS(SPCA533, 0)},
 	{USB_DEVICE(0x05da, 0x1018), BS(SPCA504B, 0)},
 	{USB_DEVICE(0x06d6, 0x0031), BS(SPCA533, 0)},
+	{USB_DEVICE(0x06d6, 0x0041), BS(SPCA504B, 0)},
 	{USB_DEVICE(0x0733, 0x1311), BS(SPCA533, 0)},
 	{USB_DEVICE(0x0733, 0x1314), BS(SPCA533, 0)},
 	{USB_DEVICE(0x0733, 0x2211), BS(SPCA533, 0)},
-- 
1.8.4.2

