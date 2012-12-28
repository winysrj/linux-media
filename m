Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2L1Mah (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 07:30:37 -0500
Date: Fri, 28 Dec 2012 10:29:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
Message-ID: <20121228102928.4103390e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiri,

There's another radio device that it is incorrectly detected as an HID driver.
As I'll be applying the driver's patch via the media tree, do you mind if I also
apply this hid patch there?

Thanks!
Mauro

Forwarded message:

Date: Mon, 12 Nov 2012 07:57:03 +0100
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio


Don't let Masterkit MA901 USB radio be handled by usb hid drivers.

This device will be handled by radio-ma901.c driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5de3bb3..8e06569 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2025,6 +2025,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1dcb76f..17aa4f6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -533,6 +533,9 @@
 #define USB_VENDOR_ID_MADCATZ		0x0738
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 
+#define USB_VENDOR_ID_MASTERKIT			0x16c0
+#define USB_DEVICE_ID_MASTERKIT_MA901RADIO	0x05df
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a

