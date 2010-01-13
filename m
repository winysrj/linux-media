Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46239 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0AMT7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 14:59:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] HID: ignore afatech 9016
Date: Wed, 13 Jan 2010 20:59:33 +0100
Message-Id: <1263412773-23220-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's ignore the device altogether by HID layer. It's handled by
dvb-usb-remote driver properly already.

By now, FULLSPEED_INTERVAL quirk was used. It probably made things
better, but the remote ctrl was still a perfect X killer. This was
the last user of the particular quirk. So remove the quirk as well.

With input going through dvb-usb-remote, the remote works
perfectly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/usbhid/hid-core.c   |    8 --------
 drivers/hid/usbhid/hid-quirks.c |    2 +-
 include/linux/hid.h             |    1 -
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..36a1561 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -938,14 +938,6 @@ static int usbhid_start(struct hid_device *hid)
 
 		interval = endpoint->bInterval;
 
-		/* Some vendors give fullspeed interval on highspeed devides */
-		if (hid->quirks & HID_QUIRK_FULLSPEED_INTERVAL &&
-		    dev->speed == USB_SPEED_HIGH) {
-			interval = fls(endpoint->bInterval*8);
-			printk(KERN_INFO "%s: Fixing fullspeed to highspeed interval: %d -> %d\n",
-			       hid->name, endpoint->bInterval, interval);
-		}
-
 		/* Change the polling interval of mice. */
 		if (hid->collection->usage == HID_GD_MOUSE && hid_mousepoll_interval > 0)
 			interval = hid_mousepoll_interval;
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 38773dc..788d9a3 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -41,7 +41,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
 
-	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
+	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_IGNORE },
 
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
 	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8709365..4a33e16 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -311,7 +311,6 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
-#define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
 
 /*
-- 
1.6.5.7

