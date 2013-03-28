Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:58063 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab3C1Vd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 17:33:59 -0400
Message-ID: <1364506437.1345.42.camel@x61.thuisdomein>
Subject: [PATCH] [media] gspca: remove obsolete Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 22:33:57 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The et61x251 driver was removed in v3.5. Remove the last references to
its Kconfig macro now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, as usual.

 drivers/media/usb/gspca/etoms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/gspca/etoms.c b/drivers/media/usb/gspca/etoms.c
index 38f68e1..f165581 100644
--- a/drivers/media/usb/gspca/etoms.c
+++ b/drivers/media/usb/gspca/etoms.c
@@ -768,9 +768,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x102c, 0x6151), .driver_info = SENSOR_PAS106},
-#if !defined CONFIG_USB_ET61X251 && !defined CONFIG_USB_ET61X251_MODULE
 	{USB_DEVICE(0x102c, 0x6251), .driver_info = SENSOR_TAS5130CXX},
-#endif
 	{}
 };
 
-- 
1.7.11.7

