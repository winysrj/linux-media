Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:64589 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HUIaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:30:01 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: eduardo.valentin@nokia.com, Dinesh Ram <dinram@cisco.com>
Subject: [RFC PATCH 4/5] si4713 : HID blacklist Si4713 USB development board
Date: Wed, 21 Aug 2013 10:19:50 +0200
Message-Id: <c445ba6c1a5269f45c96040263ec3b7b95c189ff.1377073025.git.dinram@cisco.com>
In-Reply-To: <1377073191-29197-1-git-send-email-dinram@cisco.com>
References: <1377073191-29197-1-git-send-email-dinram@cisco.com>
In-Reply-To: <714c16de2d45c2ccfc2fc94b2770bbd00bfeb977.1377073025.git.dinram@cisco.com>
References: <714c16de2d45c2ccfc2fc94b2770bbd00bfeb977.1377073025.git.dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Si4713 development board contains a Si4713 FM transmitter chip
and is handled by the radio-usb-si4713 driver.
The board reports itself as (10c4:8244) Cygnal Integrated Products, Inc.
and misidentifies itself as a HID device in its USB interface descriptor.
This patch ignores this device as an HID device and hence loads the custom driver.

Signed-off-by: Dinesh Ram <dinram@cisco.com>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 36668d1..109510f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1977,6 +1977,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CMEDIA, USB_DEVICE_ID_CM109) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_HIDCOM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_ULTRAMOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ffe4c7a..2a38726 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -241,6 +241,8 @@
 #define USB_VENDOR_ID_CYGNAL		0x10c4
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
 
+#define USB_DEVICE_ID_CYGNAL_RADIO_SI4713       0x8244
+
 #define USB_VENDOR_ID_CYPRESS		0x04b4
 #define USB_DEVICE_ID_CYPRESS_MOUSE	0x0001
 #define USB_DEVICE_ID_CYPRESS_HIDCOM	0x5500
-- 
1.8.4.rc2

