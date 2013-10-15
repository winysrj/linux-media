Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx32.cern.ch ([137.138.144.178]:2343 "EHLO CERNMX32.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab3JOPZG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:06 -0400
From: Dinesh Ram <dinesh.ram@cern.ch>
To: <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <edubezval@gmail.com>,
	<dinesh.ram086@gmail.com>, Dinesh Ram <dinesh.ram@cern.ch>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [REVIEW PATCH 5/9] si4713 : HID blacklist Si4713 USB development board
Date: Tue, 15 Oct 2013 17:24:41 +0200
Message-ID: <c8377583c9c6cb40c19d407dea41ed0f7725e13a.1381850640.git.dinesh.ram@cern.ch>
In-Reply-To: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Si4713 development board contains a Si4713 FM transmitter chip
and is handled by the radio-usb-si4713 driver.
The board reports itself as (10c4:8244) Cygnal Integrated Products, Inc.
and misidentifies itself as a HID device in its USB interface descriptor.
This patch ignores this device as an HID device and hence loads the custom driver.

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5a8c011..e7f11b3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2107,6 +2107,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CMEDIA, USB_DEVICE_ID_CM109) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_HIDCOM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_ULTRAMOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9cbc7ab..d43e827 100644
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
1.7.9.5

