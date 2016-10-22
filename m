Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756077AbcJVWwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 18:52:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/5] stv06xx: store device name after the USB_DEVICE line
Date: Sat, 22 Oct 2016 20:52:01 -0200
Message-Id: <abe0321eec3d2ff4c71c041d3cc1feee5e430bef.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That makes easier to parse the names, in order to sync it
with gspca-cardlist.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/stv06xx/stv06xx.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 6ac93d8db427..d12fb2b8324e 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -582,18 +582,12 @@ static int stv06xx_config(struct gspca_dev *gspca_dev,
 
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
-	/* QuickCam Express */
-	{USB_DEVICE(0x046d, 0x0840), .driver_info = BRIDGE_STV600 },
-	/* LEGO cam / QuickCam Web */
-	{USB_DEVICE(0x046d, 0x0850), .driver_info = BRIDGE_STV610 },
-	/* Dexxa WebCam USB */
-	{USB_DEVICE(0x046d, 0x0870), .driver_info = BRIDGE_STV602 },
-	/* QuickCam Messenger */
-	{USB_DEVICE(0x046D, 0x08F0), .driver_info = BRIDGE_ST6422 },
-	/* QuickCam Communicate */
-	{USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },
-	/* QuickCam Messenger (new) */
-	{USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },
+	{USB_DEVICE(0x046d, 0x0840), .driver_info = BRIDGE_STV600 }, 	/* QuickCam Express */
+	{USB_DEVICE(0x046d, 0x0850), .driver_info = BRIDGE_STV610 },	/* LEGO cam / QuickCam Web */
+	{USB_DEVICE(0x046d, 0x0870), .driver_info = BRIDGE_STV602 },	/* Dexxa WebCam USB */
+	{USB_DEVICE(0x046D, 0x08F0), .driver_info = BRIDGE_ST6422 },	/* QuickCam Messenger */
+	{USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },	/* QuickCam Communicate */
+	{USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },	/* QuickCam Messenger (new) */
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
-- 
2.7.4


