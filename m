Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37906 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdHMIzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 04:55:14 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: crope@iki.fi, mchehab@kernel.org, ezequiel@vanguardiasur.com.ar,
        laurent.pinchart@ideasonboard.com, royale@zerezo.com,
        sean@mess.org, klimov.linux@gmail.com, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] radio: constify usb_device_id
Date: Sun, 13 Aug 2017 14:24:45 +0530
Message-Id: <1502614485-2150-4-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/radio/dsbr100.c                 | 2 +-
 drivers/media/radio/radio-keene.c             | 2 +-
 drivers/media/radio/radio-ma901.c             | 2 +-
 drivers/media/radio/radio-mr800.c             | 2 +-
 drivers/media/radio/radio-raremono.c          | 2 +-
 drivers/media/radio/radio-shark.c             | 2 +-
 drivers/media/radio/radio-shark2.c            | 2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 53bc8c0..8521bb2 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -408,7 +408,7 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 	return retval;
 }
 
-static struct usb_device_id usb_dsbr100_device_table[] = {
+static const struct usb_device_id usb_dsbr100_device_table[] = {
 	{ USB_DEVICE(DSB100_VENDOR, DSB100_PRODUCT) },
 	{ }						/* Terminating entry */
 };
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 53a7c2e..f2ea8bc 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -45,7 +45,7 @@ MODULE_LICENSE("GPL");
 #define FREQ_MUL 16000U
 
 /* USB Device ID List */
-static struct usb_device_id usb_keene_device_table[] = {
+static const struct usb_device_id usb_keene_device_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB_KEENE_VENDOR, USB_KEENE_PRODUCT,
 							USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index c2010a9..fdc4812 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -444,7 +444,7 @@ static int usb_ma901radio_probe(struct usb_interface *intf,
 }
 
 /* USB Device ID List */
-static struct usb_device_id usb_ma901radio_device_table[] = {
+static const struct usb_device_id usb_ma901radio_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(USB_MA901_VENDOR, USB_MA901_PRODUCT,
 							USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 95c1253..c9f5912 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -587,7 +587,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
 }
 
 /* USB Device ID List */
-static struct usb_device_id usb_amradio_device_table[] = {
+static const struct usb_device_id usb_amradio_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(USB_AMRADIO_VENDOR, USB_AMRADIO_PRODUCT,
 							USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/radio-raremono.c
index bfb3a6d..3c0a22a 100644
--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -58,7 +58,7 @@ MODULE_LICENSE("GPL v2");
  */
 
 /* USB Device ID List */
-static struct usb_device_id usb_raremono_device_table[] = {
+static const struct usb_device_id usb_raremono_device_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
 };
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 23971f5..22f3466 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -392,7 +392,7 @@ static int usb_shark_resume(struct usb_interface *intf)
 #endif
 
 /* Specify the bcdDevice value, as the radioSHARK and radioSHARK2 share ids */
-static struct usb_device_id usb_shark_device_table[] = {
+static const struct usb_device_id usb_shark_device_table[] = {
 	{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
 			 USB_DEVICE_ID_MATCH_INT_CLASS,
 	  .idVendor     = 0x077d,
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index b50638e..4d1a4b3 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -358,7 +358,7 @@ static int usb_shark_resume(struct usb_interface *intf)
 #endif
 
 /* Specify the bcdDevice value, as the radioSHARK and radioSHARK2 share ids */
-static struct usb_device_id usb_shark_device_table[] = {
+static const struct usb_device_id usb_shark_device_table[] = {
 	{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
 			 USB_DEVICE_ID_MATCH_INT_CLASS,
 	  .idVendor     = 0x077d,
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 571f29a..c311f99 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -38,7 +38,7 @@
 
 
 /* USB Device ID List */
-static struct usb_device_id si470x_usb_driver_id_table[] = {
+static const struct usb_device_id si470x_usb_driver_id_table[] = {
 	/* Silicon Labs USB FM Radio Reference Design */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
 	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index e5e5a16..febc9c1 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -49,7 +49,7 @@ MODULE_LICENSE("GPL v2");
 #define USB_RESP_TIMEOUT		50000
 
 /* USB Device ID List */
-static struct usb_device_id usb_si4713_usb_device_table[] = {
+static const struct usb_device_id usb_si4713_usb_device_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB_SI4713_VENDOR, USB_SI4713_PRODUCT,
 							USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
-- 
2.7.4
