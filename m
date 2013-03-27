Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39140 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3C0UHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 16:07:40 -0400
Message-ID: <1364414849.3909.24.camel@samsungRC530>
Subject: [patch 1/2] hid: fix Masterkit MA901 hid quirks
From: Alexey Klimov <klimov.linux@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux@wagner-budenheim.de, klimov.linux@gmail.com
Date: Thu, 28 Mar 2013 00:07:29 +0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch reverts commit 0322bd3980b3ebf7dde8474e22614cb443d6479a and
adds checks in hid_ignore() for Masterkit MA901 usb radio device. This
usb radio device shares USB ID with many Atmel V-USB (and probably
other) devices so patch sorts things out by checking name, vendor,
product of hid device.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 512b01c..aa341d1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2077,7 +2077,6 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
@@ -2244,6 +2243,18 @@ bool hid_ignore(struct hid_device *hdev)
 		     hdev->product <= USB_DEVICE_ID_VELLEMAN_K8061_LAST))
 			return true;
 		break;
+	case USB_VENDOR_ID_ATMEL_V_USB:
+		/* Masterkit MA901 usb radio based on Atmel tiny85 chip and
+		 * it has the same USB ID as many Atmel V-USB devices. This
+		 * usb radio is handled by radio-ma901.c driver so we want
+		 * ignore the hid. Check the name, bus, product and ignore
+		 * if we have MA901 usb radio.
+		 */
+		if (hdev->product == USB_DEVICE_ID_ATMEL_V_USB &&
+			hdev->bus == BUS_USB &&
+			strncmp(hdev->name, "www.masterkit.ru MA901", 22) == 0)
+			return true;
+		break;
 	}
 
 	if (hdev->type == HID_TYPE_USBMOUSE &&
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92e47e5..57d9f3a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -158,6 +158,8 @@
 #define USB_VENDOR_ID_ATMEL		0x03eb
 #define USB_DEVICE_ID_ATMEL_MULTITOUCH	0x211c
 #define USB_DEVICE_ID_ATMEL_MXT_DIGITIZER	0x2118
+#define USB_VENDOR_ID_ATMEL_V_USB	0x16c0
+#define USB_DEVICE_ID_ATMEL_V_USB	0x05df
 
 #define USB_VENDOR_ID_AUREAL		0x0755
 #define USB_DEVICE_ID_AUREAL_W01RN	0x2626
@@ -557,9 +559,6 @@
 #define USB_VENDOR_ID_MADCATZ		0x0738
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 
-#define USB_VENDOR_ID_MASTERKIT			0x16c0
-#define USB_DEVICE_ID_MASTERKIT_MA901RADIO	0x05df
-
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a


