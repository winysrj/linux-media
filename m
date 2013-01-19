Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:37099 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3ASXmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:42:39 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 15/24] usb/gspca/sonixb.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:22 -0200
Message-Id: <1358638891-4775-16-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
References: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_INPUT) || \
     defined(CONFIG_INPUT_MODULE)
with:
 #if IS_ENABLED(CONFIG_INPUT)

This change was made for: CONFIG_INPUT

Also replaced:
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
with:
 #if !IS_ENABLED(CONFIG_USB_SN9C102)

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
   Updated subject
   Fixed commit message

 drivers/media/usb/gspca/sonixb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
index 1220340..104ae25 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -1400,7 +1400,7 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 	return -EINVAL;
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
 			int len)		/* interrupt packet length */
@@ -1430,7 +1430,7 @@ static const struct sd_desc sd_desc = {
 	.pkt_scan = sd_pkt_scan,
 	.querymenu = sd_querymenu,
 	.dq_callback = do_autogain,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
 };
@@ -1448,7 +1448,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0c45, 0x600d), SB(PAS106, 101)},
 	{USB_DEVICE(0x0c45, 0x6011), SB(OV6650, 101)},
 	{USB_DEVICE(0x0c45, 0x6019), SB(OV7630, 101)},
-#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
+#if !IS_ENABLED(CONFIG_USB_SN9C102)
 	{USB_DEVICE(0x0c45, 0x6024), SB(TAS5130CXX, 102)},
 	{USB_DEVICE(0x0c45, 0x6025), SB(TAS5130CXX, 102)},
 #endif
-- 
1.7.11.7

