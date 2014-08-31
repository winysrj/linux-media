Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45369 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaHaLfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:36 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 5/7] [media] mceusb: add support for more cx231xx devices
Date: Sun, 31 Aug 2014 13:35:10 +0200
Message-Id: <1409484912-19300-6-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Add support for the si2161-based cx231xx devices:
	[2040:b138] Hauppauge WinTV HVR-900-H (model 111xxx)
	[2040:b139] Hauppauge WinTV HVR-901-H (model 1114xx)

They're similar to the already supported:
	[2040:b130] Hauppauge WinTV 930C-HD (model 1113xx)

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/rc/mceusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 45b0894..383e24a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -397,6 +397,10 @@ static struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb131),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb138),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb139),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_PCTV, 0x0259),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_PCTV, 0x025e),
-- 
2.1.0

