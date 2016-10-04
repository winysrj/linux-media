Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34680 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbcJDLNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2016 07:13:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id b201so13967053wmb.1
        for <linux-media@vger.kernel.org>; Tue, 04 Oct 2016 04:13:55 -0700 (PDT)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: linux-media@vger.kernel.org
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [PATCH] Add Cinergy S2 rev.4 support
Date: Tue,  4 Oct 2016 13:13:27 +0200
Message-Id: <20161004111327.2665-1-mrkiko.rs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch derives from previous one(s) by CrazyCat. I used the commit adding rev.3 to mainline Linux kernel as an example, so credits go to its author(s).
The hardware seems to scan and tune OK.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 5fb0c65..4bd1d13 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1642,6 +1642,7 @@ enum dw2102_table_entry {
 	TEVII_S632,
 	TERRATEC_CINERGY_S2_R2,
 	TERRATEC_CINERGY_S2_R3,
+	TERRATEC_CINERGY_S2_R4,
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
 	TECHNOTREND_S2_4600,
@@ -1671,6 +1672,7 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
 	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R2)},
 	[TERRATEC_CINERGY_S2_R3] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R3)},
+	[TERRATEC_CINERGY_S2_R4] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R4)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
-- 
2.10.0

