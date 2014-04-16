Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59131 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaDPStX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 14:49:23 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so9141801eek.39
        for <linux-media@vger.kernel.org>; Wed, 16 Apr 2014 11:49:22 -0700 (PDT)
From: Robert Butora <robert.butora.fi@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Cc: Robert Butora <robert.butora.fi@gmail.com>
Subject: [PATCH 1/1] media:gspca:dtcs033 Clean sparse check warnings on endianess
Date: Wed, 16 Apr 2014 20:46:49 +0200
Message-Id: <1397674009-10271-1-git-send-email-robert.butora.fi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warnings due to __le16 / u16 conversions.
Replace offending struct and so stay on cpu domain.

Signed-off-by: Robert Butora <robert.butora.fi@gmail.com>
---
 drivers/media/usb/gspca/dtcs033.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
index 5e42c71..96bfd4e 100644
--- a/drivers/media/usb/gspca/dtcs033.c
+++ b/drivers/media/usb/gspca/dtcs033.c
@@ -22,6 +22,13 @@ MODULE_AUTHOR("Robert Butora <robert.butora.fi@gmail.com>");
 MODULE_DESCRIPTION("Scopium DTCS033 astro-cam USB Camera Driver");
 MODULE_LICENSE("GPL");
 
+struct dtcs033_usb_requests {
+	u8 bRequestType;
+	u8 bRequest;
+	u16 wValue;
+	u16 wIndex;
+	u16 wLength;
+};
 
 /* send a usb request */
 static void reg_rw(struct gspca_dev *gspca_dev,
@@ -50,10 +57,10 @@ static void reg_rw(struct gspca_dev *gspca_dev,
 }
 /* send several usb in/out requests */
 static int reg_reqs(struct gspca_dev *gspca_dev,
-		    const struct usb_ctrlrequest *preqs, int n_reqs)
+		    const struct dtcs033_usb_requests *preqs, int n_reqs)
 {
 	int i = 0;
-	const struct usb_ctrlrequest *preq;
+	const struct dtcs033_usb_requests *preq;
 
 	while ((i < n_reqs) && (gspca_dev->usb_err >= 0)) {
 
@@ -290,7 +297,7 @@ module_usb_driver(sd_driver);
  0x40 =  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
  0xC0 =  USB_DIR_IN  | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 */
-static const struct usb_ctrlrequest dtcs033_start_reqs[] = {
+static const struct dtcs033_usb_requests dtcs033_start_reqs[] = {
 /* -- bRequest,wValue,wIndex,wLength */
 { 0x40, 0x01, 0x0001, 0x000F, 0x0000 },
 { 0x40, 0x01, 0x0000, 0x000F, 0x0000 },
@@ -414,7 +421,7 @@ static const struct usb_ctrlrequest dtcs033_start_reqs[] = {
 { 0x40, 0x01, 0x0003, 0x000F, 0x0000 }
 };
 
-static const struct usb_ctrlrequest dtcs033_stop_reqs[] = {
+static const struct dtcs033_usb_requests dtcs033_stop_reqs[] = {
 /* -- bRequest,wValue,wIndex,wLength */
 { 0x40, 0x01, 0x0001, 0x000F, 0x0000 },
 { 0x40, 0x01, 0x0000, 0x000F, 0x0000 },
-- 
1.8.3.2

