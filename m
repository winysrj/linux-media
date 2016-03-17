Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:36856 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935641AbcCQNLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 09:11:24 -0400
Received: by mail-lb0-f193.google.com with SMTP id sx8so181935lbb.3
        for <linux-media@vger.kernel.org>; Thu, 17 Mar 2016 06:11:23 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] mceusb: add support for SMK eHome receiver
Date: Thu, 17 Mar 2016 15:11:10 +0200
Message-Id: <1458220270-1650-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1458220270-1650-1-git-send-email-olli.salonen@iki.fi>
References: <1458220270-1650-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add USB ID of SMK RXX6000 series IR receiver. Often branded as
Lenovo receiver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/rc/mceusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 09ca9f6..5cf2e74 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -303,6 +303,9 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* SMK/I-O Data GV-MC7/RCKIT Receiver */
 	{ USB_DEVICE(VENDOR_SMK, 0x0353),
 	  .driver_info = MCE_GEN2_NO_TX },
+	/* SMK RXX6000 Infrared Receiver */
+	{ USB_DEVICE(VENDOR_SMK, 0x0357),
+	  .driver_info = MCE_GEN2_NO_TX },
 	/* Tatung eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_TATUNG, 0x9150) },
 	/* Shuttle eHome Infrared Transceiver */
-- 
1.9.1

